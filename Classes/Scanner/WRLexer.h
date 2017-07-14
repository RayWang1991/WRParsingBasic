/**
 * Copyright (c) 2017, Ray Wang
 * All rights reserved
 * Author: RayWang
 */

#import "WRScanner.h"

extern NSString const* kWRLexerErrorDomain;

// a hand write lexer

@interface WRLexer : WRScanner
//TODO 1.modify the column, when meeting ' ', we should add column, too
//TODO 2.add next token and scan to end if needed

- (void)startScan;

- (void)test;
@end
