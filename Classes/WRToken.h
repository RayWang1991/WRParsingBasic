#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, WRTokenType){
  terminal,
  nonTerminal
};

@interface WRToken : NSObject
@property(nonatomic, assign, readwrite) WRTokenType type;
@property(nonatomic, strong, readwrite) NSString *symbol;

- (BOOL)isMatchWith:(WRToken *)token;

+ (WRToken *)tokenWithType:(WRTokenType)type andSymbol:(NSString *)symbol;

@end
