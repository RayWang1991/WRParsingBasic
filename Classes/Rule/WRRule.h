/**
 * Copyright (c) 2017, Ray Wang
 * All rights reserved
 * Author: RayWang
 */

#import <Foundation/Foundation.h>
#import "NSString + WRToken.h"

@interface WRRule : NSObject <NSObject>

@property (nonatomic, assign, readwrite) NSInteger ruleIndex;
@property (nonatomic, strong, readonly) NSString *ruleStr;
@property (nonatomic, strong, readwrite) NSString *leftToken;
@property (nonatomic, strong, readwrite) NSArray <NSString *> *rightTokens;

- (instancetype)initWithRuleStr:(NSString *)ruleStr;
+ (instancetype)ruleWithRuleStr:(NSString *)ruleStr;
- (instancetype)initWithRule:(WRRule *)rule;
+ (instancetype)ruleWithRule:(WRRule *)rule;

// The "A -> a1 | b2" grammar is recommanded
+ (NSArray <WRRule *> *)rulesWithOrRuleStr:(NSString *)ruleStr;

- (NSString *)dotedRule; // override point
@end
