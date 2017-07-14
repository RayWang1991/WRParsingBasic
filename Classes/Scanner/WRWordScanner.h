/**
 * Copyright (c) 2017, Ray Wang
 * All rights reserved
 * Author: RayWang
 */

#import "WRScanner.h"

@interface WRWordScanner : WRScanner

- (void)setNumOfEof:(NSInteger)num;

- (void)startScan;

- (void)scanToEnd;

- (WRTerminal *)nextToken;

- (void)reset;

- (void)test;
@end
