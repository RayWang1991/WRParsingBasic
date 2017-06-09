/**
 * Copyright (c) 2017, Ray Wang
 * All rights reserved
 * Author: RayWang
 */

#import <Foundation/Foundation.h>
#import "WRToken.h"

@interface WRRule : NSObject

@property (nonatomic, strong, readwrite) NSString *rule;
@property (nonatomic, strong, readwrite) WRToken *leftToken;
@property (nonatomic, strong, readwrite) NSArray <WRToken *> *rightTokens;

- (instancetype)initWithRule:(NSString *)rule;
+ (instancetype)ruleWithRule:(NSString *)rule;

@end
