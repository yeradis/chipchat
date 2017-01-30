#import "ChitChat.h"

NSString *const kSessionKey = @"session";
NSString *const kWS_BaseURL = @"https://s3-eu-west-1.amazonaws.com/rocket-interview/chat.json";

@interface ChitChat ()
@end

@implementation ChitChat
@synthesize session = _session;
@synthesize client = _client;
@synthesize messageReceived;
@synthesize reservedNames;

-(id) init {
    self = [super init];
    if (self) {
        _client = [AFHTTPSessionManager manager];
        [self buildReservedUserNameList];
    }
    return self;
}

-(NSString*) session {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kSessionKey];
}

-(void) removeSession {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kSessionKey];
}

-(void) storeSession:(NSString*) session {
    if (session) {
        [[NSUserDefaults standardUserDefaults] setObject:session forKey:kSessionKey];
    }
}

-(void) notifyMessage:(id<Message>) message {
    if (self.messageReceived && message) {
        self.messageReceived(message);
    }
}

-(void) sendMessage:(NSString *)message success:(dispatch_block_t)success
            failure:(void (^)(NSError * _Nonnull))failure {
    if ([self isValidParam:message]) {

        [self notifyMessage:[Message messageWithCurrentSession:self.session
                                                       message:message]];
        
        if (success) {
            success();
        }
        
    } else {
        if (failure) {
            NSError* error = [NSError errorWithDomain:@"Message can not be nil or empty, Try again" code:666 userInfo:nil];
            failure(error);
        }
    }
}
-(void) loginWithUserName:(NSString *)username
                  success:(dispatch_block_t)success
                  failure:(void (^)(NSError * _Nonnull))failure {
    
    if ([self isValidParam:username] &&
        ![self isExistingUserName:username]){
    
        [self handleLoginSuccess:success userName:username];
        
    } else {
        NSString* errorMessage = @"User name not valid";
        errorMessage = ([self isValidParam:username] &&
                        [self isExistingUserName:username]) ?
        @"Choose another name":errorMessage;
    
        [self handleLoginFailure:failure message:errorMessage];
    }
}

-(void) buildReservedUserNameList {
    self.reservedNames = @[@"Carrie", @"Anthony", @"Eleanor",
                           @"Rodney", @"Oliva", @"Merve", @"Lily"];
    
    [self fetchMessagesWithCompletionBlock:^(id<Messages>  _Nullable response, NSError * _Nullable error) {
        if (response){
            NSMutableArray* currentUsernameList = [[NSMutableArray alloc] init];
            for (id<Message> message in response.messages){
                [currentUsernameList addObject:message.username];
            }
            self.reservedNames = [currentUsernameList mutableCopy];
        }
    }];
}

-(BOOL) isExistingUserName:(NSString*) username {
    BOOL exists = ([[self.reservedNames valueForKey:@"lowercaseString"] containsObject:[username lowercaseString]]);
    return exists;
}

-(BOOL) isValidParam:(NSString*) param {
    return param &&
    [param stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length > 0;
}

-(void) handleLoginSuccess:(dispatch_block_t) success userName:(NSString*) username {
    if (success) {
        [self storeSession:username];
        success();
    }
}

-(void) handleLoginFailure:(void (^)(NSError * _Nonnull)) failure message:(NSString*) message {
    if (failure) {
        [self removeSession];
        NSError* error = [NSError errorWithDomain:message code:666 userInfo:nil];
        failure(error);
    }
}

-(void) fetchMessagesWithCompletionBlock:(WSFinishedBlockWithMessages)block {
    if (block) {
        [self fetchMessagesDictionaryWithCompletionBlock:^(NSDictionary * _Nullable responseDictionary, NSError * _Nullable error) {
            id<Messages> messages = nil;
            if (responseDictionary && [responseDictionary count] > 0) {
                messages = [[Messages alloc] initWithDictionary:responseDictionary];
            } 
            block(messages,error);
        }];
    }
}

-(void) fetchMessagesDictionaryWithCompletionBlock:(WSFinishedBlockWithDictionary)block {
    if (block) {
        NSURL *url = [NSURL URLWithString:kWS_BaseURL];
        [self fetchMessageDictionaryWithUrl:url params:nil completionBlock:^(NSDictionary * _Nullable responseDictionary, NSError * _Nullable error) {
            block(responseDictionary,error);
        }];
    }
}

-(void) fetchMessageDictionaryWithUrl:(NSURL *)url
                               params:(NSDictionary *)params
                      completionBlock:(WSFinishedBlockWithDictionary)block {
    if (block){
        NSLog(@"lets fetch some something from: %@",url.absoluteString);
        if (url == nil) {
            NSError *error = [[NSError alloc] initWithDomain:@"API enpoing url should not be null" code:999 userInfo:nil];
            block(nil,error);
            return;
        }
        
        _client.responseSerializer = [AFJSONResponseSerializer serializer];
        _client.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"text/plain",@"application/json"]];
        [_client GET:url.absoluteString
          parameters:params
            progress:nil
             success:^(NSURLSessionTask *task, id responseObject) {
                 block(responseObject,nil);
             } failure:^(NSURLSessionTask *operation, NSError *error) {
                 block(nil,error);
             }];
        
    }
}

-(void) fetchUserImageForMessage:(id<Message>)message completionBlock:(WSFinishedBlockWithImage)block {
    if (block) {
        if (message == nil) {
            NSError *error = [[NSError alloc] initWithDomain:@"Message can not be nil" code:666 userInfo:nil];
            block(nil,error);
            return;
        }

        /*
         Images are cached on disk using standard NSURLCache built in iOS,
         meaning that if your responses include proper cache headers,
         those items should end up on disk in the cache.
         
         Either the Cache-Control header or the Expires header MUST be in the
         HTTP response header from the server in order for the client to cache it
         */
        NSURL *imageURL = [NSURL URLWithString:message.userImageUrl];
        NSURLRequest *imageRequest = [NSURLRequest requestWithURL:imageURL
                                                      cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                  timeoutInterval:3600];
        
        //Use the image from the image cache if it exists
        UIImage *cachedImage = [UIImage imageWithData:[[AFImageDownloader defaultURLCache] cachedResponseForRequest:imageRequest].data];
        
        if (cachedImage) {
            block(cachedImage, nil);
        } else {
            [[AFImageDownloader defaultInstance] downloadImageForURLRequest:imageRequest
                                                                    success:^(NSURLRequest * _Nonnull request,
                                                                              NSHTTPURLResponse * _Nullable response,
                                                                              UIImage * _Nonnull responseObject) {
                                                                        block(responseObject,nil);
                                                                    } failure:^(NSURLRequest * _Nonnull request,
                                                                                NSHTTPURLResponse * _Nullable response,
                                                                                NSError * _Nonnull error) {
                                                                        block(nil,error);
                                                                    }];
            
        }
    }
}

@end
