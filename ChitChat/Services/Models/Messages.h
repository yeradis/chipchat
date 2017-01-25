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

-(id) initWithDictionary:(NSDictionary*) dictionary;
+(BOOL) isValidMessageDictionary:(NSDictionary*) dictionary;
@end;

@protocol Messages

@property (strong, nonatomic) NSArray<Message>* messages;
-(id) initWithDictionary:(NSDictionary*) dictionary;
+(BOOL) isValidMessagesDictionary:(NSDictionary*) dictionary;
@end;


@interface Messages : NSObject<Messages>
@end

@interface Message : NSObject<Message>
@end
