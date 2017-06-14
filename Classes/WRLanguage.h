/**
 * Copyright (c) 2017, Ray Wang
 * All rights reserved
 * Author: RayWang
 */

#import "Foundation/Foundation.h"
#import "WRToken.h"
#import "WRRule.h"

@interface WRLanguage : NSObject
@property(nonatomic, strong, readwrite) NSString *startSymbol;
@property(nonatomic, strong, readwrite) NSSet <NSString *>*symbols;
@property(nonatomic, strong, readwrite) NSDictionary <NSString *, NSArray <WRRule *>*>*grammars;

- (instancetype)initWithRuleStrings:(NSArray <NSString *>*)rules andStartSymbol:(NSString *)startSymbol;
/*
 * Basic CF Grammar
 */

+ (WRLanguage *)CFGrammar4_1;

//+ (WRLanguage *)CFGrammar6_6;  

+ (WRLanguage *)CFGrammar7_8; // left recursive

+ (WRLanguage *)CFGrammar7_17; // eplisom, left recursive

+ (WRLanguage *)CFGrammar7_19; // eplisom, left recursive, baddly

- (BOOL)isTokenNullable:(WRToken *)token;

@end
