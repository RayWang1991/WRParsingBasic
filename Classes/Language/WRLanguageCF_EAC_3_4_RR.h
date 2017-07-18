/**
 * Copyright (c) 2017, Ray Wang
 * All rights reserved
 * Author: RayWang
 */

#import "WRLanguage.h"
#import "WRTreeVisitor.h"

@interface WRLanguageCF_EAC_3_4_RR : WRLanguage

@end

@interface WRLanguageCF_EAC_3_4_RR_ASTBuilder : WRTreeVisitor

- (instancetype)initWithStartToken:(WRToken *)startToken
                       andLanguage:(WRLanguage *)language;

- (WRAST *)ast;

@end
