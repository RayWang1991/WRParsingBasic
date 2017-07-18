/**
 * Copyright (c) 2017, Ray Wang
 * All rights reserved
 * Author: RayWang
 */

#import "WRSPPFNode.h"
@interface WRSPPFNode ()
@end

@implementation WRSPPFNode

- (instancetype)initWithContent:(id)content
                     leftExtent:(NSInteger)leftExtent
                 andRightExtent:(NSInteger)rightExtent {
  if (self = [super init]) {
    if ([content isKindOfClass:[NSString class]]) {
      _type = WRSPPFNodeTypeToken;
      _token = content;
    } else {
      _type = WRSPPFNodeTypeIntermediate;
      _item = content;
    }
    _leftExtent = leftExtent;
    _rightExtent = rightExtent;
  }
  return self;
}

+ (instancetype)SPPFNodeWithContent:(id)content
                         leftExtent:(NSInteger)leftExtent
                     andRightExtent:(NSInteger)rightExtent {
  return [[self alloc] initWithContent:content
                            leftExtent:leftExtent
                        andRightExtent:rightExtent];
}

- (BOOL)containsFamilly:(NSArray <WRSPPFNode *> *)familyArray {
  assert(familyArray.count > 0);
  for (NSArray *array in self.families) {
    // check whether the objs in array is the same as familyArray
    // array and family array can contain at most 2 objs
    if (familyArray.count == 1 && array.count == 1) {
      WRSPPFNode *familyNode = familyArray[0];
      WRSPPFNode *arrayNode = array[0];
      if ([familyNode.description isEqualToString:arrayNode.description]) {
        return YES;
      }
    } else if (familyArray.count == 2 && array.count == 2) {
      BOOL found = NO;
      WRSPPFNode *familyNode = familyArray[0];
      NSUInteger i = 0;
      for (; i < 2; i++) {
        WRSPPFNode *node = array[i];
        if ([node.description isEqualToString:familyNode.description]) {
          found = YES;
          break;
        }
      }
      if (!found) {
        return NO;
      } else {
        WRSPPFNode *node = array[1 - i];
        WRSPPFNode *familyNode = familyArray[1];
        return [node.description isEqualToString:familyNode.description];
      }
    }
  }
  return NO;
}

- (NSString *)nodeStr {
  if (nil == _nodeStr) {
    NSString *str = nil;
    if (self.type == WRSPPFNodeTypeToken) {
      str = self.token;
    } else {
      str = self.item.dotedRule;
    }
    _nodeStr = [NSString stringWithFormat:@"%@,%lu,%lu",
                                          str,
                                          _leftExtent,
                                          _rightExtent];
  }
  return _nodeStr;
}

- (NSString *)description {
  return self.nodeStr;
}

- (NSMutableArray <NSArray <WRSPPFNode *> *> *)families {
  if (nil == _families) {
    _families = [NSMutableArray array];
  }
  return _families;
}

- (void)accept:(WRVisitor *)visitor {
  assert(self.families.count <= 1);
  if ([visitor isKindOfClass:[WRTreeVisitor class]]) {
    WRTreeVisitor *treeVisitor = (WRTreeVisitor *) visitor;
    NSArray *children = self.families.count ? [self.families firstObject] : nil;
    [treeVisitor visit:self
          withChildren:children];
  } else {
    [visitor visit:self];
  }
}
@end
