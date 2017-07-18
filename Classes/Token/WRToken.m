#import "WRToken.h"

@implementation WRToken

- (instancetype)initWithSymbol:(NSString *)symbol {
  if (self = [super init]) {
    _symbol = symbol;
  }
  return self;
}

+ (instancetype)tokenWithSymbol:(NSString *)symbol {
  return [[self alloc] initWithSymbol:symbol];
}

- (BOOL)matchWithToken:(WRToken *)token {
  return [self.symbol isEqualToString:token.symbol];
}

- (BOOL)matchWithStr:(NSString *)string {
  return [self.symbol isEqualToString:string];
}

- (NSString *)description {
  return self.symbol;
}


#pragma visitor protocol
- (void)accept:(WRVisitor *)visitor{
  [visitor visit:self];
}

@end
