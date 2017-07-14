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
@property(nonatomic, strong, readwrite) NSMutableSet <NSString *>*terminals;
@property(nonatomic, strong, readwrite) NSMutableSet <NSString *>*nonterminals;

@property (nonatomic, strong, readwrite) NSMutableDictionary <NSString *, NSNumber *> *token2IdMapper;
@property (nonatomic, strong, readwrite) NSMutableArray <NSString *> *nonterminalList;
@property (nonatomic, strong, readwrite) NSMutableArray <NSString *> *terminalList; 

@property(nonatomic, strong, readwrite) NSDictionary <NSString *, NSArray <WRRule *>*>*grammars;

- (instancetype)initWithRuleStrings:(NSArray <NSString *>*)rules
                     andStartSymbol:(NSString *)startSymbol;

// call when needed, constuct LL(1) parser
- (void)addEofToTerminals;

- (void)computeFirstSets;

- (void)computeFollowSets;

- (void)computeFirstPlusSets;

// wrappers
- (BOOL)isTokenNullable:(NSString *)token;

- (NSSet <NSString *> *)firstSetForToken:(NSString *)tokenSymbol;

- (NSSet <NSString *> *)followSetForToken:(NSString *)tokenSymbol;

- (NSSet <NSString *> *)firstPlusSetForRule:(WRRule *)rule;

- (NSSet <NSString *> *)firstPlusSetForToken:(NSString *)tokenSymbol
                                andRuleIndex:(NSInteger)index;

/*
 * Basic CF Grammar
 */

+ (WRLanguage *)CFGrammar4_1;

//+ (WRLanguage *)CFGrammar6_6;  

+ (WRLanguage *)CFGrammar7_8; // left recursive

+ (WRLanguage *)CFGrammar7_17; // epsilon, left recursive

+ (WRLanguage *)CFGrammar7_19; // epsilon, left recursive, baddly

+ (WRLanguage *)CFGrammar_8_9; // epsilon

+ (WRLanguage *)CFGrammar_9_14; // LR0

// Paper Elizabeth Scott SPPF-Style Parsing From Earley Recognisers

+ (WRLanguage *)CFGrammar_SPFER_2; // ambiguous

+ (WRLanguage *)CFGrammar_SPFER_3; // ambiguous

+ (WRLanguage *)CFGrammar_Add_Mult_1; // ambiguous, no priority for × and +

+ (WRLanguage *)CFGrammar_Test_First_1;

+ (WRLanguage *)CFGrammar_EAC_3_4_RR; // right recursive variant of the classic expression grammar, LL1


@end
