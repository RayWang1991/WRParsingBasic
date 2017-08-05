/**
 * Copyright (c) 2017, Ray Wang
 * All rights reserved
 * Author: RayWang
 */

#import <Foundation/Foundation.h>
#import "WRTerminal.h"

//really simple scanner, recognize each character as a token
//deprecated, use WRWordScanner instead

@interface WRScanner : NSObject
@property (nonatomic, strong, readwrite) NSMutableArray <WRTerminal *> *tokens;
@property (nonatomic, strong, readwrite) NSMutableArray <NSError *> *errors;
@property (nonatomic, assign, readwrite) NSInteger tokenIndex;
@property (nonatomic, strong, readwrite) NSString *inputStr;

- (void)startScan;

- (void)resetTokenIndex;

- (WRTerminal *)nextToken;

- (void)scanToEnd;

@end
