/* Basic LR(0) Parser Generator
 * Ref: 'Parsing Techniques' Chap 9.5
 * Author: Ray Wang
 * Date: 2017.6.30
 */

#import "WRLR0Parser.h"
#pragma mark error for LR0
NSString *const kWRLR0ParserErrorDomain = @"erorr.Parser.LR0";

typedef NS_ENUM(NSInteger, WRLR0DFAActionError) {
  WRLR0DFAActionErrorShiftReduceConflict,
  WRLR0DFAActionErrorReduceReduceConflict,
};

#pragma mark NFAState
@interface WRLR0NFAState ()
@end

@implementation WRLR0NFAState

+ (instancetype)NFAStateWithSymbol:(NSString *)symbol
                              type:(WRLR0NFAStateType)type
                        andContent:(id)content; {
  WRLR0NFAState *state = [[WRLR0NFAState alloc] init];
  state.symbol = symbol;
  state.type = type;
  state.content = content;
  return state;
}

+ (instancetype)NFAStateWithContent:(id)content {
  if ([content isKindOfClass:[WRItem class]]) {
    WRItem *item = content;
    return [self NFAStateWithSymbol:item.dotedRule
                               type:WRLR0NFAStateTypeItem
                         andContent:content];
  } else {
    assert([content isKindOfClass:[NSString class]]);
    NSString *token = content;
    return [self NFAStateWithSymbol:token
                               type:WRLR0NFAStateTypeToken
                         andContent:content];
  }
}

- (NSMutableArray <WRLR0NFATransition *> *)transitionList {
  if (nil == _transitionList) {
    _transitionList = [NSMutableArray array];
  }
  return _transitionList;
}

- (void)addTransition:(WRLR0NFATransition *)transition {
  [self.transitionList addObject:transition];
}

// override

- (NSString *)description {
  return self.symbol;
}

@end

#pragma mark NFATransition
@implementation WRLR0NFATransition

+ (instancetype)NFATransitionWithFromState:(WRLR0NFAState *)from
                                   toState:(WRLR0NFAState *)to
                            andConsumption:(NSString *)consumption {
  WRLR0NFATransitionType type = consumption ? WRLR0NFATransitionTypeNormal : WRLR0NFATransitionTypeEpsilon;
  WRLR0NFATransition *transition = [[WRLR0NFATransition alloc] init];
  transition.type = type;
  transition.from = from;
  transition.to = to;
  transition.consumption = consumption;
  return transition;
}

- (NSString *)description {
  return [NSString stringWithFormat:@"%@ --%@--> %@",
                                    _from,
                                    _consumption,
                                    _to];
}
@end

#pragma mark DFAStates
@implementation WRLR0DFAState

- (instancetype)initWithNFAStates:(NSMutableSet<WRLR0NFAState *> *)nfaStates {
  if (self = [super init]) {
    _nfaStates = nfaStates;
    _transitionDict = [NSMutableDictionary dictionaryWithCapacity:16];
  }
  return self;
}

+ (instancetype)DFAStateWithNFAStates:(NSMutableSet < WRLR0NFAState *> *)nfaStates {
  return [[WRLR0DFAState alloc] initWithNFAStates:nfaStates];
}

#pragma mark helper : to speed up the look up
- (NSString *)contentStr {
  // ### important ###
  // must call after the nfa set is determined
  if (nil == _contentStr) {
    _contentStr = [WRLR0DFAState contentStrForNFAStates:self.nfaStates];
  }
  return _contentStr;
}

- (NSString *)description {
  return self.contentStr;
}

+ (NSString *)contentStrForNFAStates:(NSSet<WRLR0NFAState *> *)nfaStates {
  NSArray *array = [nfaStates allObjects];
  array = [array sortedArrayUsingComparator:^NSComparisonResult(WRLR0NFAState *state1, WRLR0NFAState *state2) {
    return [state1.symbol compare:state2.symbol];
  }];
  NSMutableString *str = [NSMutableString string];
  for (WRLR0NFAState *state in array) {
    [str appendFormat:@"%@\n",
                      state.symbol];
  }
  return [NSString stringWithString:str];
}

#pragma mark getter
- (NSMutableDictionary<NSString *, WRLR0DFAState *> *)transitionDict {
  if (nil == _transitionDict) {
    _transitionDict = [NSMutableDictionary dictionary];
  }
  return _transitionDict;
}
@end

