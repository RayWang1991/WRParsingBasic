/**
 * Copyright (c) 2017, Ray Wang
 * All rights reserved
 * Author: RayWang
 */

#import "WRTreePattern.h"

@implementation WRTreePatternAction
@end

@implementation WRTreePatternMatchAction
@end

@interface WRTreePattern ()
@property (nonatomic, strong, readwrite) NSMutableArray <WRTreePatternAction *> *actions;
@end

@implementation WRTreePattern

- (instancetype)initWithString:(NSString *)string {
  if (self = [super init]) {
    _actions = [NSMutableArray array];
    [self constructWithString:[string mutableCopy]];
  }
  return self;
}

+ (instancetype)treePatternWithString:(NSString *)string {
  return [[WRTreePattern alloc] initWithString:string];
}

- (NSArray <WRTreePatternAction *> *)actions {
  return _actions;
}

typedef NS_ENUM(NSInteger, WRTreePatthenState) {
  WRTreePatternStateBegin,
  WRTreePatternStateInWord,
};

// a simple hand write lexer
// TODO handle more '/'s
- (void)constructWithString:(NSMutableString *)string {
  BOOL hasGoDown = NO;
  WRTreePatthenState state = WRTreePatternStateBegin;
  NSInteger beginPos = -1;
  for (NSInteger i = 0; i < string.length; i++) {
    unichar c = [string characterAtIndex:i];
    switch (state) {
      case WRTreePatternStateBegin: {
        switch (c) {
          case '\\' : {
            // delete '\' and skip to check next char
            state = WRTreePatternStateInWord;
            [string deleteCharactersInRange:NSMakeRange(i, 1)];
            beginPos = i;
            break;
          }
          case ' ':
          case '\t':
          case '\n':
          case '\r':break;
          case '(': {
            hasGoDown = YES;
            state = WRTreePatternStateBegin;
            break;
          }
          case ')': {
            WRTreePatternAction *action = [[WRTreePatternAction alloc] init];
            action.type = WRTreePatternMatchActionGoUp;
            [_actions addObject:action];
            state = WRTreePatternStateBegin;
            break;
          }
          default:state = WRTreePatternStateInWord;
            beginPos = i;
        }
        break;
      }
      case WRTreePatternStateInWord: {
        switch (c) {
          case ' ':
          case '\t':
          case '\n':
          case '\r': {
            [self addMatchActionWithSymbol:[string substringWithRange:NSMakeRange(beginPos, i - beginPos)]
                              andHasGoDown:hasGoDown];
            hasGoDown = NO;

            state = WRTreePatternStateBegin;
            break;
          }
          case '(': {
            [self addMatchActionWithSymbol:[string substringWithRange:NSMakeRange(beginPos, i - beginPos)]
                              andHasGoDown:hasGoDown];

            hasGoDown = YES;
            state = WRTreePatternStateBegin;
            break;
          }
          case ')': {
            if (hasGoDown) {
              // TODO error handle
              assert(NO);
            }
            [self addMatchActionWithSymbol:[string substringWithRange:NSMakeRange(beginPos, i - beginPos)]
                              andHasGoDown:NO];
            WRTreePatternAction *action1 = [[WRTreePatternAction alloc] init];
            action1.type = WRTreePatternMatchActionGoUp;
            [_actions addObject:action1];
            state = WRTreePatternStateBegin;
            break;
          }
          case '\\': {
            // should remove the '\' symbol and skip to check next char
            [string deleteCharactersInRange:NSMakeRange(i, 1)];
            break;
          }
          default:break;
        }
        break;
      }
      default:break;
    }
  }
}

- (void)addMatchActionWithSymbol:(NSString *)symbol
                    andHasGoDown:(BOOL)hasGoDown {
  WRTreePatternMatchAction *action = [[WRTreePatternMatchAction alloc] init];
  action.symbol = symbol;
  [_actions addObject:action];
  if(hasGoDown){
    WRTreePatternAction *goDown = [[WRTreePatternAction alloc] init];
    goDown.type = WRTreePatternMatchActionGoDown;
    [_actions addObject:goDown];
  }
}

@end
