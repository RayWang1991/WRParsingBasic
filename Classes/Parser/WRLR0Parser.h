/* LR(0) Parser Generator
 * Ref: 'Parsing Techniques' Chap 9.5
 * Author: Ray Wang
 * Date: 2017.6.30
 */

#import "WRParsingBasiclib.h"

extern NSString *const kWRLR0ParserErrorDomain;

typedef NS_ENUM(NSInteger, WRLR0NFAStateType) {
  WRLR0NFAStateTypeToken,
  WRLR0NFAStateTypeItem,
};

@class WRLR0NFATransition;

// NFA State
@interface WRLR0NFAState : NSObject
@property (nonatomic, assign, readwrite) WRLR0NFAStateType type;
@property (nonatomic, strong, readwrite) NSString *symbol;
@property (nonatomic, strong, readwrite) id content;
@property (nonatomic, strong, readwrite) NSMutableArray <WRLR0NFATransition *> *transitionList;

+ (instancetype)NFAStateWithSymbol:(NSString *)symbol
                              type:(WRLR0NFAStateType)type
                        andContent:(id)content;

+ (instancetype)NFAStateWithContent:(id)content;

- (void)addTransition:(WRLR0NFATransition *)transition;

@end

// NFA Transition
typedef NS_ENUM(NSInteger, WRLR0NFATransitionType) {
  WRLR0NFATransitionTypeEpsilon,
  WRLR0NFATransitionTypeNormal,
};
@interface WRLR0NFATransition : NSObject<NSObject>

@property (nonatomic, assign, readwrite) WRLR0NFATransitionType type;
@property (nonatomic, unsafe_unretained, readwrite) WRLR0NFAState *from;
@property (nonatomic, strong, readwrite) WRLR0NFAState *to;
@property (nonatomic, strong, readwrite) NSString *consumption;

+ (instancetype)NFATransitionWithFromState:(WRLR0NFAState *)from
                                   toState:(WRLR0NFAState *)to
                            andConsumption:(NSString *)consumption;

@end

typedef NS_ENUM(NSInteger, WRLR0DFAActionType) {
  WRLR0DFAActionTypeReduce,
  WRLR0DFAActionTypeShift,
};

@interface WRLR0DFAState : NSObject<NSObject>

@property (nonatomic, assign, readwrite) NSInteger stateId;
@property (nonatomic, assign, readwrite) NSString *contentStr;
@property (nonatomic, strong, readwrite) NSMutableSet<WRLR0NFAState *> *nfaStates;
@property (nonatomic, assign, readwrite) WRLR0DFAActionType actionType;
@property (nonatomic, strong, readwrite) NSString *reduceTokenSymbol;
@property (nonatomic, assign, readwrite) NSInteger reduceRuleIndex;
@property (nonatomic, strong, readwrite) NSMutableDictionary<NSString *, WRLR0DFAState *> *transitionDict;

- (instancetype)initWithNFAStates:(NSMutableSet<WRLR0NFAState *> *)nfaStates;
+ (instancetype)DFAStateWithNFAStates:(NSMutableSet <WRLR0NFAState *> *)nfaStates;
// helper methods for DFA construction
+ (NSString *)contentStrForNFAStates:(NSSet <WRLR0NFAState *> *)nfaStates;
@end

// parsing error
typedef NS_ENUM(NSInteger, WRLR0ParsingError) {
  WRLR0ParsingErrorTypeRunOutOfToken,
  WRLR0ParsingErrorTypeUnsupportedTransition,
};

@interface WRLR0Parser : NSObject
@property (nonatomic, strong, readwrite) WRLanguage *language;
@property (nonatomic, strong, readwrite) WRWordScanner *scanner;
@property (nonatomic, strong, readwrite) WRToken *parseTree;

- (void)prepare;
- (void)startParsing;

@end
