/**
 * Copyright (c) 2017, Ray Wang
 * All rights reserved
 * Author: RayWang
 */

#import <Foundation/Foundation.h>
#import "WRTerminal.h"
#import "WRVisitor.h"
#import "WRTreeVisitor.h"

/**
 * base class for AST node (can also be used as Isomorphic AST node)
 */
@interface WRAST : NSObject <WRVisiteeProtocol>

@property(nonatomic, strong, readwrite) WRTerminal *terminal;
@property(nonatomic, strong, readwrite) NSMutableArray<WRAST *> *children;

- (instancetype)initWithWRTerminal:(WRTerminal *)terminal;

- (NSInteger)type;

- (void)accept:(WRVisitor *)visitor;

@end
