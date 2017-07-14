/**
 * Copyright (c) 2017, Ray Wang
 * All rights reserved
 * Author: RayWang
 */

#import "WRNonterminal.h"

@implementation WRNonterminal

//override
- (instancetype)initWithSymbol:(NSString *)symbol{
  if(self = [super initWithSymbol:symbol]){
    self.type = nonTerminal;
  }
  return self;
}

@end
