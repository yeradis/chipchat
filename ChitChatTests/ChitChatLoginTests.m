#import <XCTest/XCTest.h>
#import "ChitChat.h"

@interface ChitChatLoginTests : XCTestCase

@end

@implementation ChitChatLoginTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void) test_loginWithUserName_HavingNilParam_ShouldNoThrow{
    XCTAssertNoThrow([[[ChitChat alloc] init] loginWithUserName:nil success:nil failure:nil]);
}

-(void) test_loginWithUserName_HavingEmptyParam_ShouldNoThrow{
    XCTAssertNoThrow([[[ChitChat alloc] init] loginWithUserName:@"" success:nil failure:nil]);
}

-(void) test_loginWithUserName_HavingValigParam_ShouldNoThrow{
    XCTAssertNoThrow([[[ChitChat alloc] init] loginWithUserName:@"" success:nil failure:nil]);
}

-(void) test_loginWithUserName_HavingEmptyParam_ShouldFAIL {
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Failure expectation"];

    [[[ChitChat alloc] init] loginWithUserName:@"" success:^{
    } failure:^(NSError * _Nonnull error) {
        [expectation1 fulfill];
        XCTAssertNotNil(error);
    }];
    
    [self waitForExpectationsWithTimeout:5 handler:nil];
}

-(void) test_LoginWithUserName_HavingAnExistingUsername_ShouldFail {
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Failure expectation"];
    
    [[[ChitChat alloc] init] loginWithUserName:@"lily" success:^{
    } failure:^(NSError * _Nonnull error) {
        [expectation1 fulfill];
        XCTAssertNotNil(error);
    }];
    
    [self waitForExpectationsWithTimeout:5 handler:nil];
}
-(void) test_loginWithUserName_HavingValidParam_ShouldBeSuccess_UsingHighExpectations {
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Failure expectation"];
    __block BOOL success = NO;
    
    [[[ChitChat alloc] init] loginWithUserName:@"a valid user name" success:^{
        success = YES;
        [expectation1 fulfill];
    } failure:^(NSError * _Nonnull error) {
        success = NO;
        [expectation1 fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5 handler:^(NSError * _Nullable error) {
        XCTAssertTrue(success);
    }];
}

-(void) test_loginWithUserName_HavingValidParam_ShouldBeSuccess_UsingDispatch_group_wait{
    __block BOOL success = NO;
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    
    // This is a task, you can put this inside a loop
    //and do some check here and at the end of all tasks
    dispatch_group_async(group,queue,^{
        NSString* threadName = [NSString stringWithFormat:@"lets give a name to this thread"];
        [[NSThread currentThread] setName:threadName];
        
        [[[ChitChat alloc] init] loginWithUserName:@"a valid user name"
                                           success:^{
            success = YES;
        } failure:^(NSError * _Nonnull error) {
            success = NO;
        }];
    });
    
    // This will be executed when all tasks are complete
    dispatch_group_notify(group,queue,^{
        XCTAssertTrue(success);
        
        // Release at the end, after assertion,
        // otherwise test assertion will not be executed and will notify
        // the test as a succes without doing any assertion
        dispatch_semaphore_signal(semaphore);
    });
    
    // Block this thread until all tasks are complete
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    // Wait until the notify block signals our semaphore
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}

@end
