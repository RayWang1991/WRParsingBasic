/* LL(1) Parser Generator
 * Ref 'Parsing Techniques' Chap 8.2 'Engineering a Compiler' Chap 3.3
 * Author: Ray Wang
 * Date: 2017.7.9
 */

#import "WRParsingBasicLib.h"

extern NSString *const kWRLL1ParserErrorDomain;
// construction error
typedef NS_ENUM(NSInteger, WRLL1ConflictError) {
  WRLL1ErrorTypeFirstPlusFirstPlusConflict
};
// parsing error
typedef NS_ENUM(NSInteger, WRLL1ParsingError) {
  WRLL1ParsingErrorTypeRunOutOfToken,
  WRLL1ParsingErrorTypeMismatchTokens,
  WRLL1ParsingErrorTypeUnsupportedTransition,
};

@interface WRLL1Parser : NSObject
@property (nonatomic, strong, readwrite) WRLanguage *language;
@property (nonatomic, strong, readwrite) WRWordScanner *scanner;
@property (nonatomic, strong, readwrite) WRNonterminal *parseTree;

- (void)prepare;

- (void)setInputStr:(NSString *)inputStr;

- (void)startParsing;

@end