@interface WRLR0Parser ()
// NFA
@property (nonatomic, strong, readwrite) WRLR0NFAState *NFAStartState;
@property (nonatomic, strong, readwrite) NSMutableDictionary <NSString *, WRLR0NFAState *> *NFAStateRecordSet;
@property (nonatomic, strong, readwrite) NSMutableDictionary <NSString *, WRLR0NFATransition *> *NFATransitionRecordSet;
@property (nonatomic, strong, readwrite) NSMutableArray <WRLR0NFAState *> *NFAWorkList;
@end

@interface WRLR0Parser ()
// DFA
@property (nonatomic, strong, readwrite) WRLR0DFAState *DFAStartState;
@property (nonatomic, strong, readwrite) NSMutableDictionary <NSString *, WRLR0DFAState *> *DFARecordSet;
@property (nonatomic, strong, readwrite) NSMutableArray <NSError *> *conflicts;
@property (nonatomic, strong, readwrite) NSMutableArray <WRLR0DFAState *> *DFAWorkList;
@end

@interface WRLR0Parser ()
// parsing runtime
@property (nonatomic, strong, readwrite) NSMutableArray <WRToken *> *tokenStack;
@property (nonatomic, strong, readwrite) NSMutableArray <WRToken *> *inputStack;
@property (nonatomic, strong, readwrite) NSMutableArray <WRLR0DFAState *> *stateStack;
@property (nonatomic, strong, readwrite) NSMutableArray <NSError *> *errors;
@end

@implementation WRLR0Parser

#pragma mark - pre construction

- (void)prepare {
  assert(_language);
  assert(_scanner);

  [self constructNFA];
  [self printAllNFAStates];
  [self printAllNFATransitions];
  [self constructDFA];
  assert(self.conflicts.count == 0);
  [self printAllDFAStatesAndTransitions];
}

#pragma mark NFA construction
- (void)constructNFA {
  // initiation
  _NFAStateRecordSet = [NSMutableDictionary dictionary];
  _NFATransitionRecordSet = [NSMutableDictionary dictionary];
  _NFAWorkList = [NSMutableArray array];

  // 1. add Stations 2. add rule 3. map states to stations
  for (NSString *nontStr in self.language.grammars.allKeys) {
    // add station
    assert(nontStr.tokenTypeForString == WRTokenTypeNonterminal);

    WRLR0NFAState *station = _NFAStateRecordSet[nontStr];
    if (nil == station) {
      station = [WRLR0NFAState NFAStateWithContent:nontStr];

      [_NFAStateRecordSet setValue:station
                            forKey:station.symbol];
    }

    for (WRRule *rule in self.language.grammars[nontStr]) {
      // add rule and map states to stations
      [self addRule:rule
          toStation:station];
    }
  }
  _NFAStartState = _NFAStateRecordSet[self.language.startSymbol];
  assert(_NFAStartState);
}

- (void)addRule:(WRRule *)rule
      toStation:(WRLR0NFAState *)station {
  assert(station.type == WRLR0NFAStateTypeToken);
  // add first state to station
  WRItem *item = [WRItem itemWithRule:rule
                          dotPosition:0
                       askingPosition:-1];
  WRLR0NFAState *state = [WRLR0NFAState NFAStateWithContent:item];
  [_NFAStateRecordSet setValue:state
                        forKey:state.symbol];
  WRLR0NFATransition *transition = [WRLR0NFATransition NFATransitionWithFromState:station
                                                                          toState:state
                                                                   andConsumption:nil];
  [station addTransition:transition];
  // just debug use
  [_NFATransitionRecordSet setValue:transition
                             forKey:transition.description];

  // increase the chain, and ### by the way ### map the state to station
  WRLR0NFAState *nextState = nil;
  WRItem *nextItem = nil;
  NSString *consumptionToken = nil;
  while (![item isComplete]) {

    consumptionToken = item.nextAskingToken;

    nextItem = [WRItem itemWithRule:item
                        dotPosition:item.dotPos + 1
                     askingPosition:-1];

    nextState = [WRLR0NFAState NFAStateWithContent:nextItem];
    [_NFAStateRecordSet setValue:nextState
                          forKey:nextState.symbol];

    transition = [WRLR0NFATransition NFATransitionWithFromState:state
                                                        toState:nextState
                                                 andConsumption:consumptionToken];
    [state addTransition:transition];
    [_NFATransitionRecordSet setValue:transition
                               forKey:transition.description];

    if (consumptionToken.tokenTypeForString == WRTokenTypeNonterminal) {
      station = _NFAStateRecordSet[consumptionToken];
      if (nil == station) {
        station = [WRLR0NFAState NFAStateWithContent:consumptionToken];
        [_NFAStateRecordSet setValue:station
                              forKey:consumptionToken];
      }
      transition = [WRLR0NFATransition NFATransitionWithFromState:state
                                                          toState:station
                                                   andConsumption:nil];
      [state addTransition:transition];
      [_NFATransitionRecordSet setValue:transition
                                 forKey:transition.description];
    }
    item = nextItem;
    state = nextState;
  }
}

