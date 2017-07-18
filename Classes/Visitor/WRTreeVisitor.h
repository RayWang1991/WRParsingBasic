/**
 * Copyright (c) 2017, Ray Wang
 * All rights reserved
 * Author: RayWang
 */

#import <Foundation/Foundation.h>
#import "WRVisitor.h"

@class WRTreeVisitor;

/**
 * abstract class for tree visitor
 */

@interface WRTreeVisitor : WRVisitor

- (void)visit:(id<WRVisiteeProtocol>)visitee;

- (void)visit:(id<WRVisiteeProtocol>)visitee
 withChildren:(NSArray<id<WRVisiteeProtocol>> *)children;

@end
