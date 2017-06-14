/**
 * Copyright (c) 2017, Ray Wang
 * All rights reserved
 * Author: RayWang
 */

#import <Foundation/Foundation.h>
#import "WRToken.h"

//TODO simple scanner, complete later

@interface WRScanner : NSObject
@property(nonatomic, strong, readwrite)NSString *inputStr;

- (void)reset;

- (WRToken *)nextToken;

// token array for the whole input
- (NSArray <WRToken *> *)tokenArray;

@end
