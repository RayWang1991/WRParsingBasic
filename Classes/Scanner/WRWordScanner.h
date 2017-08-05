/**
 * Copyright (c) 2017, Ray Wang
 * All rights reserved
 * Author: RayWang
 */

#import "WRScanner.h"
#import "WRLanguage.h"

@interface WRWordScanner : WRScanner
@property (nonatomic, strong, readwrite) WRLanguage *language; // use to label the terminal type

- (void)setNumOfEof:(NSInteger)num;

- (void)startScan;

- (void)scanToEnd;

- (WRTerminal *)nextToken;

- (WRTerminal *)tokenAtIndex:(NSInteger)index;

- (void)resetTokenIndex;

- (void)test;
@end
