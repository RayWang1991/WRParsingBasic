/**
 * Copyright (c) 2017, Ray Wang
 * All rights reserved
 * Author: RayWang
 */

#import "WRToken.h"
#import "Foundation/Foundation.h"

@interface WRLanguage : NSObject
@property(nonatomic, strong, readwrite) WRToken *startToken;
@property(nonatomic, strong, readwrite) NSSet *symbols;
@property(nonatomic, strong, readwrite) NSDictionary *grammars;

/*
 * Basic CF Grammar
 */
+ (WRLanguage *)CFGrammar6_6;  

@end


