/**
 * Copyright (c) 2017, Ray Wang
 * All rights reserved
 * Author: RayWang
 */

#import "WELexer.h"

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
typedef NS_ENUM(NSInteger, WRLexerTokenType){
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

typedef NS_ENUM(NSInteger, WRLexerState){
  WRLexerStateTypeBegin,
  WRLexerStateTypeInDIGIT,
  WRLexerStateTypeInIDENTIFIER,
  // NO State for operators
  WRLexerStateTypeInComment,
  WRLexerStateTypeInString,
};

- (void)startScan{
  unichar charArray[self.inputStr.length];
  [self.inputStr getCharacters:charArray];
  unichar *read = charArray;
  WRLexerState state = WRLexerStateTypeBegin;
  _currentColum = 0;
  _currentLine = 0;
  
  for(NSUInteger i = 0; i < self.inputStr.length; i++, _currentColum++){
    
    unichar c = charArray[i];
    if(c=='\n'){
      
    }
    switch (state) {
      case WRLexerStateTypeBegin:
        _tokenBegin = i;
        switch (c) {
          case '+':
            [self addTokenWithLength:1 andType:WRLexerTokenTypePLUS];
            break;
          case '-':
            switch (charArray[i+1]){
              case '-':
                state = WRLexerStateTypeInComment;
                i++;
                _currentColum++;
                break;
              default:
                [self addTokenWithLength:1 andType:WRLexerTokenTypeMINUS];
            }
            break;
          case 'x':
            [self addTokenWithLength:1 andType:WRLexerTokenTypeMULT];
            break;
          case '/':
            [self addTokenWithLength:1 andType:WRLexerTokenTypeDIV];
            break;
          case '%':
            [self addTokenWithLength:1 andType:WRLexerTokenTypeMOD];
            break;
          case '=':
            [self addTokenWithLength:1 andType:WRLexerTokenTypeEQ];
            break;
          case '<':
            switch (charArray[i+1]) {
              case '=':
                [self addTokenWithLength:2 andType:WRLexerTokenTypeLTE];
                i++;
                _currentColum++;
                break;
              case '>':
                [self addTokenWithLength:2 andType:WRLexerTokenTypeNEQ];
                i++;
                _currentColum++;
                break;
              default:
                [self addTokenWithLength:1 andType:WRLexerTokenTypeLT];
                break;
            }
            break;
          case '>':
            switch (charArray[i+1]) {
              case '=':
                [self addTokenWithLength:2 andType:WRLexerTokenTypeGTE];
                i++;
                _currentColum++;
                break;
              default:
                [self addTokenWithLength:1 andType:WRLexerTokenTypeGT];
                break;
            }
            break;
          case ' ':
          case '\t':
          case '\r':
            break;
          case '\n':
            _currentLine++;
            _currentColum = -1;// havent read the next line's first symbol
            break;
          case '\"':
            state = WRLexerStateTypeInString;
            break;
          default: {
            if( c >= '0' && c <= '9'){
              state = WRLexerStateTypeInDIGIT;
            } else if( c == '_' || c >= 'a' && c <= 'z' || c >= 'A' && c <= 'Z'){
              state = WRLexerStateTypeInIDENTIFIER;
            } else {
              [self addErrorWithLength:1 andMessage:@"Unrecognized symbol."];
            }
            break;
          }
        }
        break;
      case WRLexerStateTypeInDIGIT:{
        if(c >= '0' && c <= '9'){
          // keep in digit
        } else{
          [self addTokenWithLength: i - _tokenBegin andType:WRLexerTokenTypeDIGIT];
          state = WRLexerStateTypeBegin;
          i--;
        }
        break;
      }
      case WRLexerStateTypeInIDENTIFIER:{
        if( c == '_' || c >= 'a' && c <= 'z' || c >= 'A' && c <= 'Z' || c >= '0' && c <= '9'){
          // keep in id
        } else{
          [self addTokenWithLength: i - _tokenBegin andType:WRLexerTokenTypeIDENTIFIER];
          state = WRLexerStateTypeBegin;
          i--;
        }
        break;
      }
      case WRLexerStateTypeInString:{
        switch (c){
          case '\"':{
            _tokenBegin ++;
            [self addTokenWithLength: i - 1 - _tokenBegin andType:WRLexerTokenTypeSTRING];
            state = WRLexerStateTypeBegin;
            break;
          }
          case '\n':{
            _currentLine ++;
            _currentColum = -1;// havent read the next line's first symbol
            [self addErrorWithLength:1 andMessage:@"String leteral should be write in one line."];
            break;
          }
          default:{
            // keep in string
            break;
          }
        }
        break;
      }
      case WRLexerStateTypeInComment:{
        switch (c) {
          case '\n':
            _currentLine ++;
            _currentColum = -1;// havent read the next line's first symbol
            state = WRLexerStateTypeBegin;
            break;
            
          default:
            // keep in comment
            break;
        }
        break;
      }
      default:
        break;
    }
  }
}

- (void)addTokenWithLength:(int) length andType:(WRLexerTokenType)type{
  WRTokenContentInfo contentInfo = {_currentLine, _currentColum, length};
  WRToken *token = [[WRToken alloc]init];
  token.type = terminal;
  
  NSString *value = [self.inputStr substringWithRange:NSMakeRange(_tokenBegin, length)];
  token.contentInfo = contentInfo;
  
  switch (type) {
    case WRLexerTokenTypeSTRING:
      
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
      break;
    case WRLexerTokenTypeDIGIT:
      token.symbol = @"digit";
      token.value = value;
      break;
    case WRLexerTokenTypePLUS:
    case WRLexerTokenTypeMINUS:
    case WRLexerTokenTypeMULT:
    case WRLexerTokenTypeDIV:
    case WRLexerTokenTypeMOD:
    case WRLexerTokenTypeEQ:
    case WRLexerTokenTypeNEQ:
    case WRLexerTokenTypeGT:
    case WRLexerTokenTypeGTE:
    case WRLexerTokenTypeLT:
    case WRLexerTokenTypeLTE:
      token.symbol = value;
    default:
      break;
  }
  [self.tokenArray addObject:token];
}

- (void)addErrorWithLength:(int) length andMessage:(NSString *)message{
  WRTokenContentInfo contentInfo = {_currentLine, _currentColum, length};
  
  NSString *errorInfo = [NSString stringWithFormat:@"Line:%d Colum:%d, %@"
                         ,_currentLine
                         ,_currentColum
                         ,message];
  NSError *error = [NSError errorWithDomain:nil code:0 userInfo:@{@"message":errorInfo}];
  
  [self.errorArray addObject:error];
}

- (WRToken *)nextToken{
  return nil;
}

@end
