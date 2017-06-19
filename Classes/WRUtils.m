/**
 * Copyright (c) 2017, Ray Wang
 * All rights reserved
 * Author: RayWang
 */

#import "WRUtils.h"

@implementation WRUtils

@end

@interface WRPair ()

@property(nonatomic, strong, readwrite)id first;
@property(nonatomic, strong, readwrite)id second;
@property(nonatomic, strong, readwrite)NSString *str;

@end

@implementation WRPair
- (instancetype)initWith:(id)first and:(id)second{
  if(self = [super init]){
    _first = first;
    _second = second;
    _str = [NSString stringWithFormat:@"%@ %@",_first, _second];
  }
  return self;
}
+ (instancetype)pairWith:(id)first and:(id)second{
  WRPair *pair = [[WRPair alloc]initWith:first
                                     and:second];
  return pair;
}

- (NSString *)description{
  return self.str.description;
}
@end
