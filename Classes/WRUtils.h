/**
 * Copyright (c) 2017, Ray Wang
 * All rights reserved
 * Author: RayWang
 */

#import <Foundation/Foundation.h>
@class WRTerminal;

@interface WRUtils : NSObject

+ (NSString *)debugStrWithTabs:(NSUInteger)tabNumber
                     forString:(NSString *)str;
@end

@interface WRTest : NSObject
extern BOOL (^wrCheckTerminal)(WRTerminal *, NSString *, NSInteger, NSInteger, NSInteger);
@end

@interface WRPair : NSObject

+ (instancetype)pairWith:(id)first and:(id)second;
- (id)first;
- (id)second;

@end

@interface WRTreeNode : NSObject
@property(nonatomic, strong, readwrite)NSString *contentStr;
// Children
@property(nonatomic, strong, readwrite) NSArray <WRTreeNode *> *children;

+ (instancetype)treeNodeWithContent:(NSString *)content;

+ (void)printTree:(WRTreeNode *)node;
@end

