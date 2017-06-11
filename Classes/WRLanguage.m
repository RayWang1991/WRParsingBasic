/**
 * Copyright (c) 2017, Ray Wang
 * All rights reserved
 * Author: RayWang
 */

#import "WRLanguage.h"
@interface WRLanguage ()
@property(nonatomic, strong, readwrite)NSMutableSet *nullableSymbolSet;
@end

@implementation WRLanguage
- (instancetype)initWithRuleStrings:(NSArray <NSString *>*)rules andStartSymbol:(NSString *)startSymbol{
  if(self = [super init]){
    _grammars = [WRLanguage grammarWithRules:rules];
    _symbols = [NSSet setWithArray:[_grammars allKeys]];
    _startSymbol = startSymbol;
    [self disposeNullableToken];
  }
  return self;
}

//TODO update later
/*
+ (WRLanguage *)CFGrammar6_6{
  WRLanguage *language = [[WRLanguage alloc]init];
  NSSet *symbols =
    [NSSet setWithObjects:@"S",@"A",@"B",@"C",@"D",@"a",@"b",@"c",@"#", nil];
  WRToken *a = [WRToken tokenWithType:terminal andSymbol:@"a"];
  WRToken *b = [WRToken tokenWithType:terminal andSymbol:@"b"];
  WRToken *c = [WRToken tokenWithType:terminal andSymbol:@"c"];
  WRToken *S = [WRToken tokenWithType:nonTerminal andSymbol:@"S"];
  WRToken *A = [WRToken tokenWithType:nonTerminal andSymbol:@"A"];
  WRToken *B = [WRToken tokenWithType:nonTerminal andSymbol:@"B"];
  WRToken *C = [WRToken tokenWithType:nonTerminal andSymbol:@"C"];
  WRToken *D = [WRToken tokenWithType:nonTerminal andSymbol:@"D"];

  NSDictionary *grammars = @{@"S":@[@[A,B],
                                    @[D,C]],
                             @"A":@[@[a],
                                    @[a,A]],
                             @"B":@[@[b,c],
                                    @[b,B,c]],
                             @"D":@[@[a,b],
                                    @[a,D,b]],
                             @"C":@[@[c],
                                    @[c,C]]};
  language.symbols = symbols;
  language.grammars = grammars;
  language.startToken = S;
  return language;
}
*/

+ (NSDictionary <NSString *, NSArray <WRRule *>*>*)grammarWithRules:(NSArray <NSString *> *)rules{
  NSMutableDictionary *dict = [NSMutableDictionary dictionary];
  for(NSString *ruleStr in rules){
    WRRule *rule = [WRRule ruleWithRuleStr:ruleStr];
    NSMutableArray *array;
    NSString *symbol = rule.leftToken.symbol;
    if(array = dict[symbol]){
      [array addObject:rule];
    }else{
      array = [NSMutableArray arrayWithObject:rule];
      [dict setValue:array forKey:symbol];
    }
  }
  return dict;
}

+ (WRLanguage *)CFGrammar7_8{
  WRToken *S = [WRToken tokenWithSymbol:@"S"];
  WRToken *E = [WRToken tokenWithSymbol:@"E"];
  WRToken *F = [WRToken tokenWithSymbol:@"F"];
  WRToken *Q = [WRToken tokenWithSymbol:@"Q"];
  WRToken *a = [WRToken tokenWithSymbol:@"a"];
  WRToken *m = [WRToken tokenWithSymbol:@"-"];
  WRToken *p = [WRToken tokenWithSymbol:@"+"];

  NSDictionary *dict = @{
                         @"S":@[[WRRule ruleWithRuleStr:@"S -> E"]],
                         @"E":@[[WRRule ruleWithRuleStr:@"E -> E Q F"],
                                [WRRule ruleWithRuleStr:@"E -> F"]],
                         @"F":@[[WRRule ruleWithRuleStr:@"F -> a"]],
                         @"Q":@[[WRRule ruleWithRuleStr:@"Q -> +"],
                                [WRRule ruleWithRuleStr:@"Q -> -"]]};
  NSSet *symbols =
  [NSSet setWithObjects:@"S",@"E",@"F",@"Q",@"a",@"m",@"p", nil];
  
  WRLanguage *language = [[WRLanguage alloc]init];
  language.symbols = symbols;
  language.grammars = dict;
  language.startSymbol = @"S";
  [language disposeNullableToken];
  
  return language;
}

- (void)disposeNullableToken{
  // initiate
  _nullableSymbolSet = [NSMutableSet set];
  NSMutableSet *undeterminedSet = [NSMutableSet setWithSet:self.symbols];
  // should be terminals only, all symbols are also fine
  
  NSMutableArray *workList = [NSMutableArray array];
  for(NSString *leftSymbol in self.grammars.allKeys){
    for(WRRule *rule in self.grammars[leftSymbol]){
      if(rule.rightTokens.count == 0){
        // found nullable
        [workList addObject:leftSymbol];
        [self.nullableSymbolSet addObject:leftSymbol];
        [undeterminedSet removeObject:leftSymbol];
        break; // current symbol is found to be nullable, check the next one
      }
    }
  }
  
  // work loop
  for(NSUInteger i = 0; i< workList.count; i++){
    NSString *currentSymbol = workList[i]; // TODO not used here
    NSString *foundSymbol = nil; // symbol just found is nullable
    for(NSString *undeterminedSymbol in undeterminedSet){
      NSArray <WRRule *>*rules = self.grammars[undeterminedSymbol];
      for(WRRule *rule in rules){
        BOOL isNullable = YES;
        // if all right tokens are nullable, it is nullable
        for(WRToken *token in rule.rightTokens){
          if(![self.nullableSymbolSet containsObject: token.symbol]){
            isNullable = NO;
            break;
          }
        }
        if(isNullable) {
          foundSymbol = undeterminedSymbol;
          break;
        }
      }
      if(foundSymbol){
        break;
      }
    }
    if(foundSymbol){
      [workList addObject:foundSymbol];
      [self.nullableSymbolSet addObject:foundSymbol];
      [undeterminedSet removeObject:foundSymbol];
    }
  }
}

- (BOOL)isTokenNullable:(WRToken *)token{
  return [self.nullableSymbolSet containsObject:token.symbol];
}


@end
