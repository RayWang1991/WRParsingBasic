/**
 * Copyright (c) 2017, Ray Wang
 * All rights reserved
 * Author: RayWang
 */

#import "WRTerminal.h"

@implementation WRTerminal

//override
- (instancetype)initWithSymbol:(NSString *)symbol {
  if (self = [super initWithSymbol:symbol]) {
    self.type = WRTokenTypeTerminal;
  }
  return self;
}

- (NSString *)description {
  return _value ? _value : [super description];
}
//copy properties
- (void)copyWithTerminal:(WRTerminal *)other {
  _contentInfo = other.contentInfo;
  _value = other.value;
}


@end
