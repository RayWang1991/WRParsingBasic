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
}

- (WRToken *)nextToken{
  return [self nextTokenWithIndex:_index++];
}

- (NSMutableArray <WRToken *> *)tokenArray{
  if(nil == _tokenArray){
    NSMutableArray *array = [NSMutableArray array];
    _tokenArray = array;
  }
  return _tokenArray;
}

- (NSMutableArray <NSError *> *)errorArray{
  if(nil == _errorArray){
    NSMutableArray *array = [NSMutableArray array];
    _errorArray = array;
  }
  return _errorArray;
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



