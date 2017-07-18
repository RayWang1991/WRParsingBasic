/**
 * Copyright (c) 2017, Ray Wang
 * All rights reserved
 * Author: RayWang
 */

#import "WRLanguageCF_EAC_3_4_RR.h"

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

  // TODO recode in a clean way
  if (!token) {
    return nil;
  }
  // for terminal
  if (token.type == terminal) {
    WRAST *ast = [[WRAST alloc] initWithWRTerminal:(WRTerminal *) token];
    return ast;
  }
  WRNonterminal *nonterminal = (WRNonterminal *) token;
  NSArray <WRToken *> *children = nonterminal.children;
  // for nonterminal
  switch (children.count) {
    case 0: {
      // Expr' | Term' -> epsilon
      return nil;
    }
    case 1: {
      // Goal -> Expr, Factor -> num, Factor -> name
      return [self astNodeForToken:children[0]];
    }
    case 2: {
      // Expr -> Term Expr'
      // Term -> Factor Term'
      WRAST *right = [self astNodeForToken:children[1]];
      WRAST *left = [self astNodeForToken:children[0]];
      if (left && right) {
        [right.children insertObject:left
                             atIndex:0];
        return right;
      }
      return left;
    }
    case 3: {

      // Factor -> ( Expr )
      if ([nonterminal.symbol isEqualToString:@"Factor"]) {
        return [self astNodeForToken:children[1]];
      } else {
        // Expr' -> + / - Term Expr'
        // Term' -> x / ÷ Factor Term'
        WRAST *binaryOp = [self astNodeForToken:children[0]];
        WRAST *left = [self astNodeForToken:children[1]];
        WRAST *right = [self astNodeForToken:children[2]];
        if (left) {
          [binaryOp.children addObject:left];
        }
        if (right) {
          [binaryOp.children addObject:right];
        }
        return binaryOp;
      }
    }
    default:return nil;
  }
  return nil;
}
@end

@interface WRLanguageCF_EAC_3_4_RR_ASTBuilder ()
@property (nonatomic, strong, readwrite) WRToken *startToken;
@property (nonatomic, strong, readwrite) WRLanguage *language;
@end

@implementation WRLanguageCF_EAC_3_4_RR_ASTBuilder
- (instancetype)initWithStartToken:(WRToken *)startToken
                       andLanguage:(WRLanguage *)language {
  if (self = [super init]) {
    _startToken = startToken;
    _language = language;
  }
  return self;
}

- (WRAST *)ast {
  return self.startToken.synAttr;
}

- (void)visit:(WRToken<WRVisiteeProtocol> *)token
 withChildren:(NSArray<WRToken<WRVisiteeProtocol> *> *)children {

  if (token == nil) {
    return;
  }
  if (token.type == terminal) {
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
        WRToken *ExprNode = children[0];
        [ExprNode accept:self];
        nonterminal.synAttr = ExprNode.synAttr;
        break;
      }
      case 1: {
        // Expr, 1 rule, Expr -> Term Expr'
        WRToken *Term = children[0];
        WRToken *Expr_ = children[1];
        [Term accept:self];
        Expr_.inhAttr = Term.synAttr;
        [Expr_ accept:self];
        nonterminal.synAttr = Expr_.synAttr;
        break;
      }
      case 2: {
        // Expr'
        switch (nonterminal.ruleIndex) {
          case 0:
          case 1: {
            // Expr' -> + Term Expr'| - Term Expr'
            WRTerminal *op = children[0];
            WRToken *Term = children[1];
            WRToken *Expr_ = children[2];
            
            [Term accept:self];
            
            WRAST *ast = [[WRAST alloc] initWithWRTerminal:op];

            [ast.children addObject:nonterminal.inhAttr];
            [ast.children addObject:Term.synAttr];
            Expr_.inhAttr = ast;
            [Expr_ accept:self];
            nonterminal.synAttr = Expr_.synAttr;
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
        WRToken *Factor = children[0];
        WRToken *Term_ = children[1];
        [Factor accept:self];
        Term_.inhAttr = Factor.synAttr;
        [Term_ accept:self];
        nonterminal.synAttr = Term_.synAttr;
        break;
      }
      case 4: {
        // Term'
        switch (nonterminal.ruleIndex) {
          case 0:
          case 1: {
            // Term' -> × Factor Term'| ÷ Factor Term'
            WRTerminal *op = children[0];
            WRToken *Factor = children[1];
            WRToken *Term_ = children[2];
            
            [Factor accept:self];
            WRAST *ast = [[WRAST alloc] initWithWRTerminal:op];

            [ast.children addObject:nonterminal.inhAttr];
            [ast.children addObject:Factor.synAttr];
            
            Term_.inhAttr = ast;
            [Term_ accept:self];
            nonterminal.synAttr = Term_.synAttr;
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
            WRToken *Expr = children[1];
            [Expr accept:self];
            nonterminal.synAttr = Expr.synAttr;
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
