/**
 * Copyright (c) 2017, Ray Wang
 * All rights reserved
 * Author: RayWang
 */

#import "WRLanguage.h"
@interface WRLanguage ()
@property (nonatomic, strong, readwrite) NSMutableSet *nullableSymbolSet;
@property (nonatomic, strong, readwrite) NSMutableDictionary <NSString *, NSMutableSet<NSString *> *> *firstSets;
@property (nonatomic, strong, readwrite) NSMutableDictionary <NSString *, NSMutableSet<NSString *> *> *followSets;
@end

@implementation WRLanguage
- (instancetype)initWithRuleStrings:(NSArray <NSString *> *)rules
                     andStartSymbol:(NSString *)startSymbol {
  if (self = [super init]) {
    _grammars = [WRLanguage grammarWithRules:rules];

    _nonterminals = [NSSet setWithArray:[_grammars allKeys]];
    _startSymbol = startSymbol;
    [self addNonTerminalandTerminals];
    [self disposeNullableToken];
    [self computeFirstSets];
    [self computeFollowSets];
  }
  return self;
}

+ (WRLanguage *)CFGrammar4_1 {
  return [[self alloc] initWithRuleStrings:@[@"Expr -> Expr + Term",
      @"Expr -> Term",
      @"Term -> Term × Factor",
      @"Term -> Factor",
      @"Factor -> ( Expr )",
      @"Factor -> i"]
                            andStartSymbol:@"Expr"];
}

+ (NSDictionary <NSString *, NSArray <WRRule *> *> *)grammarWithRules:(NSArray <NSString *> *)rules {
  NSMutableDictionary *dict = [NSMutableDictionary dictionary];
  for (NSString *ruleStr in rules) {
    NSArray *rules = [WRRule rulesWithOrRuleStr:ruleStr];
    for (WRRule *rule in rules) {
      [self addRule:rule
          toGrammar:dict];
    }
  }
  return dict;
}

+ (void)addRule:(WRRule *)rule
      toGrammar:(NSMutableDictionary *)dict {
  NSMutableArray *array;
  NSString *symbol = rule.leftToken.symbol;
  if (array = dict[symbol]) {
    [array addObject:rule];
  } else {
    array = [NSMutableArray arrayWithObject:rule];
    [dict setValue:array
            forKey:symbol];
  }
}

+ (WRLanguage *)CFGrammar7_8 {
  WRToken *S = [WRToken tokenWithSymbol:@"S"];
  WRToken *E = [WRToken tokenWithSymbol:@"E"];
  WRToken *F = [WRToken tokenWithSymbol:@"F"];
  WRToken *Q = [WRToken tokenWithSymbol:@"Q"];
  WRToken *a = [WRToken tokenWithSymbol:@"a"];
  WRToken *m = [WRToken tokenWithSymbol:@"-"];
  WRToken *p = [WRToken tokenWithSymbol:@"+"];

  NSDictionary *dict = @{
    @"S": @[[WRRule ruleWithRuleStr:@"S -> E"]],
    @"E": @[[WRRule ruleWithRuleStr:@"E -> E Q F"],
      [WRRule ruleWithRuleStr:@"E -> F"]],
    @"F": @[[WRRule ruleWithRuleStr:@"F -> a"]],
    @"Q": @[[WRRule ruleWithRuleStr:@"Q -> +"],
      [WRRule ruleWithRuleStr:@"Q -> -"]]};
  NSSet *nonterminals =
    [NSSet setWithObjects:@"S",
                          @"E",
                          @"F",
                          @"Q", nil];
  NSSet *terminals =
    [NSSet setWithObjects:@"a",
                          @"m",
                          @"p", nil];

  WRLanguage *language = [[WRLanguage alloc] init];
  language.terminals = terminals;
  language.nonterminals = nonterminals;
  language.grammars = dict;
  language.startSymbol = @"S";
  [language disposeNullableToken];

  return language;
}

