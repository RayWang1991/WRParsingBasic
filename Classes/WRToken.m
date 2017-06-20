#import "WRToken.h"

@implementation WRToken

- (instancetype)initWithType:(WRTokenType)type andSymbol:(NSString *)symbol{
  if(self = [super init]){
    _type = type;
    _symbol = symbol;
  }
  return self;
}

+ (WRToken *)tokenWithType:(WRTokenType)type andSymbol:(NSString *)symbol{
  WRToken *token = [[WRToken alloc]initWithType:type andSymbol:symbol];
  return token;
}

- (instancetype)initWithSymbol:(NSString *)symbol{
  unichar firstChar = [symbol characterAtIndex:0];
  WRTokenType type = [[NSCharacterSet uppercaseLetterCharacterSet]
                      characterIsMember:firstChar] ? nonTerminal: terminal;
  return [self initWithType:type andSymbol:symbol];
}

+ (instancetype)tokenWithSymbol:(NSString *)symbol{
  return [[WRToken alloc]initWithSymbol:symbol];
}

- (BOOL)matchWith:(WRToken *)token{
  return [self.symbol isEqualToString:token.symbol];
}

@end
