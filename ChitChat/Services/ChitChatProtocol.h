#ifndef ChitChatProtocol_h
#define ChitChatProtocol_h

#import "Messages.h"
#import <AFNetworking/AFNetworking.h>

typedef void (^WSFinishedBlockWithDictionary)(NSDictionary  * _Nullable responseDictionary, NSError * _Nullable error);
typedef void (^WSFinishedBlockWithMessages)(_Nullable id<Messages> response, NSError * _Nullable error);
typedef void (^WSFinishedBlockWithImage)( UIImage* _Nullable  responseImage, NSError* _Nullable error);
typedef void (^WSFinishedBlockWithMessage)(_Nullable id<Message> message);

@protocol ChitChatProtocol
@property (nonnull, nonatomic, strong) AFHTTPSessionManager* client;
@property (nullable, nonatomic, strong, readonly) NSString* session;
@property (nullable, nonatomic, copy) WSFinishedBlockWithMessage messageReceived;

- (void) removeSession;
- (void) storeSession:(nonnull NSString*) session;

- (void) loginWithUserName:(NSString* _Nonnull ) username success:(_Nonnull dispatch_block_t) success failure:(nonnull void (^)( NSError * _Nonnull error)) failure;
- (void) fetchMessagesWithCompletionBlock:(nonnull WSFinishedBlockWithMessages) block;

- (void) fetchMessagesDictionaryWithCompletionBlock:(nonnull WSFinishedBlockWithDictionary) block;
- (void) fetchMessageDictionaryWithUrl:(NSURL* _Nonnull) url
                      params:(NSDictionary* _Nullable) params
             completionBlock:(nonnull WSFinishedBlockWithDictionary)block;

-(void) fetchUserImageForMessage:(nonnull id<Message>)message completionBlock:(nonnull WSFinishedBlockWithImage)block;

- (void) sendMessage:(NSString* _Nonnull ) message success:(_Nonnull dispatch_block_t) success failure:(nonnull void (^)( NSError * _Nonnull error)) failure;

@end

#endif /* ChitChatProtocol_h */
