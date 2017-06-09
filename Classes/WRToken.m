/**
 * Copyright (c) 2017, Ray Wang
 * All rights reserved
 * Author: RayWang
 */

#import "WRToken.h"

@implementation WRToken

- (instancetype)initWithType:(WRTokenType)type andSymbol:(NSString *)symbol{
  if(self = [super init]){
    _type = type;
    _symbol = symbol;
  }
  return self;
}

+ (instancetype)tokenWithType:(WRTokenType)type andSymbol:(NSString *)symbol{
  WRToken *token = [[WRToken alloc]init];
  token.type = type;
  token.symbol = symbol;
  return token;
}

- (instancetype)initWithSymbol:(NSString *)symbol{
  WRTokenType type = [WRToken tokenTypeWithSymbol:symbol];
  return [self initWithType:type andSymbol:symbol];
}

+ (instancetype)tokenWithSymbol:(NSString *)symbol{
  WRTokenType type = [WRToken tokenTypeWithSymbol:symbol];
  return [self tokenWithType:type andSymbol:symbol];
}

+ (WRTokenType)tokenTypeWithSymbol:(NSString *)symbol{
  assert(symbol.length > 0);
  NSCharacterSet *lowercaseLetterCharacterSet = [NSCharacterSet lowercaseLetterCharacterSet];
  unichar fisrtChar = [symbol characterAtIndex:0];
  WRTokenType type = [lowercaseLetterCharacterSet characterIsMember:fisrtChar] ? terminal : nonTerminal;
  return type;
}

- (BOOL)isMatchWith:(WRToken *)token{
  return [self.symbol isEqualToString:token.symbol];
}


@end
