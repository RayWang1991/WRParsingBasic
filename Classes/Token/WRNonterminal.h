/**
 * Copyright (c) 2017, Ray Wang
 * All rights reserved
 * Author: RayWang
 */

#import "WRToken.h"

/**
 * This class represents a nonterminal node in parse tree
 */

@interface WRNonterminal : WRToken

@property(nonatomic, strong, readwrite) NSString *symbol;
@property(nonatomic, readwrite, readwrite) NSInteger ruleIndex;
@property(nonatomic, strong, readwrite) NSArray <WRToken *>*children;

@end
