/**
 * Copyright (c) 2017, Ray Wang
 * All rights reserved
 * Author: RayWang
 */

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, WRTreePatternMatchActionType){
  WRTreePatternMatchActionMatch,
  WRTreePatternMatchActionGoDown,
  WRTreePatternMatchActionGoUp,
};

@interface WRTreePatternAction : NSObject
@property(nonatomic, assign, readwrite)WRTreePatternMatchActionType type;
@end

@interface WRTreePatternMatchAction : WRTreePatternAction
@property(nonatomic, strong, readwrite)NSString *symbol;
@property(nonatomic, assign, readwrite)NSInteger nodeId;
@end

@interface WRTreePattern : NSObject

// use '(' to present go down after a token, ')' to present go up.
// use '\(' to present real '(', '\)' is the same
// e.g. "( root child0 child1 )" means match root, then go down, then match child0, then match child 1, then go up.

- (NSArray <WRTreePatternAction *> *)actions;

- (instancetype)initWithString:(NSString *)string;

+ (instancetype)treePatternWithString:(NSString *)string;

@end
