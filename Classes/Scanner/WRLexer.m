/**
 * Copyright (c) 2017, Ray Wang
 * All rights reserved
 * Author: RayWang
 */

#import "WRLexer.h"
#import "WRTerminal.h"
const NSString *kWRLexerErrorDomain = @"WR.Error.Lexer";

@interface WRLexer ()
@property (nonatomic, assign, readwrite) int currentLine;
@property (nonatomic, assign, readwrite) int currentColumn;
@property (nonatomic, assign, readwrite) int tokenBegin;
@end

@implementation WRLexer

/******************************************************
 *  Type                      Regex
 *
 *  digit                     [0-9]+
 *  identifier                [_a-zA-Z]+[_a-zA-Z0-9]*
 *  plus                      +
 *  minus                     -
 *  mult                      x
 *  divide                    /
 *  mod                       %
 *  equal                     =
 *  gt                        >
 *  lt                        <
 *  gtOrEq                    >=
 *  ltOrEq                    <=
 *  notEq                     <>
 *  not                       not           Id table to recoginze
 *  and                       and
 *  or                        or
 *  string                    "[^"]*"       The escaped character is disposed
 *  whilteSpace               [ \t\n]*
 *  comment                   --[^/n]*\n
 *
 *******************************************************/
typedef NS_ENUM(NSInteger, WRLexerTokenType) {
  WRLexerTokenTypeUnkown,
  WRLexerTokenTypeError,

  WRLexerTokenTypeDIGIT,
  WRLexerTokenTypeIDENTIFIER,
  WRLexerTokenTypeSTRING,
  // OPERATORS
    WRLexerTokenTypePLUS,
  WRLexerTokenTypeMINUS,
  WRLexerTokenTypeMULT,
  WRLexerTokenTypeDIV,
  WRLexerTokenTypeMOD,
  WRLexerTokenTypeEQ,
  WRLexerTokenTypeNEQ,
  WRLexerTokenTypeGT,
  WRLexerTokenTypeLT,
  WRLexerTokenTypeGTE,
  WRLexerTokenTypeLTE,
  WRLexerTokenTypeNOT,
  WRLexerTokenTypeAND,
  WRLexerTokenTypeOR,
  // RESERVED
    WRLexerTokenTypeIF,
  WRLexerTokenTypeELSE,
  WRLexerTokenTypeREPEAT,
  WRLexerTokenTypeUNTIL,
  WRLexerTokenTypeWHILE,
  WRLexerTokenTypeFOR,
  WRLexerTokenTypeEND,
};

typedef NS_ENUM(NSInteger, WRLexerState) {
  WRLexerStateTypeBegin,
  WRLexerStateTypeInDIGIT,
  WRLexerStateTypeInIDENTIFIER,
  // NO State for operators
    WRLexerStateTypeInComment,
  WRLexerStateTypeInString,
};

