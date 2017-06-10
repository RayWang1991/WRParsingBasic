/**
 * Copyright (c) 2017, Ray Wang
 * All rights reserved
 * Author: RayWang
 */

#import <Foundation/Foundation.h>
#import "WRToken.h"

@interface WRRule : NSObject

@property (nonatomic, strong, readwrite) NSString *ruleStr;
@property (nonatomic, strong, readwrite) WRToken *leftToken;
@property (nonatomic, strong, readwrite) NSArray <WRToken *> *rightTokens;

- (instancetype)initWithRuleStr:(NSString *)ruleStr;
+ (instancetype)ruleWithRuleStr:(NSString *)ruleStr;

@end
