/**
 * Copyright (c) 2017, Ray Wang
 * All rights reserved
 * Author: RayWang
 */

#import "WRASTBuilder.h"
#import "WRLanguage.h"

@interface WRASTBuilder()
@property(nonatomic, strong, readwrite)WRAST *ast;
@property(nonatomic, strong, readwrite)WRLanguage *language;
@end

@implementation WRASTBuilder
- (instancetype)initWithLanguage:(WRLanguage *)language{
  if(self = [super init]){
    _language = language;
  }
  return self;
}

- (WRAST *)astNodeForToken:(WRToken<WRVisiteeProtocol> *)token
              withChildren:(NSArray<WRToken<WRVisiteeProtocol> *> *)children{
  if(!token){
    return nil;
  }
  if(token.type == terminal){
    WRAST *ast = [[WRAST alloc]initWithWRTerminal:(WRTerminal *)token];
    return ast;
  }
  
}
@end
