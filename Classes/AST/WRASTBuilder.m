/**
 * Copyright (c) 2017, Ray Wang
 * All rights reserved
 * Author: RayWang
 */

#import "WRASTBuilder.h"
#import "WRLanguage.h"

@implementation WRASTBuilder
- (instancetype)initWithStartToken:(WRToken *)startToken
                       andLanguage:(WRLanguage *)language{
  if( self = [super init]){
    _language = language;
    _startToken = startToken;
  }
  return self;
}

- (WRAST *)ast{
  return self.startToken.synAttr;
}
@end
