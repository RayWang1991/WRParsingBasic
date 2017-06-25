/**
 * Copyright (c) 2017, Ray Wang
 * All rights reserved
 * Author: RayWang
 */

#import "WRUtils.h"

@implementation WRUtils

@end

@interface WRPair ()

@property (nonatomic, strong, readwrite) id first;
@property (nonatomic, strong, readwrite) id second;
@property (nonatomic, strong, readwrite) NSString *str;

@end

@implementation WRPair
- (instancetype)initWith:(id)first
                     and:(id)second {
  if (self = [super init]) {
    _first = first;
    _second = second;
    _str = [NSString stringWithFormat:@"%@ %@",
                                      _first,
                                      _second];
  }
  return self;
}

+ (instancetype)pairWith:(id)first
                     and:(id)second {
  WRPair *pair = [[WRPair alloc] initWith:first
                                      and:second];
  return pair;
}

- (NSString *)description {
  return self.str.description;
}
@end

@implementation WRTreeNode

+ (instancetype)treeNodeWithContent:(NSString *)content {
  WRTreeNode *node = [[WRTreeNode alloc] init];
  node.contentStr = content;
  return node;
}

#define MAX_LEVEL 100
static NSInteger level = 0;
static int hasSibling[MAX_LEVEL];

+ (void)printTree:(WRTreeNode *)root {
  level = -1;
  hasSibling[0] = NO;
  [self printTreeHelper:root];
}

+ (void)printTreeHelper:(WRTreeNode *)root {
  level++;
  if (root == nil) {
    level--;
    return;
  }
  // left most preorder
  // print node
  for (NSInteger i = 0; i <= level; i++) {
    if (i == level){
      printf("%s\n",root.contentStr.UTF8String);
    } else if(i == level - 1){
      printf("%-8s","+-------");
    } else if(hasSibling[i]){
      printf("%-8s","|");
    } else{
      printf("%-8s"," ");
    }
  }

  if(root.children.count > 0){
    NSInteger tempLevel = level;
    NSInteger i = 0, last = root.children.count - 1;
    for(WRTreeNode *child in root.children){
      hasSibling[tempLevel] = i < last;
      [self printTreeHelper:child];
      i++;
    }
  }
  level--;
}

@end
