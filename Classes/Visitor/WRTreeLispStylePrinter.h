/**
 * Copyright (c) 2017, Ray Wang
 * All rights reserved
 * Author: RayWang
 */

#import <Foundation/Foundation.h>
#import "WRTreeVisitor.h"

/**
 * print tree nodes in lisp-like style
 */

@interface WRTreeLispStylePrinter : WRTreeVisitor

- (void)visit:(id<WRVisiteeProtocol>)visitee
 withChildren:(NSArray<id<WRVisiteeProtocol>> *)children;

- (void)print;

@end
