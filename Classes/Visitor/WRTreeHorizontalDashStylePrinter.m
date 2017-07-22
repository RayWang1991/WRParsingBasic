/**
 * Copyright (c) 2017, Ray Wang
 * All rights reserved
 * Author: RayWang
 */

#import "WRTreeHorizontalDashStylePrinter.h"

@interface WRTreeHorizontalDashStylePrinter ()
@property (nonatomic, assign, readwrite) NSInteger level;
@property (nonatomic, strong, readwrite) NSMutableArray <NSNumber *> *hasSibling;
@property (nonatomic, strong, readwrite) NSMutableString *result;
@end

@implementation WRTreeHorizontalDashStylePrinter
- (instancetype)init {
  if (self = [super init]) {
    _result = [NSMutableString string];
    _hasSibling = [NSMutableArray arrayWithCapacity:64];
    _level = -1;
    [self setBOOLValue:NO
  forHasSiblingInIndex:0];
  }
  return self;
}

- (void)print {
  printf("%s", _result.UTF8String);
}

- (void)reset {
  [_result deleteCharactersInRange:NSMakeRange(0, _result.length)];
}

- (void)visit:(id<WRVisiteeProtocol>)visitee
 withChildren:(NSArray<id<WRVisiteeProtocol>> *)children {
  _level++;
  if (visitee == nil) {
    _level--;
    return;
  }
  // left most preorder
  // print node
  for (NSInteger i = 0; i <= _level; i++) {
    if (i == _level) {
      [_result appendFormat:@"%@\n",
                            visitee];
    } else if (i == _level - 1) {
      [_result appendFormat:@"%-8s",
                            @"+-------".UTF8String];
    } else if (_hasSibling[i].boolValue) {
      [_result appendFormat:@"%-8s",
                            @"|".UTF8String];
    } else {
      [_result appendFormat:@"%-8s",
                            @" ".UTF8String];
    }
  }

  if (children.count > 0) {
    NSInteger tempLevel = _level;
    NSInteger i = 0, last = children.count - 1;
    for (id<WRVisiteeProtocol> child in children) {
      [self setBOOLValue:(i < last)
    forHasSiblingInIndex:tempLevel];
      [child accept:self];
      i++;
    }
  }
  _level--;
}

#pragma mark -private helper

//#define setHasSibling(val, index) [self setBOOLValue:val forHasSiblingInIndex:index];

- (void)setBOOLValue:(BOOL)value
forHasSiblingInIndex:(NSUInteger)index {
  while (_hasSibling.count < index + 1) {
    [_hasSibling addObject:@(NO)];
  }
  _hasSibling[index] = @(value);
}

@end
