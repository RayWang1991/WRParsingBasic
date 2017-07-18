/**
 * Copyright (c) 2017, Ray Wang
 * All rights reserved
 * Author: RayWang
 */

#import "WRTreeLispStylePrinter.h"

@interface WRTreeLispStylePrinter ()
@property (nonatomic, strong, readwrite) NSMutableString *result;
@end

@implementation WRTreeLispStylePrinter
- (instancetype)init {
  if (self = [super init]) {
    _result = [NSMutableString string];
  }
  return self;
}

- (void)print {
  printf("%s\n", self.result.UTF8String);
}

- (void)visit:(id<WRVisiteeProtocol>)visitee
 withChildren:(NSArray<id<WRVisiteeProtocol>> *)children {
  if (visitee == nil) {
    return;
  }
  if (children.count == 0) {
    [_result appendFormat:@" %@",
                          visitee.description];
  } else {
    // preorder
    [_result appendString:@" ("];
    [_result appendFormat:@"%@:",
                          visitee.description];
    for (id<WRVisiteeProtocol> child in children) {
      [child accept:self];
    }
    [_result appendString:@")"];
  }
}

@end
