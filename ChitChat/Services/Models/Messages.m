#import "Messages.h"

NSString* const kItemUserName      = @"username";
NSString* const kItemContent       = @"content";
NSString* const kItemUserImageUrl  = @"userImage_url";
NSString* const kItemTime          = @"time";
NSString* const kItemChats         = @"chats";

@implementation Messages

@synthesize messages;

-(id) initWithDictionary:(NSDictionary *) dictionary {
    self = [super init];
    if (self) {
        [self parseDictionary:dictionary];
    }
    return self;
}

-(void) parseDictionary:(NSDictionary*) dic {
    
    if (dic == nil ||
        [dic isKindOfClass:[NSDictionary class]] == NO ||
        [dic count] == 0 ||
        ![Messages isValidMessagesDictionary:dic])
    {
        @throw [NSException exceptionWithName:@"Wrong dictionary" reason:@"Dictionary is not valid" userInfo:nil];
    }
    
    NSMutableArray<Message> *messages = [[NSMutableArray<Message> alloc] init];
    for (NSDictionary* messageDic in dic[kItemChats]){
        Message* message = [[Message alloc] initWithDictionary:messageDic];
        [messages addObject:message];
    }
    
    self.messages =[messages copy];
}

+ (BOOL) isValidMessagesDictionary:(NSDictionary *)dictionary {
    //this should be restrictive, like not allowing empty chat list
    return dictionary[kItemChats];
}

@end

@implementation Message

@synthesize username,userImageUrl,content,time, messageId;

-(id) initWithDictionary:(NSDictionary *) dictionary {
    self = [super init];
    if (self) {
        messageId = [NSUUID UUID];
        [self parseDictionary:dictionary];
    }
    return self;
}

-(void) parseDictionary:(NSDictionary*) dic {
    
    if (dic == nil ||
        [dic isKindOfClass:[NSDictionary class]] == NO ||
        [dic count] == 0 ||
        ![Message isValidMessageDictionary:dic])
    {
        @throw [NSException exceptionWithName:@"Wrong dictionary" reason:@"Dictionary is not valid" userInfo:nil];
    }
    
    self.username = dic[kItemUserName];
    self.content = dic[kItemContent];
    self.userImageUrl = dic[kItemUserImageUrl];
    self.time = dic[kItemTime];
}

+ (BOOL) isValidMessageDictionary:(NSDictionary *)dictionary {
    //this should be more restrictive, like not allowing
    //chats without username and content
    return dictionary[kItemUserName]
           || dictionary[kItemContent]
           || dictionary[kItemUserImageUrl]
           || dictionary[kItemTime];
}

+(id) messageWithCurrentSession:(NSString *)session message:(NSString *)message {
    if (![self isValidParamValue:session] || ![self isValidParamValue:message])
    {
        return nil;
    }
    
    id<Message> msg = [[Message alloc] init];
    msg.content     =  message;
    msg.username    = session;
    NSDate* date    = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSString *time = [formatter stringFromDate:date];
    msg.time = time;
    
    return msg;
}

+(BOOL) isValidParamValue:(NSString*) value {
    return value && [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length > 0;
}

@end
