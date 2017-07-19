/**
 * Copyright (c) 2017, Ray Wang
 * All rights reserved
 * Author: RayWang
 */

#import "WRRule.h"
#import "WRTerminal.h"
#import "WRNonterminal.h"

@interface WRRule ()
@property (nonatomic, strong, readwrite) NSString *ruleStr;
@end

@implementation WRRule

- (instancetype)initWithRuleStr:(NSString *)ruleStr {
  if (self = [super init]) {
    [self disposeRuleWithRuleString:ruleStr];
  }
  return self;
}

+ (instancetype)ruleWithRuleStr:(NSString *)ruleStr {
  WRRule *wrRule = [[WRRule alloc] initWithRuleStr:ruleStr];
  return wrRule;
}

- (instancetype)initWithRule:(WRRule *)rule {
  if (self = [super init]) {
    _ruleStr = rule.ruleStr; // same rule
    _leftToken = rule.leftToken; // same token
    _rightTokens = rule.rightTokens; // same tokens
  }
  return self;
}

+ (instancetype)ruleWithRule:(WRRule *)rule {
  return [[WRRule alloc] initWithRule:rule];
}

typedef NS_ENUM(NSInteger, WRRuleCharType) {
  CharTypeWord,
  CharTypeWhiteSpace,
  CharTypeOr
};

+ (NSArray <WRRule *> *)rulesWithOrRuleStr:(NSString *)ruleStr {
  NSRange range = [ruleStr rangeOfString:@"->"];
  NSCharacterSet *whitespaceCharacterSet = [NSCharacterSet whitespaceCharacterSet];
  NSCharacterSet *orSet = [NSCharacterSet characterSetWithCharactersInString:@"|"];
  NSInteger ruleIndex = 0;

  NSMutableArray *rules = [NSMutableArray array];
  // #### left token ####
  NSString *leftToken = [[ruleStr substringToIndex:range.location]
    stringByTrimmingCharactersInSet:whitespaceCharacterSet];

  NSInteger i = range.location + range.length;
  NSInteger head = -1; // head -1 means head not found, here head is the first char of word
  NSMutableArray *words = [NSMutableArray array];
  NSInteger orFound = 0;

  for (; i < ruleStr.length; i++) {
    unichar cc = [ruleStr characterAtIndex:i];
    WRRuleCharType type = [whitespaceCharacterSet characterIsMember:cc] ? CharTypeWhiteSpace :
      [orSet characterIsMember:cc] ? CharTypeOr : CharTypeWord;
    // state machine
    // state head found, head not found,
    // transition is word, is white, is |
    switch (type) {
      case CharTypeOr: {
        // out put rule
        orFound++;
        if (head < 0) {
          // not found head
          ;
        } else {
          [words addObject:[ruleStr substringWithRange:NSMakeRange(head, i - head)]];
          head = -1;
        }
        WRRule *rule = [[WRRule alloc] init];
        rule.leftToken = leftToken;
        rule.rightTokens = [NSArray arrayWithArray:words];
        rule.ruleIndex = ruleIndex++;
        [words removeAllObjects];
        [rules addObject:rule];
        head = -1;
        break;
      }

      case CharTypeWord: {
        // find a valid char
        if (head < 0) {
          head = i;
        } else { ;
        }
        break;
      }
      case CharTypeWhiteSpace: {
        // find a whiteSpace
        if (head < 0) { ;
        } else {
          [words addObject:[ruleStr substringWithRange:NSMakeRange(head, i - head)]];
          head = -1;
        }
        break;
      }
      default:break;
    }
  }

  // input string comes to end
  if (head >= 0) {
    // if head found, output word
    [words addObject:[ruleStr substringWithRange:NSMakeRange(head, i - head)]];
  }

  // check or number
  if (orFound + 1 > rules.count) {
    WRRule *rule = [[WRRule alloc] init];
    rule.leftToken = leftToken;
    rule.ruleIndex = ruleIndex++;
    rule.rightTokens = [NSArray arrayWithArray:words];
    [rules addObject:rule];
  }
  return rules;

}

- (void)disposeRuleWithRuleString:(NSString *)ruleStr {
  NSRange range = [ruleStr rangeOfString:@"->"];
  NSCharacterSet *whitespaceCharacterSet = [NSCharacterSet whitespaceCharacterSet];

  // #### left token ####
  NSString *left = [[ruleStr substringToIndex:range.location]
    stringByTrimmingCharactersInSet:whitespaceCharacterSet];
  _leftToken = left;

  // #### right tokens ####
  NSInteger i = range.location + range.length;
  NSInteger head = -1; // head -1 means head not found, here head is the first char of word

  NSMutableArray *words = [NSMutableArray array];

  for (; i < ruleStr.length; i++) {
    unichar cc = [ruleStr characterAtIndex:i];

    // state machine
    // state head found, head not found,
    // transition is word, is not

    if ([whitespaceCharacterSet characterIsMember:cc]) {
      if (head < 0) {
        // head not found, white space
        // keep the state
        ;
      } else {
        // head found, valid character
        // state goes to head not found, out put word
        [words addObject:[ruleStr substringWithRange:NSMakeRange(head, i - head)]];
        head = -1;
      }
    } else {
      if (head < 0) {
        // head not found, valid character
        // state goes to head found
        head = i;
      } else {
        // head found, white space
        ;
        // keep the state
      }
    }
  }

  // transition is white space
  if (head >= 0) {
    // if head found, output word
    [words addObject:[ruleStr substringWithRange:NSMakeRange(head, i - head)]];
  }

  _rightTokens = words;
}

- (NSMutableArray <WRToken *> *)getRightTokenArrayUsingOrder:(WRArrayOrder)order{
  NSMutableArray *array = [NSMutableArray arrayWithCapacity :self.rightTokens.count];
  switch (order){
    case WRArrayOrderNormal:{
      for(NSString *token in self.rightTokens){
        WRToken *tokenToAdd;
        if(token.tokenTypeForString == WRTokenTypeTerminal){
          tokenToAdd = [WRTerminal tokenWithSymbol:token];
        } else {
          tokenToAdd = [WRNonterminal tokenWithSymbol:token];
        }
        [array addObject:tokenToAdd];
      }
      break;
    }
    case WRArrayOrderReverse:{
      [self.rightTokens enumerateObjectsWithOptions:NSEnumerationReverse
                                         usingBlock:^(NSString *token, NSUInteger index, BOOL *stop){
                                           WRToken *tokenToAdd;
                                           if(token.tokenTypeForString == WRTokenTypeTerminal){
                                             tokenToAdd = [WRTerminal tokenWithSymbol:token];
                                           } else {
                                             tokenToAdd = [WRNonterminal tokenWithSymbol:token];
                                           }
                                           [array addObject:tokenToAdd];
                                         }];
      break;
    }
    default:break;
  }
  return array;
}

- (NSString *)ruleStr {
  if (nil == _ruleStr) {
    NSMutableString *string = [NSMutableString stringWithFormat:@"%@ ->",
                                                                _leftToken];
    for (NSString *token in self.rightTokens) {
      [string appendFormat:@" %@",
                           token];
    }
    _ruleStr = [NSString stringWithString:string];
  }
  return _ruleStr;
}

- (NSString *)description {
  return self.ruleStr;
}

- (NSString *)dotedRule {
  // override point
  return self.description;
}

- (NSUInteger)hash {
  return self.ruleStr.hash;
}

@end
