/**
 * Copyright (c) 2017, Ray Wang
 * All rights reserved
 * Author: RayWang
 */

#import "WRUtils.h"
#import "WRToken.h"
#import "WRTerminal.h"

@implementation WRUtils

+ (NSString *)debugStrWithTabs:(NSUInteger)tabNumber
                     forString:(NSString *)str {
  if(str.length == 0){
    return @"";
  }
  NSString *appendFormat = [NSString stringWithFormat:@"%%+%ds",
                                                      tabNumber];
  // "%+ns" format
  char *tap = " ";
  NSString *appendString = [NSString stringWithFormat:appendFormat,
                                                      tap];
  NSMutableString *string = [NSMutableString stringWithString:str];
  NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@"\n\r"];
  // first sweep, find or new line chars
  NSMutableArray <NSNumber *> * indexArray = [NSMutableArray arrayWithObject:@"0"];
  NSUInteger num = 2;
  for(NSUInteger i = 0; i< string.length; i++){
    unichar c = [string characterAtIndex:i];
    if([charSet characterIsMember:c]){
      [indexArray addObject:@(i + 1 + num)];
      num += 2;
    }
  }
  if([charSet characterIsMember: [string characterAtIndex:string.length - 1]]){
    [indexArray removeLastObject];
  }
  for(NSNumber *index in indexArray){
    [string insertString:appendString
                 atIndex:index.integerValue];
  }
  return [NSString stringWithString:string];
}

@end

@implementation WRTestUtils
BOOL (^wrCheckTerminal)(WRTerminal *, NSString *, NSInteger, NSInteger, NSInteger) =
^(WRTerminal *token, NSString *symbol, NSInteger length, NSInteger line, NSInteger column) {
  return (BOOL)(([token.symbol isEqualToString:symbol]) &&
    (token.contentInfo.length == length) &&
    (token.contentInfo.line == line) &&
    (token.contentInfo.column == column));
};
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
    if (i == level) {
      printf("%s\n", root.contentStr.UTF8String);
    } else if (i == level - 1) {
      printf("%-8s", "+-------");
    } else if (hasSibling[i]) {
      printf("%-8s", "|");
    } else {
      printf("%-8s", " ");
    }
  }

  if (root.children.count > 0) {
    NSInteger tempLevel = level;
    NSInteger i = 0, last = root.children.count - 1;
    for (WRTreeNode *child in root.children) {
      hasSibling[tempLevel] = i < last;
      [self printTreeHelper:child];
      i++;
    }
  }
  level--;
}

@end
