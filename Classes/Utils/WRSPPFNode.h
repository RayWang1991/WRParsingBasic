/**
 * Copyright (c) 2017, Ray Wang
 * All rights reserved
 * Author: RayWang
 */

#import <Foundation/Foundation.h>
#import "WRToken.h"
#import "WRRule.h"
#import "WRTreeVisitor.h"

typedef NS_ENUM(NSInteger, WRSPPFNodeType){
  WRSPPFNodeTypeToken,
  WRSPPFNodeTypeIntermediate //items
};

@interface WRSPPFNode : NSObject <WRVisiteeProtocol>

@property (nonatomic, assign, readwrite) WRSPPFNodeType type;
@property (nonatomic, strong, readwrite) WRRule *item;
@property (nonatomic, strong, readwrite) NSString *token;
@property (nonatomic, assign, readwrite) NSInteger leftExtent;
@property (nonatomic, assign, readwrite) NSInteger rightExtent;
@property (nonatomic, strong, readwrite) NSString *nodeStr;
@property (nonatomic, strong, readwrite) NSMutableArray <NSArray <WRSPPFNode *> *> *families;

- (instancetype) initWithContent:(id)content
                      leftExtent:(NSInteger)leftExtent
                  andRightExtent:(NSInteger)rightExtent;

+ (instancetype) SPPFNodeWithContent:(id)content
                          leftExtent:(NSInteger)leftExtent
                      andRightExtent:(NSInteger)rightExtent;

// the parameter familyArray's count should > 0
- (BOOL)containsFamilly:(NSArray <WRSPPFNode *>*)familyArray;

- (void)accept:(WRVisitor *)visitor;
@end
