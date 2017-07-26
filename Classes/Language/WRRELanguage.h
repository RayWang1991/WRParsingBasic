/* Regular engine use
 * test use
 * Author: Ray Wang
 * Date: 2017.7.3
 */

#import "WRParsingBasicLib.h"

extern NSString *const WRRELanguageVirtualConcatenate;

@interface WRRELanguage : WRLanguage

+ (WRLanguage *)CFGrammar_RE_Basic0; // Left Recursive

+ (WRLanguage *)CFGrammar_RE_Basic1; // Left Recursive

@end
