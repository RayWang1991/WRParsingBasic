/**
 * Copyright (c) 2017, Ray Wang
 * All rights reserved
 * Author: RayWang
 */

#import <Foundation/Foundation.h>

@interface WRUtils : NSObject

+ (NSString *)debugStrWithTabs:(NSUInteger)tabNumber
                     forString:(NSString *)str;

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

