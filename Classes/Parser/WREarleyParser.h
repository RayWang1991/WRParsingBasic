/* Earley Parser Generator
 * Ref 'Parsing Techniques' Chap 7.2,
 * Elizabeth Scott, 'SPPF-Style Parsing From Earley Recognisers',
 * Electronic Notes in Theoretical Computer Science 203 (2008) 53–67
 * Author: Ray Wang
 * Date: 2017.6.7
 */

#import <Foundation/Foundation.h>
#import "WRParsingBasiclib.h"

/* Earley Parser */

@interface WRItemSet : NSObject
@property (nonatomic, strong, readwrite) NSMutableArray <WRItem *> *itemList; // work list / item list
@property (nonatomic, strong, readwrite) NSMutableDictionary <NSString *, WRItem *> *completeSet; // complete set
@property (nonatomic, strong, readwrite) NSMutableDictionary <NSString *, WRItem *> *activeSet; // active / predict set
@property (nonatomic, strong, readwrite) NSMutableDictionary <NSString *, NSMutableArray <WRItem *> *> *askingDict;

@end

@interface WREarleyParser : NSObject
@property (nonatomic, strong, readwrite) NSMutableArray <WRItemSet *> *itemSetList;
@property (nonatomic, strong, readwrite) WRLanguage *language;
@property (nonatomic, strong, readwrite) WRWordScanner *scanner;

// SPPF adn parseTree construction
@property (nonatomic, strong, readwrite) NSMutableDictionary <NSString *, WRSPPFNode *> *nodeSet;
@property (nonatomic, strong, readwrite) NSArray <NSMutableDictionary <NSString *, WRItem *> *> *processedSetList;
@property (nonatomic, strong, readwrite) WRSPPFNode *parseForest;
@property (nonatomic, strong, readwrite) WRNonterminal *parseTree;

- (void)startParsing;

- (void)constructSPPF;

- (void)constructParseTree;

@end


