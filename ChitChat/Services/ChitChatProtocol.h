#ifndef ChitChatProtocol_h
#define ChitChatProtocol_h

@protocol ChitChatProtocol
@property (nullable, nonatomic, strong, readonly) NSString* session;

-(void) loginWithUserName:(NSString* _Nonnull ) username success:(_Nonnull dispatch_block_t) success failure:(nonnull void (^)( NSError * _Nonnull error)) failure;

@end

#endif /* ChitChatProtocol_h */
