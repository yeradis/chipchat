#import <Foundation/Foundation.h>

extern NSString* const kItemUserName;
extern NSString* const kItemContent;
extern NSString* const kItemUserImageUrl;
extern NSString* const kItemTime;
extern NSString* const kItemChats;

@protocol Message
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *userImageUrl;
@property (nonatomic, copy) NSString *time;
@property (readonly, nonnull, nonatomic) NSUUID * messageId;


-(nonnull id) initWithDictionary:(nonnull NSDictionary*) dictionary;
+(BOOL) isValidMessageDictionary:(nonnull NSDictionary*) dictionary;
+(nullable id) messageWithCurrentSession:(nonnull NSString*) session message:(nonnull NSString*) message;
@end;

@protocol Messages
@property (strong, nonatomic) NSArray<Message>  * _Nullable messages;
-(nullable id) initWithDictionary:(nonnull NSDictionary*) dictionary;
+(BOOL) isValidMessagesDictionary:(nullable NSDictionary*) dictionary;
@end;


@interface Messages : NSObject<Messages>
@end

@interface Message : NSObject<Message>
@end
