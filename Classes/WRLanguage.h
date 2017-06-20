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
@property(nonatomic, strong, readwrite) NSSet <NSString *>*terminals;
@property(nonatomic, strong, readwrite) NSSet <NSString *>*nonterminals;
@property(nonatomic, strong, readwrite) NSDictionary <NSString *, NSArray <WRRule *>*>*grammars;

- (instancetype)initWithRuleStrings:(NSArray <NSString *>*)rules andStartSymbol:(NSString *)startSymbol;
/*
 * Basic CF Grammar
 */

+ (WRLanguage *)CFGrammar4_1;

//+ (WRLanguage *)CFGrammar6_6;  

+ (WRLanguage *)CFGrammar7_8; // left recursive

+ (WRLanguage *)CFGrammar7_17; // epsilon, left recursive

+ (WRLanguage *)CFGrammar7_19; // epsilon, left recursive, baddly

+ (WRLanguage *)CFGrammar_8_9; // epsilon

// Paper Elizabeth Scott SPPF-Style Parsing From Earley Recognisers

+ (WRLanguage *)CFGrammar_SPFER_2; // ambiguous

+ (WRLanguage *)CFGrammar_SPFER_3; // ambiguous

+ (WRLanguage *)CFGrammar_Add_Mult_1; // ambiguous, no priority for × and +

- (BOOL)isTokenNullable:(WRToken *)token;

- (NSSet <NSString *> *)firstSetForToken:(WRToken *)token;

@end
