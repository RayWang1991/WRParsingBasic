/**
 * Copyright (c) 2017, Ray Wang
 * All rights reserved
 * Author: RayWang
 */

#import "WRWordScanner.h"
#import "WRUtils.h"

typedef NS_ENUM(NSInteger, WRWordScannerState) {
  WRWordScannerStateTypeInWord,
  WRWordScannerStateTypeInSpace,
};

@interface WRWordScanner ()
@property (nonatomic, assign, readwrite) WRWordScannerState state;
@property (nonatomic, assign, readwrite) NSInteger tokenBegin;
@property (nonatomic, assign, readwrite) NSInteger tokenLength;
@property (nonatomic, assign, readwrite) NSInteger strIndex;
// content info
@property (nonatomic, assign, readwrite) NSInteger currentColumn;
@property (nonatomic, assign, readwrite) NSInteger currentLine;
@property (nonatomic, assign, readwrite) NSInteger numOfEof;
@end

@implementation WRWordScanner

#pragma mark -public
// eof num
- (void)setNumOfEof:(NSInteger)num {
  _numOfEof = num;
}

- (void)startScan {
  _state = WRWordScannerStateTypeInSpace;
  _tokenBegin = 0;
  _tokenLength = 0;
  _strIndex = 0;
  self.tokenIndex = 0; // token to be return
  _currentColumn = 0;
  _currentLine = 0;
  [self.tokens removeAllObjects];
  [self.errors removeAllObjects];
}

- (void)resetTokenIndex {
  self.tokenIndex = 0;
}

- (void)resetAll{
  [self resetTokenIndex];
}

- (WRTerminal *)tokenAtIndex:(NSInteger)index {
  if (index < 0 || index + 1 > self.tokens.count) {
    return nil;
  }
  return self.tokens[index];
}

// TODO simplify here
- (WRTerminal *)nextToken {
  assert(self.tokenIndex <= self.tokens.count);

  if (self.tokenIndex < self.tokens.count) {
    // already have, just return
    return self.tokens[(self.tokenIndex)++];
  } else if (_strIndex >= self.inputStr.length) {
    // to the end
    if (_numOfEof > 0) {
      WRTerminal *token = [WRTerminal tokenWithSymbol:WREndOfFileTokenSymbol];
      WRTerminalContentInfo contentInfo = {_currentLine, _currentColumn, 0};
      token.contentInfo = contentInfo;
      [self.tokens addObject:token];
      _numOfEof--;
      return token;
    } else {
      // this is the real end
      return nil;
    }
  } else {
    // run the DFA to find next
    assert(self.state == WRWordScannerStateTypeInSpace);
    NSInteger len = self.inputStr.length;
    BOOL foundToken = NO;
    while (_strIndex < len && !foundToken) {
      unichar c = [self.inputStr characterAtIndex:_strIndex];
      switch (_state) {
        case WRWordScannerStateTypeInSpace: {
          switch (c) {
            case '\n':
            case '\r': {
              _currentColumn = -1;
              _currentLine++;
            }
              // fall through
            case ' ':
            case '\t': {
              _strIndex++;
              _currentColumn++;
              break;
            }
            default: {
              _state = WRWordScannerStateTypeInWord;
              _tokenBegin = _strIndex;
              _strIndex++;
              _currentColumn++;
              break;
            }
          }
          break;
        }
        case WRWordScannerStateTypeInWord: {
          switch (c) {
            case ' ':
            case '\t': {
              _state = WRWordScannerStateTypeInSpace;
              _tokenLength = _strIndex - _tokenBegin;
              [self addToken];
              _strIndex++;
              _currentColumn++;
              foundToken = YES;
              break;
            }
            case '\n':
            case '\r': {
              _state = WRWordScannerStateTypeInSpace;
              _tokenLength = _strIndex - _tokenBegin;
              [self addToken];
              _strIndex++;
              _currentColumn = 0;
              _currentLine++;
              foundToken = YES;
              break;
            }
            default: {
              _state = WRWordScannerStateTypeInWord;
              _strIndex++;
              _currentColumn++;
              break;
            }
          }
          break;
        }
      }
    }
    if (foundToken) {
      self.tokenIndex++;
      return [self.tokens lastObject];
    } else {
      // needs check
      switch (_state) {
        case WRWordScannerStateTypeInWord: {
          _state = WRWordScannerStateTypeInSpace;
          _tokenLength = _strIndex - _tokenBegin;
          [self addToken];
          self.tokenIndex++;
          return [self.tokens lastObject];
        }
          // fall through
        case WRWordScannerStateTypeInSpace: {
          if (_numOfEof > 0) {
            WRTerminal *token = [WRTerminal tokenWithSymbol:WREndOfFileTokenSymbol];
            WRTerminalContentInfo contentInfo = {_currentLine, _currentColumn, 0};
            token.contentInfo = contentInfo;
            [self.tokens addObject:token];
            _numOfEof--;
            self.tokenIndex++;
            return token;
          } else {
            // this is the real end
            return nil;
          }
          break;
        }
        default:break;
      }
    }
  }
  return nil;
}