- (void)startScan {
  unichar charArray[self.inputStr.length];
  [self.inputStr getCharacters:charArray];
  unichar *read = charArray;
  WRLexerState state = WRLexerStateTypeBegin;
  _currentColumn = 0;
  _currentLine = 0;
  NSInteger i = 0;
  for (; i < self.inputStr.length; i++, _currentColumn++) {

    unichar c = charArray[i];

    switch (state) {
      case WRLexerStateTypeBegin:_tokenBegin = i;
        switch (c) {
          case '+':
            [self addTokenWithLength:1
                             andType:WRLexerTokenTypePLUS];
            break;
          case '-':
            switch (charArray[i + 1]) {
              case '-':state = WRLexerStateTypeInComment;
                i++;
                _currentColumn++;
                break;
              default:
                [self addTokenWithLength:1
                                 andType:WRLexerTokenTypeMINUS];
            }
            break;
          case 'x':
            [self addTokenWithLength:1
                             andType:WRLexerTokenTypeMULT];
            break;
          case '/':
            [self addTokenWithLength:1
                             andType:WRLexerTokenTypeDIV];
            break;
          case '%':
            [self addTokenWithLength:1
                             andType:WRLexerTokenTypeMOD];
            break;
          case '=':
            [self addTokenWithLength:1
                             andType:WRLexerTokenTypeEQ];
            break;
          case '<':
            switch (charArray[i + 1]) {
              case '=': i++;
                i++;
                _currentColumn++;
                [self addTokenWithLength:2
                                 andType:WRLexerTokenTypeLTE];

                break;
              case '>':i++;
                _currentColumn++;
                [self addTokenWithLength:2
                                 andType:WRLexerTokenTypeNEQ];
                break;
              default:
                [self addTokenWithLength:1
                                 andType:WRLexerTokenTypeLT];
                break;
            }
            break;
          case '>':
            switch (charArray[i + 1]) {
              case '=':i++;
                _currentColumn++;
                [self addTokenWithLength:2
                                 andType:WRLexerTokenTypeGTE];
                break;
              default:
                [self addTokenWithLength:1
                                 andType:WRLexerTokenTypeGT];
                break;
            }
            break;
          case ' ':
          case '\t':break;
          case '\r':
          case '\n':_currentLine++;
            _currentColumn = -1;// haven't read the next line's first symbol
            break;
          case '\"':state = WRLexerStateTypeInString;
            break;
          default: {
            if (c >= '0' && c <= '9') {
              state = WRLexerStateTypeInDIGIT;
            } else if (c == '_' || c >= 'a' && c <= 'z' || c >= 'A' && c <= 'Z') {
              state = WRLexerStateTypeInIDENTIFIER;
            } else {
              [self addErrorWithLength:1
                            andMessage:@"Unrecognized symbol."];
            }
            break;
          }
        }
        break;
      case WRLexerStateTypeInDIGIT: {
        if (c >= '0' && c <= '9') {
          // keep in digit
        } else {
          [self addTokenWithLength:i - _tokenBegin
                           andType:WRLexerTokenTypeDIGIT];
          state = WRLexerStateTypeBegin;
          i--;
          _currentColumn--;
        }
        break;
      }
      case WRLexerStateTypeInIDENTIFIER: {
        if (c == '_' || c >= 'a' && c <= 'z' || c >= 'A' && c <= 'Z' || c >= '0' && c <= '9') {
          // keep in id
        } else {
          [self addTokenWithLength:i - _tokenBegin
                           andType:WRLexerTokenTypeIDENTIFIER];
          state = WRLexerStateTypeBegin;
          i--;
          _currentColumn--;
        }
        break;
      }
      case WRLexerStateTypeInString: {
        switch (c) {
          case '\"': {
            _tokenBegin++;
            // cauz token begin points to \"
            [self addTokenWithLength:i - _tokenBegin
                             andType:WRLexerTokenTypeSTRING];
            state = WRLexerStateTypeBegin;
            break;
          }
          case '\n': {
            [self addErrorWithLength:1
                          andMessage:@"String literal should be write in one line."];
            _currentLine++;
            _currentColumn = -1;// havent read the next line's first symbol
            break;
          }
          default: {
            // keep in string
            break;
          }
        }
        break;
      }
      case WRLexerStateTypeInComment: {
        switch (c) {
          case '\n':_currentLine++;
            _currentColumn = -1;// havent read the next line's first symbol
            state = WRLexerStateTypeBegin;
            break;

          default:
            // keep in comment
            break;
        }
        break;
      }
      default: {

        break;
      }
    }
  }
  switch (state) {
    case WRLexerStateTypeBegin:
    case WRLexerStateTypeInComment:break;
    case WRLexerStateTypeInDIGIT:
      [self addTokenWithLength:i - _tokenBegin
                       andType:WRLexerTokenTypeDIGIT];
      break;
    case WRLexerStateTypeInIDENTIFIER:
      [self addTokenWithLength:i - _tokenBegin
                       andType:WRLexerTokenTypeIDENTIFIER];
      break;
    case WRLexerStateTypeInString:
      [self addErrorWithLength:1
                    andMessage:@"String literal should be write in one line."];
    default: {
      break;
    }
  }
}

