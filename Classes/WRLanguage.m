@import "WRWRLanguage.h"

@implementation WRLanguage
- (instancetype)init{
  if(self = [super init]){
  }
  return self;
}

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
  language.startWRToken = S;
  return language;
}

@end
