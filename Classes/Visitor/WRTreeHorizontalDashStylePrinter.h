/**
 * Copyright (c) 2017, Ray Wang
 * All rights reserved
 * Author: RayWang
 */

#import "WRTreeVisitor.h"

@interface WRTreeHorizontalDashStylePrinter : WRTreeVisitor

- (void)visit:(id<WRVisiteeProtocol>)visitee
 withChildren:(NSArray<id<WRVisiteeProtocol>> *)children;

- (void)print;

- (void)reset;
@end
