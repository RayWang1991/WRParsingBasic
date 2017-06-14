/**
 * Copyright (c) 2017, Ray Wang
 * All rights reserved
 * Author: RayWang
 */

#import "WRScanner.h"

@interface WRScanner ()
@property(nonatomic, strong, readwrite)NSArray <WRToken *>*tokenArray;
@property(nonatomic, assign, readwrite)NSInteger index;
@end

@implementation WRScanner
- (instancetype)initWithInputStr:(NSString *)inputStr{
  if(self = [super init]){
    _inputStr = inputStr;
    _index = 0;
    _tokenArray = nil;
  }
  return self;
}

- (void)reset{
  _index = 0;
}

- (void)setInputStr:(NSString *)inputStr{
  _inputStr = inputStr;
  _index = 0;
  _tokenArray = nil;
}

- (WRToken *)nextToken{
  return [self nextTokenWithIndex:_index++];
}

- (NSArray <WRToken *> *)tokenArray{
  if(nil == _tokenArray){
    NSMutableArray *array = [NSMutableArray array];
    for(NSUInteger i = 0 ; i <= self.inputStr.length; i++){
      [array addObject: [self nextTokenWithIndex:i]];
    }
    _tokenArray = array;
  }
  return _tokenArray;
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
