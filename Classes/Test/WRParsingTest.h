/**
 * Copyright (c) 2017, Ray Wang
 * All rights reserved
 * Author: RayWang
 */

#import <Foundation/Foundation.h>

@interface WRParsingTest : NSObject
+ (void)test;
+ (void)testLanguage;
+ (void)testRule;
+ (void)testEarleyParser;
+ (void)testLR0Parser;
+ (void)testLR1Parser;
+ (void)testLL1Parser;
+ (void)testWordScanner;
+ (void)testLexer;
+ (void)testString;
+ (void)testTreePattern;
@end