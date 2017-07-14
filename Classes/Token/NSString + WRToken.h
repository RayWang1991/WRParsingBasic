/**
 * Copyright (c) 2017, Ray Wang
 * All rights reserved
 * Author: RayWang
 */

#import <Foundation/Foundation.h>

extern NSString *const WREndOfFileTokenSymbol;
extern NSString *const WREpsilonTokenSymbol;

typedef NS_ENUM(NSInteger, WRTokenType){
  terminal,
  nonTerminal
};

@interface NSString (WRToken)

- (WRTokenType)tokenTypeForString;

@end
