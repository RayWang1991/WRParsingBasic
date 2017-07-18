/**
 * Copyright (c) 2017, Ray Wang
 * All rights reserved
 * Author: RayWang
 */

#import "WRNonterminal.h"
#import "WRTreeVisitor.h"

@implementation WRNonterminal

//override
- (instancetype)initWithSymbol:(NSString *)symbol {
  if (self = [super initWithSymbol:symbol]) {
    self.type = nonTerminal;
  }
  return self;
}

- (void)accept:(WRVisitor *)visitor {
  if ([visitor isKindOfClass:[WRTreeVisitor class]]) {
    WRTreeVisitor *treeVisitor = (WRTreeVisitor *) visitor;
    [treeVisitor visit:self
          withChildren:self.children];
  } else {
    [super accept:visitor];
  }
}

@end