- (void)addTokenWithLength:(int)length
                   andType:(WRLexerTokenType)type {
  WRTerminalContentInfo contentInfo = {_currentLine, _currentColumn, length};
  WRTerminal *token = [[WRTerminal alloc] init];
  NSString *value = [self.inputStr substringWithRange:NSMakeRange(_tokenBegin, length)];

  switch (type) {

    case WRLexerTokenTypeIDENTIFIER:
      type = [value isEqualToString:@"and"] ? WRLexerTokenTypeAND :
        [value isEqualToString:@"or"] ? WRLexerTokenTypeOR :
          [value isEqualToString:@"not"] ? WRLexerTokenTypeNOT :
            [value isEqualToString:@"if"] ? WRLexerTokenTypeIF :
              [value isEqualToString:@"else"] ? WRLexerTokenTypeELSE :
                [value isEqualToString:@"repeat"] ? WRLexerTokenTypeREPEAT :
                  [value isEqualToString:@"until"] ? WRLexerTokenTypeUNTIL :
                    [value isEqualToString:@"while"] ? WRLexerTokenTypeWHILE :
                      [value isEqualToString:@"for"] ? WRLexerTokenTypeFOR :
                        [value isEqualToString:@"end"] ? WRLexerTokenTypeEND :
                          WRLexerTokenTypeIDENTIFIER;
      token.symbol = type == WRLexerTokenTypeIDENTIFIER ? @"id" : value;
      token.value = value;
      contentInfo.column--;
      break;
    case WRLexerTokenTypeSTRING:token.symbol = @"string";
      token.value = value;
      break;
    case WRLexerTokenTypeDIGIT:token.symbol = @"digit";
      contentInfo.column--;
      token.value = value;
      break;
    case WRLexerTokenTypeMINUS:
    case WRLexerTokenTypePLUS:
    case WRLexerTokenTypeMULT:
    case WRLexerTokenTypeDIV:
    case WRLexerTokenTypeMOD:
    case WRLexerTokenTypeEQ:
    case WRLexerTokenTypeNEQ:
    case WRLexerTokenTypeGT:
    case WRLexerTokenTypeGTE:
    case WRLexerTokenTypeLT:
    case WRLexerTokenTypeLTE:token.symbol = value;
    default:break;
  }

  token.contentInfo = contentInfo;
  [self.tokens addObject:token];
}

- (void)addErrorWithLength:(int)length
                andMessage:(NSString *)message {
  WRTerminalContentInfo contentInfo = {_currentLine, _currentColumn, length};

  NSString *errorInfo = [NSString stringWithFormat:@"Line:%d Colum:%d, %@",
                                                   _currentLine,
                                                   _currentColumn,
                                                   message];

  NSError *error = [NSError errorWithDomain:kWRLexerErrorDomain
                                       code:0
                                   userInfo:@{@"message": errorInfo}];

  [self.errors addObject:error];
}

- (WRTerminal *)nextToken {
  return nil;
}

#define TR(String) @#String
#define LEN (self.tokens.count)
#define LINE (self.tokens.lastObject.cotentInfo.line)

- (void)testReserve {
  NSString *input =
    TR(1
         This
           is
         not
         reverse \n
         and this or \n
         if \n
         else a \n
         b cThe language is \n
         mine);

  self.inputStr = input;
  self.startScan;

  assert(self.tokens.count == 16);
  assert(self.errors.count == 0);

  NSArray <NSNumber *> *lengthArray = @[@1, @4, @2, @3, @7, @3, @4, @2, @2, @4, @1, @1, @4, @8, @2, @4];
  NSArray <NSNumber *> *lineArray = @[@5, @3, @1, @2, @4, @1];
  NSMutableArray <NSNumber *> *lengthArray_test = [NSMutableArray array];
  NSMutableArray <NSNumber *> *lineArray_test = [NSMutableArray array];

  int lastLine = 0;
  int numInLine = 0;
  for (int i = 0; i < self.tokens.count; i++) {
    WRTerminal *token = self.tokens[i];
    assert(token.contentInfo.length == [lengthArray[i] integerValue]);
    int currentLine = token.contentInfo.line;
    if (lineArray_test.count >= currentLine + 1) {
      lineArray_test[currentLine] = @([lineArray_test[currentLine] integerValue] + 1);
    } else {
      // add 0's to last line
      while (lineArray_test.count < currentLine) {
        [lineArray_test addObject:@0];
      }
      [lineArray_test addObject:@(1)];
    }
  }

  assert(lineArray.count == lineArray_test.count);
  for (int i = 0; i < lineArray.count; i++) {
    assert([lineArray[i] isEqualToNumber:lineArray_test[i]]);
  }


  // content test
  assert([self.tokens[0].symbol isEqualToString:@"digit"]);
  assert([self.tokens[1].symbol isEqualToString:@"id"]);
  assert([self.tokens[2].symbol isEqualToString:@"id"]);
  assert([self.tokens[3].symbol isEqualToString:@"not"]);
  assert([self.tokens[4].symbol isEqualToString:@"id"]);
  assert([self.tokens[5].symbol isEqualToString:@"and"]);
  assert([self.tokens[6].symbol isEqualToString:@"id"]);
  assert([self.tokens[7].symbol isEqualToString:@"or"]);
  assert([self.tokens[8].symbol isEqualToString:@"if"]);
  assert([self.tokens[9].symbol isEqualToString:@"else"]);
  assert([self.tokens[10].symbol isEqualToString:@"id"]);
  assert([self.tokens[11].symbol isEqualToString:@"id"]);
  assert([self.tokens[12].symbol isEqualToString:@"id"]);
  assert([self.tokens[14].symbol isEqualToString:@"id"]);
  assert([self.tokens[15].symbol isEqualToString:@"id"]);

  // end column test
  assert(self.tokens[0].contentInfo.column == 0);
  assert(self.tokens[1].contentInfo.column == 5);
  assert(self.tokens[2].contentInfo.column == 8);
  assert(self.tokens[3].contentInfo.column == 12);
  assert(self.tokens[4].contentInfo.column == 20);
  assert(self.tokens[5].contentInfo.column == 3);
  assert(self.tokens[12].contentInfo.column == 6);
  assert(self.tokens[13].contentInfo.column == 15);
  assert(self.tokens[15].contentInfo.column == 4);
}

