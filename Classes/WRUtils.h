/**
 * Copyright (c) 2017, Ray Wang
 * All rights reserved
 * Author: RayWang
 */

#import <Foundation/Foundation.h>

@interface WRUtils : NSObject

@end



@interface WRPair : NSObject

+ (instancetype)pairWith:(id)first and:(id)second;
- (id)first;
- (id)second;

@end