+ (WRLanguage *)CFGrammar7_17 {
  WRToken *S = [WRToken tokenWithSymbol:@"S"];
  WRToken *E = [WRToken tokenWithSymbol:@"E"];
  WRToken *F = [WRToken tokenWithSymbol:@"F"];
  WRToken *Q = [WRToken tokenWithSymbol:@"Q"];
  WRToken *a = [WRToken tokenWithSymbol:@"a"];
  WRToken *m = [WRToken tokenWithSymbol:@"*"];
  WRToken *d = [WRToken tokenWithSymbol:@"/"];

  NSDictionary *dict = @{
    @"S": @[[WRRule ruleWithRuleStr:@"S -> E"]],
    @"E": @[[WRRule ruleWithRuleStr:@"E -> E Q F"],
      [WRRule ruleWithRuleStr:@"E -> F"]],
    @"F": @[[WRRule ruleWithRuleStr:@"F -> a"]],
    @"Q": @[[WRRule ruleWithRuleStr:@"Q -> *"],
      [WRRule ruleWithRuleStr:@"Q -> /"],
      [WRRule ruleWithRuleStr:@"Q -> "]]};
  NSSet *nonterminals =
    [NSSet setWithObjects:@"S",
                          @"E",
                          @"F",
                          @"Q", nil];
  NSSet *terminals =
    [NSSet setWithObjects:@"a",
                          @"m",
                          @"d", nil];

  WRLanguage *language = [[WRLanguage alloc] init];
  language.nonterminals = nonterminals;
  language.terminals = terminals;
  language.grammars = dict;
  language.startSymbol = @"S";
  [language disposeNullableToken];

  return language;
}

+ (WRLanguage *)CFGrammar7_19 {
  return [[self alloc] initWithRuleStrings:@[@"S -> A A x", @"A -> "]
                            andStartSymbol:@"S"];
}

+ (WRLanguage *)CFGrammar_8_9 {
  return [[self alloc] initWithRuleStrings:@[@"Session -> Facts Question | ( Session ) Session",
      @"Facts -> Fact Facts| ",
      @"Fact -> ! string",
      @"Question -> ? string"]
                            andStartSymbol:@"Session"];
}

+ (WRLanguage *)CFGrammar_9_14 {
  return [[self alloc] initWithRuleStrings:@
    [@"S -> E $",
      @"E -> E - T | T ",
      @"T -> n",
      @"T -> ( E )"]
                            andStartSymbol:@"S"];
}

+ (WRLanguage *)CFGrammar_Add_Mult_1 {
  return [[self alloc] initWithRuleStrings:@[@"Expr ->  i | Expr + Expr | Expr × Expr"]
                            andStartSymbol:@"Expr"];
}

+ (WRLanguage *)CFGrammar_Test_First_1 {
  return [[self alloc] initWithRuleStrings:@[@"S ->  A B",
      @"A -> B b|",
      @"B -> A a|c|"]
                            andStartSymbol:@"S"];
}

+ (WRLanguage *)CFGrammar_SPFER_2 {
  return [[self alloc] initWithRuleStrings:@[@"S -> S S | b"]
                            andStartSymbol:@"S"];
}

+ (WRLanguage *)CFGrammar_SPFER_3 {
  return [[self alloc] initWithRuleStrings:@[@"S -> A T | a T",
      @"A -> a| B A",
      @"B ->",
      @"T -> b b b"]
                            andStartSymbol:@"S"];
}

+ (WRLanguage *)CFGrammar_EAC_3_4 { // right recursive
  return [[self alloc] initWithRuleStrings:@[@"Expr -> Expr + Term | Expr - Term | Term",
      @"Expr' -> + Term Expr'| - Term Expr' | ",
      @"Term -> Factor Term'",
      @"Term' -> × Factor Term'| ÷ Factor Term' | ",
      @"Factor -> ( Expr )| num | name"]
                            andStartSymbol:@"Expr"];
}

+ (WRLanguage *)CFGrammar_EAC_3_4_RR { // right recursive
  return [[self alloc] initWithRuleStrings:@[@"Expr -> Term Expr'",
      @"Expr' -> + Term Expr'| - Term Expr' | ",
      @"Term -> Factor Term'",
      @"Term' -> × Factor Term'| ÷ Factor Term' | ",
      @"Factor -> ( Expr )| num | name"]
                            andStartSymbol:@"Expr"];
}

