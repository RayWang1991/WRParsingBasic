/**
 * Copyright (c) 2017, Ray Wang
 * All rights reserved
 * Author: RayWang
 */

#import <Foundation/Foundation.h>
#import "WRToken.h"

//TODO simple scanner, complete later

@interface WRScanner : NSObject
@property(nonatomic, strong, readwrite)NSMutableArray <WRToken *>*tokens;
@property(nonatomic, strong, readwrite)NSMutableArray <NSError *>*errors;
@property(nonatomic, assign, readwrite)NSInteger index;
@property(nonatomic, strong, readwrite)NSString *inputStr;

- (void)reset;

- (WRToken *)nextToken;

@end
