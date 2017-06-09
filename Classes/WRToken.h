/**
 * Copyright (c) 2017, Ray Wang
 * All rights reserved
 * Author: RayWang
 */

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, WRTokenType){
  terminal,
  nonTerminal
};

@interface WRToken : NSObject
@property(nonatomic, assign, readwrite) WRTokenType type;
@property(nonatomic, strong, readwrite) NSString *symbol;

- (BOOL)isMatchWith:(WRToken *)token;

+ (instancetype)tokenWithType:(WRTokenType)type andSymbol:(NSString *)symbol;
- (instancetype)initWithType:(WRTokenType)type andSymbol:(NSString *)symbol;
  
// The following methods use symbol start with a lower char as a terminal token

+ (instancetype)tokenWithSymbol:(NSString *)symbol;
- (instancetype)initWithSymbol:(NSString *)symbol;

@end
