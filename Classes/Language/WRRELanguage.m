/* Regular engine use
 * test
 * Author: Ray Wang
 * Date: 2017.7.3
 */

#import "WRRELanguage.h"

NSString *const WRRELanguageVirtualConcatenate = @"cat";

@interface WRRELanguageRE_BASIC_1_ASTBuilder : WRASTBuilder
@end

@implementation WRRELanguage

+ (WRLanguage *)CFGrammar_RE_Basic0 {
  return [[super alloc] initWithRuleStrings:@[@"MidOp -> o | a | ",
      @"PostOp -> + | *",
      @"Chars -> Chars c | c",
      @"Ranges -> Ranges c - c | c - c",
      @"CharRange -> [ Chars ] | [ Chars Ranges ] | [ Ranges ] | [ Ranges Chars ]",
      @"Fragment -> c | CharRange | ( Fragment ) | Fragment PostOp | Fragment MidOp Fragment",
      @"S -> Fragment"]
                             andStartSymbol:@"S"];
}

+ (WRLanguage *)CFGrammar_RE_Basic1 {
  WRLanguage *language = [[super alloc]
    initWithRuleStrings:@[
      @"S -> Frag",
      @"Frag -> Frag or Seq | Seq ", //TODO here the '|' is used,  we can use '\|' instead
      @"Seq -> Seq Unit | Unit ",
      @"Unit -> char | char PostOp | ( Frag )",
      @"PostOp -> + | * | ? ",
    ]
         andStartSymbol:@"S"];
  [language addVirtualTerminal:WRRELanguageVirtualConcatenate];
  return language;
}

- (WRAST *)astNodeForToken:(WRToken *)token {
  WRRELanguageRE_BASIC_1_ASTBuilder *builder =
    [[WRRELanguageRE_BASIC_1_ASTBuilder alloc] initWithStartToken:token
                                                      andLanguage:self];
  [token accept:builder];
  return builder.ast;
}
@end

@implementation WRRELanguageRE_BASIC_1_ASTBuilder

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
        // S -> Frag
        WRToken *frag = children[0];
        [frag accept:self];
        nonterminal.synAttr = frag.synAttr;
        break;
      }
      case 1: {
        switch (nonterminal.ruleIndex) {
          // Frag
          case 0: {
            // Frag -> Frag or Seq
            WRToken *frag = children[0];
            WRToken *or = children[1];
            WRToken *seq = children[2];
            [frag accept:self];
            [seq accept:self];
            WRAST *ast = [[WRAST alloc] initWithWRTerminal:or];
            [ast addChild:frag.synAttr];
            [ast addChild:seq.synAttr];
            nonterminal.synAttr = ast;
            break;
          }
          case 1: {
            // Frag -> Seq
            WRToken *seq = children[0];
            [seq accept:self];
            nonterminal.synAttr = seq.synAttr;
            break;
          }
          default:assert(NO);
        }
        break;
      }
      case 2: {
        // Seq
        switch (nonterminal.ruleIndex) {
          case 0: {
            // Seq -> Seq Unit
            WRToken *seq = children[0];
            WRToken *unit = children[1];
            WRTerminal *cat = [WRTerminal tokenWithSymbol:WRRELanguageVirtualConcatenate];
            [seq accept:self];
            [unit accept:self];
            WRAST *ast = [[WRAST alloc] initWithWRTerminal:cat];
            [ast addChild:seq.synAttr];
            [ast addChild:unit.synAttr];
            nonterminal.synAttr = ast;
            break;
          }
          case 1: {
            // Seq -> Unit
            WRToken *unit = children[0];
            [unit accept:self];
            nonterminal.synAttr = unit.synAttr;
            break;
          }
          default:assert(NO);
        }
        break;
      }
      case 3: {
        // Unit
        switch (nonterminal.ruleIndex) {
          case 0: {
            // Unit -> char
            nonterminal.synAttr = [[WRAST alloc] initWithWRTerminal:children[0]];
            break;
          }
          case 1: {
            // Unit -> char PostOp
            WRTerminal *char1 = children[0];
            WRToken *postOp = children[1];
            [postOp accept:self];
            WRAST *ast = [[WRAST alloc] initWithWRTerminal:postOp.synAttr];
            [ast addChild:[[WRAST alloc] initWithWRTerminal:char1]];
            nonterminal.synAttr = ast;
            break;
          }
          case 2: {
            // Unit -> ( Frag )
            WRToken *frag = children[1];
            [frag accept:self];
            nonterminal.synAttr = frag.synAttr;
            break;
          }
          default:assert(NO);
        }
        break;
      }
      case 4: {
        // PostOp -> + | * | ?
        WRTerminal *op = children[0];
        WRAST *ast = [[WRAST alloc] initWithWRTerminal:op];
        nonterminal.synAttr = ast;
        break;
      }
      default: {
        assert(NO);
      }
    }
  }
}

@end
