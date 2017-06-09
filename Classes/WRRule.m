/**
 * Copyright (c) 2017, Ray Wang
 * All rights reserved
 * Author: RayWang
 */

#import "WRRule.h"

@implementation WRRule

- (instancetype)initWithRule:(NSString *)rule{
  if(self = [super init]){
    _rule = rule;
    [self disposeRule];
  }
  return self;
}

+ (instancetype)ruleWithRule:(NSString *)ruleStr{
  WRRule *wrRule = [[WRRule alloc]initWithRule:ruleStr];
  return wrRule;
}

- (void)disposeRule{
  NSRange range = [_rule rangeOfString:@"->"];
  NSCharacterSet *whitespaceCharacterSet = [NSCharacterSet whitespaceCharacterSet];
  
  // #### left token ####
  NSString *left = [[_rule substringToIndex:range.location]
                    stringByTrimmingCharactersInSet:whitespaceCharacterSet];
  _leftToken = [WRToken tokenWithType:nonTerminal andSymbol:left];
  
  // #### right tokens ####
  NSInteger i = range.location + range.length;
  NSInteger head = -1; // head -1 means head not found, here head is the first char of word
  
  NSMutableArray *words = [NSMutableArray array];
  
  for(; i < _rule.length; i++){
    unichar cc = [_rule characterAtIndex:i];
    
    // state machine
    // state head found, head not found,
    // transition is word, is not
    
    if([whitespaceCharacterSet characterIsMember:cc]){
      if(head < 0){
        // head not found, white space
        // keep the state
        ;
      } else{
        // head found, valid character
        // state goes to head not found, out put word
        [words addObject:[_rule substringWithRange:NSMakeRange(head, i - head)]];
        head = -1;
      }
    } else{
      if(head < 0){
        // head not found, valid character
        // state goes to head found
        head = i;
      } else{
        // head found, white space
        ;
        // keep the state
      }
    }
  }
  
  // transition is white space
  if(head >= 0){
    // if head found, output word
    [words addObject:[_rule substringWithRange:NSMakeRange(head, i - head)]];
  }
  
  NSMutableArray *array = [NSMutableArray array];
  for(NSString * word in words){
    [array addObject:[WRToken tokenWithSymbol:word]];
  }
  _rightTokens = array;
}

- (NSString *)description{
  return self.rule;
}

@end
