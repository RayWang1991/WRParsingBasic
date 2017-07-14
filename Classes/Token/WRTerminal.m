/**
 * Copyright (c) 2017, Ray Wang
 * All rights reserved
 * Author: RayWang
 */

#import "WRTerminal.h"

@implementation WRTerminal

//override
- (instancetype)initWithSymbol:(NSString *)symbol{
  if(self = [super initWithSymbol:symbol]){
    self.type = terminal;
  }
  return self;
}

@end
