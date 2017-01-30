#import <XCTest/XCTest.h>
#import "ChitChat.h"
#import "SendMessageViewController.h"

@interface SendMessageViewControllerTests : XCTestCase
@property SendMessageViewController* vc;
@end

@implementation SendMessageViewControllerTests

- (void)setUp {
    [super setUp];
    [self setupViewController];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)setupViewController
{
    NSBundle *bundle = [NSBundle mainBundle];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Main" bundle: bundle];
    self.vc = (SendMessageViewController *)[storyboard instantiateViewControllerWithIdentifier: @"sendMessage"];
}

-(void) test_viewLoad_ShouldNoThrow {
    XCTAssertNoThrow(self.vc.view);
}

-(void) test_SendMessage_ShouldNoThrow {
    XCTAssertNoThrow([self.vc sendMessage:nil]);
}

-(void) test_sendMessage_ShouldSendMessageNotification {
        XCTestExpectation *expectation1 = [self expectationWithDescription:@"expectation"];
        
        __block BOOL success = NO;
        ChitChat* api = [[ChitChat alloc] init];
        [api storeSession:@"the session value"];
        
        void (^block)(_Nullable id<Message> message);
        block = ^void(_Nullable id<Message> message) {
            [expectation1 fulfill];
            success = YES;
        };
        
        api.messageReceived = block;
        self.vc.serviceClient = api;
        // lets connect outlets
        XCTAssertNoThrow([self.vc view]);
        self.vc.message.text = @"just a message";
    
        [self.vc sendMessage:nil];
    
        [self waitForExpectationsWithTimeout:15 handler:^(NSError * _Nullable error) {
            XCTAssertTrue(success);
        }];
}

-(void) test_sendMessage_MessageBoxShouldBeEmptyAfterMessageSent {
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"expectation"];
    
    __block BOOL success = NO;
    ChitChat* api = [[ChitChat alloc] init];
    [api storeSession:@"the session value"];
    
    void (^block)(_Nullable id<Message> message);
    block = ^void(_Nullable id<Message> message) {
        [expectation1 fulfill];
        success = YES;
    };
    
    api.messageReceived = block;
    self.vc.serviceClient = api;
    // lets connect outlets
    XCTAssertNoThrow([self.vc view]);
    self.vc.message.text = @"just a message";
    
    [self.vc sendMessage:nil];
    
    [self waitForExpectationsWithTimeout:15 handler:^(NSError * _Nullable error) {
        XCTAssertTrue(self.vc.message.text.length == 0);
    }];
}


@end
