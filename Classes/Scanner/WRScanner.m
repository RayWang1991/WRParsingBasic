/**
 * Copyright (c) 2017, Ray Wang
 * All rights reserved
 * Author: RayWang
 */

#import "WRScanner.h"

@interface WRScanner ()

@end

@implementation WRScanner
- (instancetype)initWithInputStr:(NSString *)inputStr {
  if (self = [super init]) {
    _inputStr = inputStr;
    _tokenIndex = 0;
  }
  return self;
}

- (void)startScan {
  [self resetTokenIndex];
}

- (void)resetTokenIndex {
  _tokenIndex = 0;
}

- (void)setInputStr:(NSString *)inputStr {
  _inputStr = inputStr;
  _tokenIndex = 0;
  [self.tokens removeAllObjects];
  [self.errors removeAllObjects];
}

- (WRTerminal *)nextToken {
  return [self nextTerminalWithIndex:_tokenIndex++];
}

- (void)scanToEnd {
  WRToken *token = nil;
  while (token = [self nextToken]) {
    [self.tokens addObject:token];
  }
}

#pragma mark - getter

- (NSMutableArray <WRTerminal *> *)tokens {
  if (nil == _tokens) {
    NSMutableArray *array = [NSMutableArray array];
    _tokens = array;
  }
  return _tokens;
}

- (NSMutableArray <NSError *> *)errors {
  if (nil == _errors) {
    NSMutableArray *array = [NSMutableArray array];
    _errors = array;
  }
  return _errors;
}

// private
- (WRTerminal *)nextTerminalWithIndex:(NSInteger)index {
  if (index >= self.inputStr.length) {
    return nil;
  } else {
    WRTerminal *token =
      [WRTerminal tokenWithSymbol:[self.inputStr substringWithRange:NSMakeRange(index, 1)]];
    return token;
  }
}

@end



