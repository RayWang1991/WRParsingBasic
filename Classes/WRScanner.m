/**
 * Copyright (c) 2017, Ray Wang
 * All rights reserved
 * Author: RayWang
 */

#import "WRScanner.h"

@interface WRScanner ()

@end

@implementation WRScanner
- (instancetype)initWithInputStr:(NSString *)inputStr{
  if(self = [super init]){
    _inputStr = inputStr;
    _index = 0;
  }
  return self;
}

- (void)reset{
  _index = 0;
}

- (void)setInputStr:(NSString *)inputStr{
  _inputStr = inputStr;
  _index = 0;
  [self.tokens removeAllObjects];
  [self.errors removeAllObjects];
}

- (WRToken *)nextToken{
  return [self nextTokenWithIndex:_index++];
}

- (NSMutableArray <WRToken *> *)tokens{
  if(nil == _tokens){
    NSMutableArray *array = [NSMutableArray array];
    _tokens = array;
  }
  return _tokens;
}

- (NSMutableArray <NSError *> *)errors{
  if(nil == _errors){
    NSMutableArray *array = [NSMutableArray array];
    _errors = array;
  }
  return _errors;
}

// private
- (WRToken *)nextTokenWithIndex:(NSInteger)index{
  if(index >= self.inputStr.length) {
    return nil;
  } else{
    WRToken *token =
    [WRToken tokenWithSymbol:[self.inputStr substringWithRange:NSMakeRange(index, 1)]];
    return token;
  }
}

@end



