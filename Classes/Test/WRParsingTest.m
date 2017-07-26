/**
 * Copyright (c) 2017, Ray Wang
 * All rights reserved
 * Author: RayWang
 */

#import "WRParsingTest.h"

#import "WRRule.h"
#import "WRToken.h"
#import "WRNonterminal.h"
#import "WRTerminal.h"
#import "WRLanguage.h"
#import "WRRELanguage.h"

#import "WRScanner.h"
#import "WRWordScanner.h"
#import "WRLexer.h"

#import "WREarleyParser.h"
#import "WRLR0Parser.h"
#import "WRLR1Parser.h"
#import "WRLL1Parser.h"

#import "WRUtils.h"
#import "WRSPPFNode.h"

@implementation WRParsingTest

+ (void)testWordScanner {
  WRWordScanner *scanner = [[WRWordScanner alloc] init];
  [scanner test];
}

+ (void)testLL1Parser {
  WRLL1Parser *parser = [[WRLL1Parser alloc] init];
  WRWordScanner *scanner = [[WRWordScanner alloc] init];
  WRLanguage *language = [WRLanguage CFGrammar_EAC_3_4_RR];

  scanner.inputStr = @"( name - num ) × ( num ÷ name )";
//  scanner.inputStr = @" name - num ";
//  scanner.inputStr = @" name × num ";
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

+ (void)testEarleyParser {
  WREarleyParser *parser = [[WREarleyParser alloc] init];
  WRWordScanner *scanner = [[WRWordScanner alloc] init];
//    scanner.inputStr = @"abbb";
//    WRLanguage *language = [WRLanguage CFGrammar_SPFER_3];
//  WRLanguage *language = [WRRELanguage CFGrammar_RE_Basic1];
//  WRLanguage *language = [WRRELanguage CFGrammar_EAC_3_4_RR];
//  scanner.inputStr = @"char ( char ? char or char char * ) or char";
//  scanner.inputStr = @"num + ( name ÷ ( name - num ) )";
  WRLanguage *language = [WRLanguage CFGrammar7_19];
  scanner.inputStr = @"x";
  [scanner startScan];
  parser.language = language;
  parser.scanner = scanner;
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

+ (void)testLR0Parser {
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

+ (void)testLR1Parser {
  WRLR1Parser *parser = [[WRLR1Parser alloc] init];
  WRWordScanner *scanner = [[WRWordScanner alloc] init];
  WRLanguage *language = [WRRELanguage CFGrammar_RE_Basic1];
  scanner.inputStr = @"char ( char or char )";
//  WRLanguage *language = [WRRELanguage CFGrammar7_19];
//  scanner.inputStr = @"x";
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
  WRAST *ast = [language astNodeForToken:parser.parseTree];
  [hdPrinter reset];
  [lispPrinter reset];
  [ast accept:hdPrinter];
  [ast accept:lispPrinter];
  [hdPrinter print];
  [lispPrinter print];
}

+ (void)testLexer {
  WRLexer *lexer = [[WRLexer alloc] init];
  [lexer test];
};

+ (void)testString {
  NSString *tabString = [WRUtils debugStrWithTabs:6
                                        forString:@"1\n2\n3\n"];
  printf("%s", tabString.UTF8String);
  NSString *strss = @"S S S";
  NSRange range0 = NSMakeRange(0, 1);
  NSRange range1 = NSMakeRange(2, 1);
  NSRange range2 = NSMakeRange(4, 1);
  NSString *s0 = [strss substringWithRange:range0];
  NSString *s1 = [strss substringWithRange:range1];
  NSString *s2 = [strss substringWithRange:range2];
  assert(s0 == s1 && s1 == s2);

}

+ (void)testSPPNode {
  WRToken *token1 = [WRToken tokenWithSymbol:@"token"];
  WRToken *token2 = [WRToken tokenWithSymbol:@"token"];
  WRItem *item1 = [WRItem itemWithRuleStr:@"S ->a b"
                              dotPosition:0
                           askingPosition:3];
  WRItem *item2 = [WRItem itemWithRuleStr:@"S-> a b"
                              dotPosition:0
                           askingPosition:3];
  WRSPPFNode *v1 = [WRSPPFNode SPPFNodeWithContent:token1
                                        leftExtent:3
                                    andRightExtent:4];
  WRSPPFNode *v2 = [WRSPPFNode SPPFNodeWithContent:item1
                                        leftExtent:0
                                    andRightExtent:3];
  WRSPPFNode *w1 = [WRSPPFNode SPPFNodeWithContent:token2
                                        leftExtent:3
                                    andRightExtent:4];
  WRSPPFNode *w2 = [WRSPPFNode SPPFNodeWithContent:item2
                                        leftExtent:0
                                    andRightExtent:3];
  WRToken *startToken = [WRToken tokenWithSymbol:@"S"];
  WRSPPFNode *root = [WRSPPFNode SPPFNodeWithContent:startToken
                                          leftExtent:0
                                      andRightExtent:4];
  [root.families addObject:@[v1, v2]];

  BOOL res1 = [root containsFamilly:@[w1, w2]];
  BOOL res2 = [root containsFamilly:@[w2, w1]];
  BOOL res3 = [root containsFamilly:@[w1]];
  BOOL res4 = [root containsFamilly:@[w1, w1, w2]];
  assert(res1);
  assert(res2);
  assert(!res3);
  assert(!res4);
}

+ (void)testSet {
  WRItem *item1 = [WRItem itemWithRuleStr:@"S -> A B C"
                              dotPosition:0
                           askingPosition:0];
  WRItem *item2 = [WRItem itemWithRuleStr:@"S -> A B C"
                              dotPosition:0
                           askingPosition:0];

  NSMutableDictionary *set = [NSMutableDictionary dictionary];
  [set setValue:item1
         forKey:item1.description];
  assert(set[item1.description] != nil);
  assert(set[item2.description] != nil);
  assert(item1 != item2);
}

+ (void)tokenTest {
  NSString *A = @"A";
  NSString *a = @"a";
  WRToken *tokenA1 = [[WRToken alloc] initWithSymbol:A];
  WRToken *tokenA2 = [WRToken tokenWithSymbol:A];
  WRToken *tokena1 = [[WRToken alloc] initWithSymbol:a];
  WRToken *tokena2 = [WRToken tokenWithSymbol:a];

  assert([tokenA1.symbol isEqualToString:A]);
  assert(tokenA1.type == WRTokenTypeNonterminal);
  assert([tokenA2.symbol isEqualToString:A]);
  assert(tokenA2.type == WRTokenTypeNonterminal);
  assert([tokena1.symbol isEqualToString:a]);
  assert(tokena1.type == WRTokenTypeTerminal);
  assert([tokena2.symbol isEqualToString:a]);
  assert(tokena2.type == WRTokenTypeTerminal);
}

+ (void)testRule {
  WRRule *rule1 = [WRRule ruleWithRuleStr:@"S  -> A B C   "];
  assert([rule1.leftToken isEqualToString:@"S"]);
  NSArray <NSString *> *rightTokens = rule1.rightTokens;
  assert([rightTokens[0] isEqualToString:@"A"]);
  assert([rightTokens[1] isEqualToString:@"B"]);
  assert([rightTokens[2] isEqualToString:@"C"]);

  rule1 = [WRRule ruleWithRuleStr:@"S->   "];
  assert([rule1.leftToken isEqualToString:@"S"]);
  rightTokens = rule1.rightTokens;
  assert(rightTokens.count == 0);
}

+ (void)testLanguage {
  WRLanguage *language = [[WRLanguage alloc] initWithRuleStrings:@[@"S -> A a",
      @"S ->A B C",
      @"D -> d",
      @"E -> S A B",
      @"A ->a",
      @"A ->",
      @"B ->C A",
      @"B->b",
      @"C->",
      @"C->c"]
                                                  andStartSymbol:@"S"];

  assert([language isTokenNullable:@"S"]);
  assert([language isTokenNullable:@"A"]);
  assert([language isTokenNullable:@"B"]);
  assert([language isTokenNullable:@"C"]);
  assert(![language isTokenNullable:@"D"]);
  assert([language isTokenNullable:@"E"]);
  assert(![language isTokenNullable:@"a"]);
  assert(![language isTokenNullable:@"b"]);
  assert(![language isTokenNullable:@"c"]);
  assert(![language isTokenNullable:@"d"]);
}

+ (void)testTreePattern {
  WRTreePattern *pattern = [WRTreePattern treePatternWithString:@"( abc def ghi )"];
  assert(pattern.actions.count == 5);
  assert(pattern.actions[0].type == WRTreePatternMatchActionMatch);
  assert(pattern.actions[1].type == WRTreePatternMatchActionGoDown);
  assert(pattern.actions[2].type == WRTreePatternMatchActionMatch);
  assert(pattern.actions[3].type == WRTreePatternMatchActionMatch);
  assert(pattern.actions[4].type == WRTreePatternMatchActionGoUp);
  assert([((WRTreePatternMatchAction *) pattern.actions[0]).symbol isEqualToString:@"abc"]);
  assert([((WRTreePatternMatchAction *) pattern.actions[2]).symbol isEqualToString:@"def"]);
  assert([((WRTreePatternMatchAction *) pattern.actions[3]).symbol isEqualToString:@"ghi"]);

  pattern = [WRTreePattern treePatternWithString:@"(abc def ghi)"];
  assert(pattern.actions.count == 5);
  assert(pattern.actions[0].type == WRTreePatternMatchActionMatch);
  assert(pattern.actions[1].type == WRTreePatternMatchActionGoDown);
  assert(pattern.actions[2].type == WRTreePatternMatchActionMatch);
  assert(pattern.actions[3].type == WRTreePatternMatchActionMatch);
  assert(pattern.actions[4].type == WRTreePatternMatchActionGoUp);
  assert([((WRTreePatternMatchAction *) pattern.actions[0]).symbol isEqualToString:@"abc"]);
  assert([((WRTreePatternMatchAction *) pattern.actions[2]).symbol isEqualToString:@"def"]);
  assert([((WRTreePatternMatchAction *) pattern.actions[3]).symbol isEqualToString:@"ghi"]);

  pattern = [WRTreePattern treePatternWithString:@"(\\(abc\\) \\(def ghi\\))"];
  assert(pattern.actions.count == 5);
  assert(pattern.actions[0].type == WRTreePatternMatchActionMatch);
  assert(pattern.actions[1].type == WRTreePatternMatchActionGoDown);
  assert(pattern.actions[2].type == WRTreePatternMatchActionMatch);
  assert(pattern.actions[3].type == WRTreePatternMatchActionMatch);
  assert(pattern.actions[4].type == WRTreePatternMatchActionGoUp);
  assert([((WRTreePatternMatchAction *) pattern.actions[0]).symbol isEqualToString:@"(abc)"]);
  assert([((WRTreePatternMatchAction *) pattern.actions[2]).symbol isEqualToString:@"(def"]);
  assert([((WRTreePatternMatchAction *) pattern.actions[3]).symbol isEqualToString:@"ghi)"]);
}

+ (void)test {
  [self testLanguage];
}

@end