- (void)testDigit {
  NSString *input =
    TR(12345
         e
         123f \n
         17\n
         123);

  self.inputStr = input;
  self.startScan;

  assert(self.tokens.count == 6);
  assert(self.errors.count == 0);

  NSArray <NSNumber *> *lengthArray = @[@5, @1, @3, @1, @2, @3];
  NSArray <NSNumber *> *lineArray = @[@4, @1, @1];
  NSMutableArray <NSNumber *> *lengthArray_test = [NSMutableArray array];
  NSMutableArray <NSNumber *> *lineArray_test = [NSMutableArray array];

  int lastLine = 0;
  int numInLine = 0;
  for (int i = 0; i < self.tokens.count; i++) {
    WRTerminal *token = self.tokens[i];
    assert(token.contentInfo.length == [lengthArray[i] integerValue]);
    int currentLine = token.contentInfo.line;
    if (lineArray_test.count >= currentLine + 1) {
      lineArray_test[currentLine] = @([lineArray_test[currentLine] integerValue] + 1);
    } else {
      // add 0's to last line
      while (lineArray_test.count < currentLine) {
        [lineArray_test addObject:@0];
      }
      [lineArray_test addObject:@(1)];
    }
  }

  assert(lineArray.count == lineArray_test.count);
  for (int i = 0; i < lineArray.count; i++) {
    assert([lineArray[i] isEqualToNumber:lineArray_test[i]]);
  }


  // content test
  assert([self.tokens[0].symbol isEqualToString:@"digit"]);
  assert([self.tokens[1].symbol isEqualToString:@"id"]);
  assert([self.tokens[2].symbol isEqualToString:@"digit"]);
  assert([self.tokens[3].symbol isEqualToString:@"id"]);
  assert([self.tokens[4].symbol isEqualToString:@"digit"]);
  assert([self.tokens[5].symbol isEqualToString:@"digit"]);

  assert(self.tokens[0].contentInfo.column == 4);
  assert(self.tokens[1].contentInfo.column == 6);
  assert(self.tokens[2].contentInfo.column == 10);
  assert(self.tokens[3].contentInfo.column == 11);
  assert(self.tokens[4].contentInfo.column == 2);
  assert(self.tokens[5].contentInfo.column == 3);

}

