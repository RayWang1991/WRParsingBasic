#import "WRTokoen.h"

@implementation WRToken

+ (WRToken *)tokenWithType:(WRTokenType)type andSymbol:(NSString *)symbol{
  WRToken *token = [[WRToken alloc]init];
  token.type = type;
  token.symbol = symbol;
  return token;
}

- (BOOL)isMatchWith:(WRToken *)token{
  return [self.symbol isEqualToString:token.symbol];
}

@end
