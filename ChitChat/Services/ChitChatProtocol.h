#ifndef ChitChatProtocol_h
#define ChitChatProtocol_h

#import "Messages.h"
#import <AFNetworking/AFNetworking.h>

typedef void (^WSFinishedBlockWithDictionary)(NSDictionary  * _Nullable responseDictionary, NSError * _Nullable error);
typedef void (^WSFinishedBlockWithMessages)(_Nullable id<Messages> response, NSError * _Nullable error);

@protocol ChitChatProtocol
@property (nonnull, nonatomic, strong) AFHTTPSessionManager* client;
@property (nullable, nonatomic, strong, readonly) NSString* session;

-(void) loginWithUserName:(NSString* _Nonnull ) username success:(_Nonnull dispatch_block_t) success failure:(nonnull void (^)( NSError * _Nonnull error)) failure;
- (void) fetchMessagesWithCompletionBlock:(nonnull WSFinishedBlockWithMessages) block;

- (void) fetchMessagesDictionaryWithCompletionBlock:(nullable WSFinishedBlockWithDictionary) block;
- (void) fetchMessageDictionaryWithUrl:(NSURL* _Nonnull) url
                      params:(NSDictionary* _Nullable) params
             completionBlock:(nonnull WSFinishedBlockWithDictionary)block;

@end

#endif /* ChitChatProtocol_h */
