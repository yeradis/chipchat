#import "ChitChat.h"

NSString *const kSessionKey = @"session";

@interface ChitChat ()
@end

@implementation ChitChat
@synthesize session = _session;

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


@end