- (void)testOp {
  NSString *input =
    TR(0 + 0 - +x / << >= --asdfasdf
         e
         123f \n
         x-  -x\n
         >=<=);

  self.inputStr = input;
  self.startScan;

  assert(self.tokens.count == 16);
  assert(self.errors.count == 0);

  NSArray <NSNumber *> *lengthArray = @[@1, @1, @1, @1, @1, @1, @1, @1, @2, @1, @1, @1, @1, @1, @2, @2];
  NSArray <NSNumber *> *lineArray = @[@10, @4, @2];
  NSMutableArray <NSNumber *> *lengthArray_test = [NSMutableArray array];
  NSMutableArray <NSNumber *> *lineArray_test = [NSMutableArray array];

  int lastLine = 0;
  int numInLine = 0;
  for (int i = 0; i < self.tokens.count; i++) {
    WRTerminal *token = self.tokens[i];
    assert(token.contentInfo.length == [lengthArray[i] integerValue]);
    int currentLine = token.contentInfo.line;
    if (lineArray_test.count >= currentLine + 1) {
      lineArray_test[currentLine] = @([lineArray_test[currentLine] integerValue] + 1);
    } else {
      // add 0's to last line
      while (lineArray_test.count < currentLine) {
        [lineArray_test addObject:@0];
      }
      [lineArray_test addObject:@(1)];
    }
  }

  assert(lineArray.count == lineArray_test.count);
  for (int i = 0; i < lineArray.count; i++) {
    assert([lineArray[i] isEqualToNumber:lineArray_test[i]]);
  }


  // content test
  assert([self.tokens[0].symbol isEqualToString:@"digit"]);
  assert([self.tokens[1].symbol isEqualToString:@"+"]);
  assert([self.tokens[2].symbol isEqualToString:@"digit"]);
  assert([self.tokens[3].symbol isEqualToString:@"-"]);
  assert([self.tokens[5].symbol isEqualToString:@"x"]);
  assert([self.tokens[6].symbol isEqualToString:@"/"]);
  assert([self.tokens[8].symbol isEqualToString:@"<>"]);
  assert([self.tokens[15].symbol isEqualToString:@"<="]);

//  assert(self.tokens[0].contentInfo.column == 0);
//  assert(self.tokens[1].contentInfo.column == 1);
//  assert(self.tokens[2].contentInfo.column == 2);
//  assert(self.tokens[3].contentInfo.column == 3);
//  assert(self.tokens[4].contentInfo.column == 4);
//  assert(self.tokens[5].contentInfo.column == 5);
//  assert(self.tokens[8].contentInfo.column == 9);
//  assert(self.tokens[15].contentInfo.column == 4);
//  assert(self.tokens[14].contentInfo.column == 2);

}

- (void)testString {
  NSString *input =
    @"\"This is a string\" \n"
      "\"Hello world!\" \"Another string in same line\" \n"
      "\"This should cause an error\n"
      "\"\"" "-- empty string\n";

  self.inputStr = input;
  self.startScan;

  assert(self.tokens.count == 4);
  assert(self.errors.count == 3);

  NSArray <NSNumber *> *lengthArray = @[@16, @12, @27, @27];
  NSArray <NSNumber *> *lineArray = @[@1, @2, @0, @1];
  NSMutableArray <NSNumber *> *lengthArray_test = [NSMutableArray array];
  NSMutableArray <NSNumber *> *lineArray_test = [NSMutableArray array];

  int lastLine = 0;
  int numInLine = 0;
  for (int i = 0; i < self.tokens.count; i++) {
    WRTerminal *token = self.tokens[i];
    assert(token.contentInfo.length == [lengthArray[i] integerValue]);
    int currentLine = token.contentInfo.line;
    if (lineArray_test.count >= currentLine + 1) {
      lineArray_test[currentLine] = @([lineArray_test[currentLine] integerValue] + 1);
    } else {
      // add 0's to last line
      while (lineArray_test.count < currentLine) {
        [lineArray_test addObject:@0];
      }
      [lineArray_test addObject:@(1)];
    }
  }

  assert(lineArray.count == lineArray_test.count);
  for (int i = 0; i < lineArray.count; i++) {
    assert([lineArray[i] isEqualToNumber:lineArray_test[i]]);
  }


  // content test
  assert([self.tokens[0].symbol isEqualToString:@"string"]);
  assert([self.tokens[1].symbol isEqualToString:@"string"]);
  assert([self.tokens[2].symbol isEqualToString:@"string"]);
  assert([self.tokens[3].symbol isEqualToString:@"string"]);

  assert(self.tokens[0].contentInfo.column == 17);
  assert(self.tokens[1].contentInfo.column == 13);
  assert(self.tokens[2].contentInfo.column == 43);
  assert(self.tokens[3].contentInfo.column == 0);
}

- (void)test {
  [self testReserve];
  [self testDigit];
  [self testOp];
  [self testString];
}

@end
