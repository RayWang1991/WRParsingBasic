/**
 * Copyright (c) 2017, Ray Wang
 * All rights reserved
 * Author: RayWang
 */

#import <Foundation/Foundation.h>
#import "WRToken.h"

/**
 * This class represents an input termnal 
 */
@interface WRTerminal : WRToken

typedef struct {
  // start position
  NSInteger line;
  NSInteger column;
  NSInteger length;
} WRTerminalContentInfo;

@property (nonatomic, assign, readwrite) WRTerminalContentInfo contentInfo;
@property (nonatomic, assign, readwrite) NSInteger terminalType;
@property (nonatomic, strong, readwrite) NSString *value;

- (void)copyWithTerminal:(WRTerminal *)other;

@end
