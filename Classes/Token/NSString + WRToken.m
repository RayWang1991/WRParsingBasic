/**
 * Copyright (c) 2017, Ray Wang
 * All rights reserved
 * Author: RayWang
 */

#import "NSString + WRToken.h"

NSString *const WREndOfFileTokenSymbol = @"eof";
NSString *const WREpsilonTokenSymbol = @"epsilon";

@implementation NSString (WRToken)

- (WRTokenType)tokenTypeForString{
  if(!self.length){
    // should not be actually
    // reserved for epsilon
    return terminal;
  }
  unichar firstChar = [self characterAtIndex:0];
  WRTokenType type = [[NSCharacterSet uppercaseLetterCharacterSet]
                      characterIsMember:firstChar] ? nonTerminal: terminal;
  return type;
}

@end
