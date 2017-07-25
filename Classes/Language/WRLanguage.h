/**
 * Copyright (c) 2017, Ray Wang
 * All rights reserved
 * Author: RayWang
 */

#import "Foundation/Foundation.h"
#import "WRTerminal.h"
#import "WRNonterminal.h"
#import "WRRule.h"
#import "WRAST.h"

// TODO
// 为了方便构造AST，建议所有language都从父类继承，并重写ASTForToken方法

@interface WRLanguage : NSObject
@property (nonatomic, strong, readwrite) NSString *startSymbol;
@property (nonatomic, strong, readwrite) NSMutableSet <NSString *> *terminals;
@property (nonatomic, strong, readwrite) NSMutableSet <NSString *> *nonterminals;

@property (nonatomic, strong, readwrite) NSMutableDictionary <NSString *, NSNumber *> *token2IdMapper;
@property (nonatomic, strong, readwrite) NSMutableArray <NSString *> *nonterminalList;
@property (nonatomic, strong, readwrite) NSMutableArray <NSString *> *terminalList;

@property (nonatomic, strong, readwrite) NSDictionary <NSString *, NSArray <WRRule *> *> *grammars;
@property (nonatomic, strong, readwrite) NSMutableArray <WRRule *> *grammarsInARow;
@property (nonatomic, strong, readwrite) NSMutableDictionary <NSString *, NSNumber *> *rule2IdMapper;

// used by subclass
- (instancetype)initWithRuleStrings:(NSArray <NSString *> *)rules
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

// call when the parse tree is constructed to build AST tree
// should be implemented by subclass
- (WRAST *)astNodeForToken:(WRToken *)token;

// to add virtual node
- (void)addVirtualTerminal:(NSString *)virtualTerminal;

/*
 *  CF Grammar Factory methods
 */

+ (WRLanguage *)CFGrammar4_1;

//+ (WRLanguage *)CFGrammar6_6;  

+ (WRLanguage *)CFGrammar7_8; // left recursive

+ (WRLanguage *)CFGrammar7_17; // epsilon, left recursive

+ (WRLanguage *)CFGrammar7_19; // epsilon, left recursive, baddly

+ (WRLanguage *)CFGrammar_8_9; // epsilon

+ (WRLanguage *)CFGrammar_9_14; // LR0

+ (WRLanguage *)CFGrammar_9_23; // LR1

// Paper Elizabeth Scott SPPF-Style Parsing From Earley Recognisers

+ (WRLanguage *)CFGrammar_SPFER_2; // ambiguous

+ (WRLanguage *)CFGrammar_SPFER_3; // ambiguous

+ (WRLanguage *)CFGrammar_Add_Mult_1; // ambiguous, no priority for × and +

+ (WRLanguage *)CFGrammar_Test_First_1;

+ (WRLanguage *)CFGrammar_EAC_3_4_RR; // right recursive variant of the classic expression grammar, LL1




@end
