/**
 * Copyright (c) 2017, Ray Wang
 * All rights reserved
 * Author: RayWang
 */

#import "WRItemLA1.h"

@implementation WRItemLA1

- (NSString *)description {
  return [NSString stringWithFormat:@"%@, %@",
                                    self.dotedRule,
                                    self.lookAhead];
}
@end