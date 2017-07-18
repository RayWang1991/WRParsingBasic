/**
 * Copyright (c) 2017, Ray Wang
 * All rights reserved
 * Author: RayWang
 */

#import <Foundation/Foundation.h>
#import "NSString + WRToken.h"
#import "WRVisitor.h"

/** 
 * base class for WRTerminal an WRNonterminal
 */

@interface WRToken : NSObject<WRVisiteeProtocol>

// although we can derrive the type from the class, we can speed it up by using the type field
@property (nonatomic, assign, readwrite) WRTokenType type;
@property (nonatomic, strong, readwrite) NSString *symbol;
@property (nonatomic, strong, readwrite) id synAttr; // synthesized attribute
@property (nonatomic, strong, readwrite) id inhAttr; // inherited attribute

- (BOOL)matchWithToken:(WRToken *)token;
- (BOOL)matchWithStr:(NSString *)string;
+ (instancetype)tokenWithSymbol:(NSString *)symbol;
- (instancetype)initWithSymbol:(NSString *)symbol;

- (void)accept:(WRVisitor *)visitor;

@end