- (void)printAllNFAStates {
  printf("All NFA States:\n");
  for (NSString *stateStr in self.NFAStateRecordSet.allKeys) {
    printf("  %s\n", [stateStr UTF8String]);
  }
}

- (void)printAllNFATransitions {
  printf("All NFA Transitions:\n");
  for (NSString *transitionStr in self.NFATransitionRecordSet.allKeys) {
    printf("  %s\n", [transitionStr UTF8String]);
  }
}

#pragma mark DFA construction
static int stateId = 0;
- (void)constructDFA {
  // initiation
  _DFARecordSet = [NSMutableDictionary dictionary];
  _conflicts = [NSMutableArray array];
  _DFAWorkList = [NSMutableArray array];
  stateId = 0;

  // start state
  NSMutableSet <WRLR0NFAState *> *nfaStates = [self epsilonClosureOfNFAState:_NFAStartState];
  _DFAStartState = [self DFAStateWithNFAStates:nfaStates];

  [_DFAWorkList addObject:_DFAStartState];
  // work loop
  while (_DFAWorkList.count) {
    WRLR0DFAState *toDoDFAState = [_DFAWorkList lastObject];
    toDoDFAState.stateId = stateId++;
    [_DFAWorkList removeLastObject];
    [_DFARecordSet setValue:toDoDFAState
                     forKey:toDoDFAState.contentStr];
    NSDictionary <NSString *, NSArray *> *transitionTokenDict =
      [self transitionTokenDictForNFAStates:toDoDFAState.nfaStates];
    for (NSString *tokenSymbol in transitionTokenDict) {
      // compute epsilon closure on a transition token
      NSMutableSet *nextNFASet = [NSMutableSet set];
      for (WRLR0NFATransition *transition in transitionTokenDict[tokenSymbol]) {
        [nextNFASet addObject:transition.to];
      }
      nextNFASet = [self epsilonClosureOfNFAStateSet:nextNFASet];

      // find the next DFA state, and mark a transition(use transition dict here)
      NSString *nfaContentStr = [WRLR0DFAState contentStrForNFAStates:nextNFASet];
      WRLR0DFAState *nextDFAState = self.DFARecordSet[nfaContentStr];

      if (!nextDFAState) {
        nextDFAState = [self DFAStateWithNFAStates:nextNFASet];
        [self.DFARecordSet setValue:nextDFAState
                             forKey:nfaContentStr];
        // add to work list
        [self.DFAWorkList addObject:nextDFAState];
      }
      [toDoDFAState.transitionDict setValue:nextDFAState
                                     forKey:tokenSymbol];

    }
  }
}

#pragma mark transition token helper
- (NSMutableDictionary <NSString *, NSMutableArray <WRLR0NFATransition *> *> *)
transitionTokenDictForNFAStates:(NSSet<WRLR0NFAState *> *)nfaStates {
  NSMutableDictionary <NSString *, NSMutableArray <WRLR0NFATransition *> *> *dict = [NSMutableDictionary dictionary];
  for (WRLR0NFAState *nfaState in nfaStates) {
    for (WRLR0NFATransition *transition in nfaState.transitionList) {
      if (transition.type == WRLR0NFATransitionTypeNormal) {
        NSString *symbol = transition.consumption;
        if (nil == dict[symbol]) {
          [dict setValue:[NSMutableArray arrayWithObject:transition]
                  forKey:symbol];
        } else {
          [dict[symbol] addObject:transition];
        }
      }
    }
  }
  return dict;
}

#pragma mark epsilon closure computation
- (NSMutableSet <WRLR0NFAState *> *)epsilonClosureOfNFAState:(WRLR0NFAState *)toDoNFAState {
  NSMutableSet *set = [NSMutableSet setWithObject:toDoNFAState];

  NSInteger lastCount = 0, currentCount = 1;
  while (lastCount < currentCount) {
    lastCount = currentCount;
    for (WRLR0NFAState *nfaState in set.allObjects) {
      for (WRLR0NFATransition *transition in nfaState.transitionList) {
        if (transition.type == WRLR0NFATransitionTypeEpsilon) {
          WRLR0NFAState *toState = transition.to;
          // add is ok, we can make sure that there is only one nfa state for each doted item
          [set addObject:toState];
        }
      }
    }
    currentCount = set.count;
  }
  // remove all station(token content NFA state), just for convenience
  NSMutableArray *array = [NSMutableArray array];
  for (WRLR0NFAState *state in set) {
    if (state.type == WRLR0NFAStateTypeToken) {
      [array addObject:state];
    }
  }
  for (WRLR0NFAState *state in array) {
    [set removeObject:state];
  }
  return set;
}

