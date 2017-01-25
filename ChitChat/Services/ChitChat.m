#import "ChitChat.h"

NSString *const kSessionKey = @"session";
NSString *const kWS_BaseURL = @"https://s3-eu-west-1.amazonaws.com/rocket-interview/chat.json";

@interface ChitChat ()
@end

@implementation ChitChat
@synthesize session = _session;
@synthesize client = _client;

-(id) init {
    self = [super init];
    if (self) {
        _client = [AFHTTPSessionManager manager];
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

-(void) loginWithUserName:(NSString *)username success:(dispatch_block_t)success failure:(void (^)(NSError * _Nonnull))failure {
    if (username && [username stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length > 0){
        if (success) {
            [self storeSession:username];
            success();
        }
    } else {
        if (failure){
            [self removeSession];
            NSError* error = [NSError errorWithDomain:@"User name can not be nil or empty, Try again" code:666 userInfo:nil];
            failure(error);
        }
    }
}

-(void) fetchMessagesWithCompletionBlock:(WSFinishedBlockWithMessages)block {
    if (block) {
        [self fetchMessagesDictionaryWithCompletionBlock:^(NSDictionary * _Nullable responseDictionary, NSError * _Nullable error) {
            id<Messages> messages = nil;
            if (responseDictionary) {
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


@end