# pragma mark tokens
- (void)addNonTerminalandTerminals {
  _nonterminals = [NSSet setWithArray:[_grammars allKeys]];
  NSMutableSet *set = [NSMutableSet set];
  for (NSArray *rules in self.grammars.allValues) {
    for (WRRule *rule in rules) {
      for (WRToken *token in rule.rightTokens) {
        if (![_nonterminals containsObject:token.symbol]) {
          [set addObject:token.symbol];
        }
      }
    }
  }
  _terminals = set;
}

# pragma mark Nullable function
- (void)disposeNullableToken {
  // initiate
  _nullableSymbolSet = [NSMutableSet set];
  NSMutableSet *undeterminedSet = [NSMutableSet setWithSet:self.nonterminals];
  // should be terminals only, all symbols are also fine

  NSMutableArray *workList = [NSMutableArray array];
  for (NSString *leftSymbol in self.grammars.allKeys) {
    for (WRRule *rule in self.grammars[leftSymbol]) {
      if (rule.rightTokens.count == 0) {
        // found nullable
        [workList addObject:leftSymbol];
        [self.nullableSymbolSet addObject:leftSymbol];
        [undeterminedSet removeObject:leftSymbol];
        break; // current symbol is found to be nullable, check the next one
      }
    }
  }

  // work loop
  for (NSUInteger i = 0; i < workList.count; i++) {
    NSString *currentSymbol = workList[i]; // TODO not used here
    NSString *foundSymbol = nil; // symbol just found is nullable
    for (NSString *undeterminedSymbol in undeterminedSet) {
      NSArray <WRRule *> *rules = self.grammars[undeterminedSymbol];
      for (WRRule *rule in rules) {
        BOOL isNullable = YES;
        // if all right tokens are nullable, it is nullable
        for (WRToken *token in rule.rightTokens) {
          if (![self.nullableSymbolSet containsObject:token.symbol]) {
            isNullable = NO;
            break;
          }
        }
        if (isNullable) {
          foundSymbol = undeterminedSymbol;
          break;
        }
      }
      if (foundSymbol) {
        break;
      }
    }
    if (foundSymbol) {
      [workList addObject:foundSymbol];
      [self.nullableSymbolSet addObject:foundSymbol];
      [undeterminedSet removeObject:foundSymbol];
    }
  }
}

- (BOOL)isTokenNullable:(WRToken *)token {
  return [self.nullableSymbolSet containsObject:token.symbol];
}

#pragma mark FirstSet function
- (void)computeFirstSets {
  // compute Fisrst set with eplison consideration

  _firstSets = [NSMutableDictionary dictionary];
  // use the fact that const NSString in OC is the same obj

  for (NSString *nonterminal in self.nonterminals) {
    NSMutableSet *set = [NSMutableSet set];
    [_firstSets setValue:set
                  forKey:nonterminal];
  }
  for (NSString *terminal in self.terminals) {
    NSMutableSet *set = [NSMutableSet setWithObject:terminal];
    [_firstSets setValue:set
                  forKey:terminal];
  }

  // First(A) = First(B) union First(C) if A->B...|C...
  // if A -> aB, and a is nullable, then Fisrt(A) U= First(B)
  // we compute the reverse of the map...
  NSMutableDictionary <NSString *, NSSet <NSString *> *> *formula = [NSMutableDictionary dictionary];
  for (NSString *nont in self.nonterminals) {
    for (WRRule *rule in self.grammars[nont]) {
      [rule.rightTokens enumerateObjectsUsingBlock:^(WRToken *_Nonnull token, NSUInteger idx, BOOL *_Nonnull stop) {
        NSMutableSet *set = formula[token.symbol];
        if (set == nil) {
          set = [NSMutableSet set];
          [formula setValue:set
                     forKey:token.symbol];
        }
        [set addObject:nont];
        *stop = [self isTokenNullable:token] ? NO : YES;
      }];
    }
  }

  NSMutableSet *changedTokens = [NSMutableSet setWithSet:self.terminals];
  NSMutableSet *tempTokens = [NSMutableSet set];

  while (changedTokens.count > 0) {
    for (NSString *changedToken in changedTokens) {
      NSMutableSet *unionSet = self.firstSets[changedToken];
      for (NSString *shouldUpdateToken in formula[changedToken]) {
        NSMutableSet *updateSet = self.firstSets[shouldUpdateToken];
        NSUInteger before = updateSet.count;
        [updateSet unionSet:unionSet];
        NSUInteger after = updateSet.count;
        if (before < after) {
          [tempTokens addObject:shouldUpdateToken];
        }
      }
    }
    [changedTokens removeAllObjects];
    NSMutableSet *t = changedTokens;
    changedTokens = tempTokens;
    tempTokens = t;
  }
}

