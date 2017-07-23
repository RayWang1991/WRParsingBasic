/**
 * Copyright (c) 2017, Ray Wang
 * All rights reserved
 * Author: RayWang
 */

#import "WRItem.h"

@interface WRItem ()
@end

@implementation WRItem

- (instancetype)initWithRuleStr:(NSString *)ruleStr
                    dotPosition:(NSInteger)dotPosition
                 askingPosition:(NSInteger)askPosition {

  if (self = [super initWithRuleStr:ruleStr]) {
    _dotPos = dotPosition;
    _askPos = askPosition;
  }
  return self;
}

+ (instancetype)itemWithRuleStr:(NSString *)ruleStr
                    dotPosition:(NSInteger)dotPosition
                 askingPosition:(NSInteger)askPosition {
  WRItem *item = [[self alloc] initWithRuleStr:ruleStr
                                   dotPosition:dotPosition
                                askingPosition:askPosition];
  return item;
}

- (instancetype)initWithRule:(WRRule *)rule
                 dotPosition:(NSInteger)dotPosition
              askingPosition:(NSInteger)askPosition {
  if (self = [super initWithRule:rule]) {
    _dotPos = dotPosition;
    _askPos = askPosition;
    self.ruleIndex = rule.ruleIndex;
  }
  return self;
}

+ (instancetype)itemWithRule:(WRRule *)rule
                 dotPosition:(NSInteger)dotPosition
              askingPosition:(NSInteger)askPosition {
  return [[self alloc] initWithRule:rule
                        dotPosition:dotPosition
                     askingPosition:askPosition];
}

- (instancetype)initWithItem:(WRItem *)item
              askingPosition:(NSInteger)askPosition {
  if (self = [super initWithRule:item]) {
    _dotPos = item.dotPos;
    _askPos = askPosition;
    self.ruleIndex = item.ruleIndex;
  }
  return self;
}

+ (instancetype)itemWithItem:(WRItem *)item
              askingPosition:(NSInteger)askPosition {
  return [[self alloc] initWithItem:item
                     askingPosition:askPosition];
}

- (NSString *)description {
  return [NSString stringWithFormat:@"%@ @%ld",
                                    self.dotedRule,
                                    self.askPos];
}

- (NSString *)descriptionForReductions {
  if (self.reductionList.count == 0) {
    return nil;
  }
  NSMutableString *string = [NSMutableString string];
  for (WRPair *pair in self.reductionList) {
    [string appendFormat:@"%@; ",
                         pair];
  }
  [string appendString:@"\n"];
  return string;
}

- (NSString *)descriptionForPredecessors {
  if (self.predecessorList.count == 0) {
    return nil;
  }
  NSMutableString *string = [NSMutableString string];
  for (WRPair *pair in self.predecessorList) {
    [string appendFormat:@"%@; ",
                         pair];
  }
  [string appendString:@"\n"];
  return string;
}

- (NSUInteger)hash {
  return self.description.hash;
}

- (BOOL)isComplete {
  return self.rightTokens.count <= self.dotPos;
}

- (NSString *)nextAskingToken {
  if (self.isComplete) {
    return nil;
  } else {
    return self.rightTokens[_dotPos];
  }
}

- (NSString *)justCompletedToken {
  if (self.dotPos >= 1 && self.dotPos <= self.rightTokens.count) {
    return self.rightTokens[self.dotPos - 1];
  } else {
    return nil;
  }
}

- (NSString *)currentDotedRule {
  NSMutableString *mutStr = [NSMutableString stringWithString:self.leftToken];
  [mutStr appendString:@" ->"];

  NSInteger i = 0;
  for (NSString *token in self.rightTokens) {
    if (i == _dotPos) {
      [mutStr appendFormat:@" ·%@",
                           token];
    } else {
      [mutStr appendFormat:@" %@",
                           token];
    }
    i++;
  }

  if (self.rightTokens.count == _dotPos) {
    [mutStr appendString:@"·"];
  }
  return mutStr;
}

- (void)setDotPos:(NSInteger)dotPos {
  _dotPos = dotPos;
  _dotedRule = self.currentDotedRule;
}

- (NSString *)dotedRule {
  if (nil == _dotedRule) {
    _dotedRule = self.currentDotedRule;
  }
  return _dotedRule;
}

- (NSMutableDictionary <NSString *, WRPair *> *)predecessorList {
  if (nil == _predecessorList) {
    _predecessorList = [NSMutableDictionary dictionary];
  }
  return _predecessorList;
}

- (NSMutableDictionary <NSString *, WRPair *> *)reductionList {
  if (nil == _reductionList) {
    _reductionList = [NSMutableDictionary dictionary];
  }
  return _reductionList;
}
@end
