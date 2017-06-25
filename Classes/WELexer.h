/**
 * Copyright (c) 2017, Ray Wang
 * All rights reserved
 * Author: RayWang
 */

#import <Foundation/Foundation.h>
#import "WRScanner.h"

@interface WRLexer : WRScanner

@property(nonatomic, assign, readwrite) int currentLine;
@property(nonatomic, assign, readwrite) int currentColum;
@property(nonatomic, assign, readwrite) int tokenBegin; // private, temp record

- (void)startScan;

@end
