//
//  main.m
//  ParsingDemo
//
//  Created by ray wang on 2018/3/12.
//  Copyright © 2018年 ray wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WRParsingBasicLib.h"

static void testEarley();
static void testLL1();
static void testLR0();
static void testLR1();

int main(int argc, const char * argv[]) {
  @autoreleasepool {
//    testEarley();
//    testLL1();
    testLR0();
  }
  return 0;
}

static void testEarley(){
  WREarleyParser *parser = [[WREarleyParser alloc] init];
  WRWordScanner *scanner = [[WRWordScanner alloc] init];
  WRLanguage *language = [WRLanguage CFGrammar_SPFER_3];
  parser.language = language;
  scanner.inputStr = @"a b b b";
  parser.scanner = scanner;
  [scanner startScan];
  [parser startParsing];
  [parser constructSPPF];
  [parser constructParseTree];
  
  // parse tree
  WRTreeHorizontalDashStylePrinter *hdPrinter = [[WRTreeHorizontalDashStylePrinter alloc] init];
  [parser.parseTree accept:hdPrinter];
  [hdPrinter print];
  
  // ast
  WRAST *ast = [language astNodeForToken:parser.parseTree];
  [hdPrinter reset];
  [ast accept:hdPrinter];
  [hdPrinter print];
}

static void testLL1(){
  WRLL1Parser *parser = [[WRLL1Parser alloc] init];
  WRWordScanner *scanner = [[WRWordScanner alloc] init];
  WRLanguage *language = [WRLanguage CFGrammar_EAC_3_4_RR];
  
  scanner.inputStr = @"( name - num ) × ( num ÷ name )";
  scanner.language = language;
  parser.language = language;
  parser.scanner = scanner;
  [parser prepare];
  [parser startParsing];
  // print parse tree
  WRTreeHorizontalDashStylePrinter *hdPrinter = [[WRTreeHorizontalDashStylePrinter alloc] init];
  WRTreeLispStylePrinter *lispPrinter = [[WRTreeLispStylePrinter alloc] init];
  [parser.parseTree accept:hdPrinter];
  [parser.parseTree accept:lispPrinter];
  [hdPrinter print];
  [lispPrinter print];
  
  // print AST
  WRAST *ast = [language astNodeForToken:parser.parseTree];
  hdPrinter = [[WRTreeHorizontalDashStylePrinter alloc] init];
  [ast accept:hdPrinter];
  [hdPrinter print];
}

static void testLR0() {
  WRLR0Parser *parser = [[WRLR0Parser alloc] init];
  WRWordScanner *scanner = [[WRWordScanner alloc] init];
  WRLanguage *language = [WRLanguage CFGrammar_9_14];
  scanner.inputStr = @"n - n - n $";
  parser.language = language;
  parser.scanner = scanner;
  [parser prepare];
  [parser startParsing];
  
  WRTreeHorizontalDashStylePrinter *hdPrinter = [[WRTreeHorizontalDashStylePrinter alloc] init];
  WRTreeLispStylePrinter *lispPrinter = [[WRTreeLispStylePrinter alloc] init];
  [parser.parseTree accept:hdPrinter];
  [parser.parseTree accept:lispPrinter];
  [hdPrinter print];
  [lispPrinter print];
}
