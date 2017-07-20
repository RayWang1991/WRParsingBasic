/**
 * Copyright (c) 2017, Ray Wang
 * All rights reserved
 * Author: RayWang
 */


#import "WRRule.h"
@class WRPair;

// Earley Item (LR0 Item)
@interface WRItem : WRRule

@property (nonatomic, assign, readwrite) NSInteger dotPos;   // position of dot
@property (nonatomic, assign, readwrite) NSInteger askPos; // asking position in item set
@property (nonatomic, assign, readwrite) NSInteger fromIndex; // index of item set

@property (nonatomic, strong, readwrite) NSString *dotedRule;
@property (nonatomic, strong, readwrite) NSMutableDictionary <NSString *, WRPair *> *reductionList;
@property (nonatomic, strong, readwrite) NSMutableDictionary <NSString *, WRPair *> *predecessorList;

/**
 * initialize Methods
 */

// basic init methods
- (instancetype)initWithRuleStr:(NSString *)ruleStr
                    dotPosition:(NSInteger)dotPosition
                 askingPosition:(NSInteger)askPosition;

+ (instancetype)itemWithRuleStr:(NSString *)ruleStr
                    dotPosition:(NSInteger)dotPosition
                 askingPosition:(NSInteger)askPosition;

// copy rule and set dot||item position
- (instancetype)initWithRule:(WRRule *)rule
                 dotPosition:(NSInteger)dotPosition
              askingPosition:(NSInteger)askPosition;

+ (instancetype)itemWithRule:(WRRule *)rule
                 dotPosition:(NSInteger)dotPosition
              askingPosition:(NSInteger)askPosition;

// copy item and set the position of item set
- (instancetype)initWithItem:(WRItem *)item
              askingPosition:(NSInteger)position;

+ (instancetype)itemWithItem:(WRItem *)item
              askingPosition:(NSInteger)askPosition;

- (NSString *)descriptionForReductions;

- (NSString *)descriptionForPredecessors;

/**
 * Functional Methods
 */

- (BOOL)isComplete;

/* Right Hand Methods*/

// The token right after the dot;
- (NSString *)nextAskingToken;

// The token right before the dot;
- (NSString *)justCompletedToken;

// override methods
- (NSString *)dotedRule;

@end
