/**
 * Copyright (c) 2017, Ray Wang
 * All rights reserved
 * Author: RayWang
 */

#import "WRLanguageCF_EAC_3_4_RR.h"
#import "WRASTBuilder.h"

@interface WRLanguageCF_EAC_3_4_RR_ASTBuilder : WRASTBuilder
@end

@implementation WRLanguageCF_EAC_3_4_RR
- (instancetype)init {
  return [super initWithRuleStrings:@[
      @"Goal -> Expr",
      @"Expr -> Term Expr'",
      @"Expr' -> + Term Expr'| - Term Expr' | ",
      @"Term -> Factor Term'",
      @"Term' -> × Factor Term'| ÷ Factor Term' | ",
      @"Factor -> ( Expr )| num | name"]
                     andStartSymbol:@"Goal"];
}

- (WRAST *)astNodeForToken:(WRToken *)token {
  WRLanguageCF_EAC_3_4_RR_ASTBuilder *builder =
    [[WRLanguageCF_EAC_3_4_RR_ASTBuilder alloc] initWithStartToken:token
                                                       andLanguage:self];
  [token accept:builder];
  return builder.ast;
}
@end

@implementation WRLanguageCF_EAC_3_4_RR_ASTBuilder

- (WRAST *)ast {
  return self.startToken.synAttr;
}

- (void)visit:(WRToken<WRVisiteeProtocol> *)token
 withChildren:(NSArray<WRToken<WRVisiteeProtocol> *> *)children {

  if (token == nil) {
    return;
  }
  if (token.type == WRTokenTypeTerminal) {
    // terminal
    // TODO
    assert(NO);
  } else {
    // nonterminal
    WRNonterminal *nonterminal = (WRNonterminal *) token;

    NSInteger tokenIndex = self.language.token2IdMapper[nonterminal.symbol].integerValue;
    switch (tokenIndex) {
      case 0: {
        // Goal, 1 rule, Goal -> Expr
        WRToken *expr = children[0];
        [expr accept:self];
        nonterminal.synAttr = expr.synAttr;
        break;
      }
      case 1: {
        // Expr, 1 rule, Expr -> Term Expr'
        WRToken *term = children[0];
        WRToken *expr_ = children[1];
        [term accept:self];
        expr_.inhAttr = term.synAttr;
        [expr_ accept:self];
        nonterminal.synAttr = expr_.synAttr;
        break;
      }
      case 2: {
        // Expr'
        switch (nonterminal.ruleIndex) {
          case 0:
          case 1: {
            // Expr' -> + Term Expr'| - Term Expr'
            WRTerminal *op = children[0];
            WRToken *term = children[1];
            WRToken *expr_ = children[2];

            [term accept:self];

            WRAST *ast = [[WRAST alloc] initWithWRTerminal:op];

            [ast.children addObject:nonterminal.inhAttr];
            [ast.children addObject:term.synAttr];
            expr_.inhAttr = ast;
            [expr_ accept:self];
            nonterminal.synAttr = expr_.synAttr;
            break;
          }
          default:
            // epsilon
            nonterminal.synAttr = nonterminal.inhAttr;
            break;
        }
        break;
      }
      case 3: {
        // Term, 1 rule, Term -> Factor Term'
        WRToken *factor = children[0];
        WRToken *term_ = children[1];
        [factor accept:self];
        term_.inhAttr = factor.synAttr;
        [term_ accept:self];
        nonterminal.synAttr = term_.synAttr;
        break;
      }
      case 4: {
        // Term'
        switch (nonterminal.ruleIndex) {
          case 0:
          case 1: {
            // Term' -> × Factor Term'| ÷ Factor Term'
            WRTerminal *op = children[0];
            WRToken *factor = children[1];
            WRToken *term_ = children[2];

            [factor accept:self];
            WRAST *ast = [[WRAST alloc] initWithWRTerminal:op];

            [ast.children addObject:nonterminal.inhAttr];
            [ast.children addObject:factor.synAttr];

            term_.inhAttr = ast;
            [term_ accept:self];
            nonterminal.synAttr = term_.synAttr;
            break;
          }
          default: {
            // epsilon
            nonterminal.synAttr = nonterminal.inhAttr;
            break;
          }
        }

        break;
      }
      case 5: {
        // Factor
        switch (nonterminal.ruleIndex) {
          case 0: {
            // Factor -> ( Expr )
            WRToken *expr = children[1];
            [expr accept:self];
            nonterminal.synAttr = expr.synAttr;
            break;
          }
          default: {
            // Factor -> | num | name
            WRTerminal *lex = children[0];
            WRAST *ast = [[WRAST alloc] initWithWRTerminal:lex];
            nonterminal.synAttr = ast;
            break;
          }
        }
        break;
      }
      default: {
        assert(NO);
      }
    }
  }
}

@end
