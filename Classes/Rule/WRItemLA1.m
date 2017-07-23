/**
 * Copyright (c) 2017, Ray Wang
 * All rights reserved
 * Author: RayWang
 */

#import "WRItemLA1.h"

@implementation WRItemLA1

// override
- (instancetype)initWithRuleStr:(NSString *)ruleStr
                    dotPosition:(NSInteger)dotPosition
                 askingPosition:(NSInteger)askPosition{
  if(self = [super initWithRuleStr:ruleStr
                       dotPosition:dotPosition
                    askingPosition:askPosition]){
    _lookAhead = @"";
  }
  return self;
}

- (instancetype)initWithRule:(WRRule *)rule
                 dotPosition:(NSInteger)dotPosition
              askingPosition:(NSInteger)askPosition{
  if(self = [super initWithRule:rule
                    dotPosition:dotPosition
                 askingPosition:askPosition]){
    _lookAhead = @"";
  }
  return self;
}

- (instancetype)initWithItem:(WRItem *)item
              askingPosition:(NSInteger)position{
  if(self = [super initWithItem:item
                 askingPosition:position]){
    _lookAhead = @"";
  }
  return self;
}

- (NSString *)description {
  return [NSString stringWithFormat:@"%@, %@",
                                    self.dotedRule,
                                    self.lookAhead];
}
@end