- (void)scanToEnd {
  NSInteger len = self.inputStr.length;
  while (_strIndex < len) {
    unichar c = [self.inputStr characterAtIndex:_strIndex];
    switch (_state) {
      case WRWordScannerStateTypeInSpace: {
        switch (c) {
          case '\n':
          case '\r': {
            _currentColumn = -1;
            _currentLine++;
          }
            // fall through
          case ' ':
          case '\t': {
            _strIndex++;
            _currentColumn++;
            break;
          }
          default: {
            _state = WRWordScannerStateTypeInWord;
            _tokenBegin = _strIndex;
            _strIndex++;
            _currentColumn++;
            break;
          }
        }
        break;
      }
      case WRWordScannerStateTypeInWord: {
        switch (c) {
          case ' ':
          case '\t': {
            _state = WRWordScannerStateTypeInSpace;
            _tokenLength = _strIndex - _tokenBegin;
            [self addToken];
            _strIndex++;
            _currentColumn++;
            break;
          }
          case '\n':
          case '\r': {
            _state = WRWordScannerStateTypeInSpace;
            _tokenLength = _strIndex - _tokenBegin;
            [self addToken];
            _strIndex++;
            _currentColumn = 0;
            _currentLine++;
            break;
          }
          default: {
            _state = WRWordScannerStateTypeInWord;
            _strIndex++;
            _currentColumn++;
            break;
          }
        }
        break;
      }
    }
  }
  switch (_state) {
    case WRWordScannerStateTypeInWord: {
      _state = WRWordScannerStateTypeInSpace;
      _tokenLength = _strIndex - _tokenBegin;
      [self addToken];
    }
      // fall through
    case WRWordScannerStateTypeInSpace: {
      for (; _numOfEof > 0; _numOfEof--) {
        WRTerminal *token = [WRTerminal tokenWithSymbol:WREndOfFileTokenSymbol];
        WRTerminalContentInfo contentInfo = {_currentLine, _currentColumn, 0};
        token.contentInfo = contentInfo;
        [self.tokens addObject:token];
      }
      break;
    }
    default:break;
  }
}

#pragma mark -private
- (void)addToken {
  NSString *symbol = [self.inputStr substringWithRange:NSMakeRange(_tokenBegin, _tokenLength)];
  WRTerminalContentInfo contentInfo = {_currentLine, _currentColumn - 1, _tokenLength};
  // must be terminal
  WRTerminal *token = [WRTerminal tokenWithSymbol:symbol];
  token.contentInfo = contentInfo;
  token.terminalType = self.language.token2IdMapper[symbol].integerValue;
  [self.tokens addObject:token];
}

- (void)test {
  NSString *input = @"this    is\n ab test\n\n123 \t456";

  self.inputStr = input;
  self.numOfEof = 1;
  [self startScan];
  [self scanToEnd];
  assert(self.tokens.count == 7);
  assert(wrCheckTerminal(self.tokens[0], @"this", 4, 0, 3));
  assert(wrCheckTerminal(self.tokens[1], @"is", 2, 0, 9));
  assert(wrCheckTerminal(self.tokens[2], @"ab", 2, 1, 2));
  assert(wrCheckTerminal(self.tokens[3], @"test", 4, 1, 7));
  assert(wrCheckTerminal(self.tokens[4], @"123", 3, 3, 2));
  assert(wrCheckTerminal(self.tokens[5], @"456", 3, 3, 7));
}


@end
