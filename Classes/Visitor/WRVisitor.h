/**
 * Copyright (c) 2017, Ray Wang
 * All rights reserved
 * Author: RayWang
 */


#import <Foundation/Foundation.h>

@class WRVisitor;
@protocol WRVisiteeProtocol<NSObject>
 @required
- (void)accept:(WRVisitor *)visitor;
- (NSString *)description;
@end

/**
 * base class for visitor
 */
@interface WRVisitor : NSObject

- (void)visit:(id<WRVisiteeProtocol>)visitee;

@end
