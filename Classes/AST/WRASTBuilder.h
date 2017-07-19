/**
 * Copyright (c) 2017, Ray Wang
 * All rights reserved
 * Author: RayWang
 */

#import <Foundation/Foundation.h>
#import "WRTreeVisitor.h"
#import "WRAST.h"
@class WRToken;
@class WRLanguage;

@interface WRASTBuilder : WRTreeVisitor
@property (nonatomic, strong, readwrite) WRToken *startToken;
@property (nonatomic, strong, readwrite) WRLanguage *language;

- (instancetype)initWithStartToken:(WRToken *)startToken
                       andLanguage:(WRLanguage *)language;

- (WRAST *)ast;

@end
