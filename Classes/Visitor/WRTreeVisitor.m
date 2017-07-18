/**
 * Copyright (c) 2017, Ray Wang
 * All rights reserved
 * Author: RayWang
 */

#import "WRTreeVisitor.h"

@implementation WRTreeVisitor

- (void)visit:(id<WRVisiteeProtocol>)visitee {
  // should be implemented by subclass
  [self visit:visitee
 withChildren:nil];
}

- (void)visit:(id<WRVisiteeProtocol>)visitee
 withChildren:(NSArray<id<WRVisiteeProtocol>> *)children {
  // should be implemented by subclass
}

@end
