/**
 * Copyright (c) 2017, Ray Wang
 * All rights reserved
 * Author: RayWang
 */


#import "WRVisitor.h"


@implementation WRVisitor

- (void)visit:(id<WRVisiteeProtocol>)visitee{
  // should be implemented by subClass
}

@end
