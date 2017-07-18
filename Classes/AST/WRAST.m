/**
 * Copyright (c) 2017, Ray Wang
 * All rights reserved
 * Author: RayWang
 */

#import "WRAST.h"
@interface WRAST ()
@end

@implementation WRAST

- (instancetype)initWithWRTerminal:(WRTerminal *)terminal {
  if (self = [super init]) {
    _terminal = terminal;
    _children = [NSMutableArray array];
  }
  return self;
}

- (NSInteger)type {
  return _terminal ? _terminal.terminalType : -1;
}

- (NSString *)description {
  return self.terminal.description;
}

- (void)accept:(WRVisitor *)visitor {
  if ([visitor isKindOfClass:[WRTreeVisitor class]]) {
    WRTreeVisitor *treeVisitor = (WRTreeVisitor *) visitor;
    [treeVisitor visit:self
          withChildren:self.children];
  } else {
    [visitor visit:self];
  }
}
@end