- (NSMutableSet <WRLR0DFAState *> *)epsilonClosureOfNFAStateSet:(NSSet <WRLR0NFAState *> *)toDoNFAStateSet {
  NSMutableSet *set = [NSMutableSet set];
  for (WRLR0NFAState *state in toDoNFAStateSet) {
    [set unionSet:[self epsilonClosureOfNFAState:state]];
  }
  return set;
}

#pragma mark DFA state dispose
//#### important , dispose the action/goto here ####
- (WRLR0DFAState *)DFAStateWithNFAStates:(NSMutableSet *)nfaStates {
  assert(nfaStates.count);
  BOOL foundAction = NO;
  WRLR0DFAActionType foundType = WRLR0DFAActionTypeShift;
  NSString *foundReduceSymbol = @"";
  NSInteger foundReduceRuleIndex = 0;
  for (WRLR0NFAState *nfaState in nfaStates) {
    assert([nfaState.content isKindOfClass:[WRItem class]]);
    WRItem *item = nfaState.content;
    if (item.isComplete) {
      NSString *reduceSymbol = item.leftToken;
      if (foundAction) {
        if (foundType != WRLR0DFAActionTypeReduce) {
          NSString *str = [WRLR0DFAState contentStrForNFAStates:nfaStates];
          NSError *error = [NSError errorWithDomain:kWRLR0ParserErrorDomain
                                               code:WRLR0DFAActionErrorShiftReduceConflict
                                           userInfo:@{@"state": str}];
          [self.conflicts addObject:error];
        } else if (![foundReduceSymbol isEqualToString:reduceSymbol] || foundReduceRuleIndex != item.ruleIndex) {
          NSString *str = [WRLR0DFAState contentStrForNFAStates:nfaStates];
          NSError *error = [NSError errorWithDomain:kWRLR0ParserErrorDomain
                                               code:WRLR0DFAActionErrorReduceReduceConflict
                                           userInfo:@{@"state": str}];
          [self.conflicts addObject:error];
        }
      } else {
        foundAction = YES;
        foundType = WRLR0DFAActionTypeReduce;
        foundReduceSymbol = reduceSymbol;
        foundReduceRuleIndex = item.ruleIndex;
      }
    } else {
      if (foundAction) {
        if (foundType != WRLR0DFAActionTypeShift) {
          NSString *str = [WRLR0DFAState contentStrForNFAStates:nfaStates];
          NSError *error = [NSError errorWithDomain:kWRLR0ParserErrorDomain
                                               code:WRLR0DFAActionErrorShiftReduceConflict
                                           userInfo:@{@"state": str}];
          [self.conflicts addObject:error];
        }
        // can not be a shift/shift conflict due to the subset construction
      } else {
        foundAction = YES;
        foundType = WRLR0DFAActionTypeShift;
        foundReduceSymbol = @"";
      }
    }
  }
  WRLR0DFAState *dfaState = [WRLR0DFAState DFAStateWithNFAStates:nfaStates];
  assert(foundAction);
  dfaState.actionType = foundType;
  dfaState.reduceTokenSymbol = foundReduceSymbol;
  dfaState.reduceRuleIndex = foundReduceRuleIndex;
  return dfaState;
}

#pragma mark DFA debug
- (void)printAllDFAStatesAndTransitions {
  printf("All DFA States and Transitions:\n");
  for (WRLR0DFAState *dfaState in self.DFARecordSet.allValues) {
    NSString *stateStr = [WRUtils debugStrWithTabs:2
                                         forString:dfaState.contentStr];
    printf("state ID: %ld ", (long) dfaState.stateId);
    if (dfaState.actionType == WRLR0DFAActionTypeShift) {
      printf("shift state\n");
      printf("%s", stateStr.UTF8String);
      for (NSString *transitionTokenStr in dfaState.transitionDict) {
        printf("    --\'%s\'--> %ld\n", transitionTokenStr.UTF8String,
               (long) dfaState.transitionDict[transitionTokenStr].stateId);
      }
    } else {
      WRRule *reduceRule = self.language.grammars[dfaState.reduceTokenSymbol][dfaState.reduceRuleIndex];
      printf("reduce state, using %s\n", reduceRule.description.UTF8String);
      printf("%s", stateStr.UTF8String);
    }
  }
}