#pragma mark FollowSet function
- (void)computeFollowSets {
  _followSets = [NSMutableDictionary dictionary];
  //add EOF to startSymbol's Follow
  [_followSets setValue:[NSMutableSet setWithObject:@"EOF"]
                 forKey:self.startSymbol];

  NSMutableDictionary <NSString *, NSSet <NSString *> *> *formula = [NSMutableDictionary dictionary];
  for (NSString *nont in self.grammars) {
    for (WRRule *rule in self.grammars[nont]) {
      NSMutableSet <NSString *>
        *firstSet = [NSMutableSet set]; // initiation use, should be Follow(A), however ,we do not have yet
      __block NSString *tailToken = nont;
      [rule.rightTokens
        enumerateObjectsWithOptions:NSEnumerationReverse
                         usingBlock:^(WRToken *_Nonnull token, NSUInteger idx, BOOL *_Nonnull stop) {
                           if (token.type == terminal) {
                             [firstSet removeAllObjects];
                             [firstSet addObject:token.symbol];
                             tailToken = nil;
                             return;
                           }
                           //1.1 add tail tokens to formula

                           if (tailToken) {
                             NSMutableSet <NSString *> *set = formula[tailToken];
                             if (nil == set) {
                               set = [NSMutableSet set];
                               [formula setValue:set
                                          forKey:tailToken];
                             }
                             [set addObject:token.symbol];
                           }

                           //1.2 initiation with first sets
                           NSMutableSet *followSet = _followSets[token.symbol];
                           if (nil == followSet) {
                             followSet = [NSMutableSet set];
                             [_followSets setValue:followSet
                                            forKey:token.symbol];
                           }
                           [followSet unionSet:firstSet];

                           //2.1 update
                           tailToken = [self isTokenNullable:token] ? tailToken : nil;

                           //2.2 update firstSet
                           // TODO merge 1.2
                           if (![self isTokenNullable:token]) {
                             [firstSet removeAllObjects];
                           }
                           [firstSet unionSet:_firstSets[token.symbol]];
                         }];
    }
  }

  NSMutableSet *changedTokens = [NSMutableSet setWithSet:self.nonterminals];
//  [changedTokens unionSet:self.nonterminals];
  NSMutableSet *tempTokens = [NSMutableSet set];

  while (changedTokens.count > 0) {
    for (NSString *changedToken in changedTokens) {
      NSMutableSet *unionSet = _followSets[changedToken];
      for (NSString *shouldUpdateToken in formula[changedToken]) {
        NSMutableSet *updateSet = _followSets[shouldUpdateToken];
        NSUInteger before = updateSet.count;
        [updateSet unionSet:unionSet];
        NSUInteger after = updateSet.count;
        if (before < after) {
          [tempTokens addObject:shouldUpdateToken];
        }
      }
    }
    [changedTokens removeAllObjects];
    NSMutableSet *t = changedTokens;
    changedTokens = tempTokens;
    tempTokens = t;
  }

  NSLog(@"done");
}

- (NSSet <NSString *> *)firstSetForToken:(WRToken *)token {
  return self.firstSets[token.symbol];
}

- (NSSet <NSString *> *)followSetForToken:(WRToken *)token {
  return self.followSets[token.symbol];
}
@end