#pragma mark - run DFA parser
- (void)startParsing {
  // construct the parse tree at run time
  [self.scanner resetTokenIndex];
  [self.scanner scanToEnd];
  [self.scanner resetTokenIndex];

  _errors = [NSMutableArray array];
  _tokenStack = [NSMutableArray array];
  _inputStack = [NSMutableArray arrayWithCapacity:self.scanner.tokens.count * 2];
  [self.scanner.tokens enumerateObjectsWithOptions:NSEnumerationReverse
                                        usingBlock:^(WRTerminal *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                                          [self.inputStack addObject:obj];
                                        }];

  _stateStack = [NSMutableArray arrayWithObject:self.DFAStartState];
  WRLR0DFAState *state = nil;
  WRToken *currentToken = nil;
  WRToken *nextToken = nil;

  while (true) {
    state = self.stateStack.lastObject;
    if (self.inputStack.count == 1 &&
      [self.inputStack.firstObject.symbol isEqualToString:self.language.startSymbol]) {
      // check if the reduced state is start
      // parsing success
      self.parseTree = self.inputStack.firstObject;
      break;
    }
    // current token is reduced to start symbol, and the scanner runs out of terminal
    if (state.actionType == WRLR0DFAActionTypeReduce) {
      // to reduce
      WRNonterminal *reducedToken = [WRNonterminal tokenWithSymbol:state.reduceTokenSymbol];
      reducedToken.ruleIndex = state.reduceRuleIndex;
      WRRule *reduceRule = self.language.grammars[reducedToken.symbol][reducedToken.ruleIndex];
      NSUInteger length = reduceRule.rightTokens.count;
      assert(self.tokenStack.count >= length);
      NSRange childrenRange = NSMakeRange(self.tokenStack.count - length, length);
      NSArray *children = [self.tokenStack subarrayWithRange:childrenRange];
      [self.tokenStack removeObjectsInRange:childrenRange];
      reducedToken.children = children;
      assert(self.stateStack.count >= length);
      NSRange stateRange = NSMakeRange(self.stateStack.count - length, length);
      [self.stateStack removeObjectsInRange:stateRange];
      [self.inputStack addObject:reducedToken];
    } else {
      // shift state
      // shift the next input token onto the stack
      currentToken = [self.inputStack lastObject];
      if (nil == currentToken) {
        [self.errors addObject:[self errorOnCode:WRLR0ParsingErrorTypeRunOutOfToken
                                  withInputToken:nil
                                      onDFAState:state]];
        [self printLastError];
        assert(NO);
        break;
      } else {
        state = state.transitionDict[currentToken.symbol];
        if (nil == state) {
          // next token must be terminal ?
          [self.errors addObject:[self errorOnCode:WRLR0ParsingErrorTypeUnsupportedTransition
                                    withInputToken:(WRTerminal *) currentToken
                                        onDFAState:state]];
          [self printLastError];
          assert(NO);
          break;
        } else {
          [self.stateStack addObject:state];
          [self.inputStack removeLastObject];
          [self.tokenStack addObject:currentToken];
        }
      }
    }
  }
}

- (NSError *)errorOnCode:(WRLR0ParsingError)type
          withInputToken:(WRTerminal *)inputToken
              onDFAState:(WRLR0DFAState *)state {
  // compute the valid tokens (terminals)

  NSMutableString *availableTokens = [NSMutableString string];
  // TODO, use index to present the token
  for (NSString *str in state.transitionDict.allKeys) {
    if (str.tokenTypeForString == WRTokenTypeTerminal && state.transitionDict[str]) {
      [availableTokens appendFormat:@" %@",
                                    str];
    }
  }

  NSString *content = @"";
  switch (type) {
    case WRLR0ParsingErrorTypeRunOutOfToken: {
      content = [NSString stringWithFormat:@"run out of token, on expecting:%@\n",
                                           availableTokens];
      break;
    }
    case WRLR0ParsingErrorTypeUnsupportedTransition: {
      content =
        [NSString stringWithFormat:@"unsupported transition on input:%@ at line%ld, column%ld, do you mean:%@ ?\n",
                                   inputToken.symbol,
                                   inputToken.contentInfo.line,
                                   inputToken.contentInfo.column,
                                   availableTokens];
      break;
    }
    default:break;
  }
  NSError *error = [NSError errorWithDomain:kWRLR0ParserErrorDomain
                                       code:type
                                   userInfo:@{@"content": content}];
  return error;
}

- (void)printLastError {
  printf("%s", [self.errors.lastObject.userInfo[@"content"] UTF8String]);
}

@end
