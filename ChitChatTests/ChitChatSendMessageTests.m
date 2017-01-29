#import <XCTest/XCTest.h>
#import "ChitChat.h"

@interface ChitChatSendMessageTests : XCTestCase
@property ChitChat* api;
@end

@implementation ChitChatSendMessageTests

- (void)setUp {
    [super setUp];
    self.api = [[ChitChat alloc] init];
    [self.api removeSession];
}

- (void)tearDown {
    [super tearDown];
}

- (void) test_SendMessage_HavingNullParams_ShouldNoThrow {
    XCTAssertNoThrow([self.api sendMessage:nil success:nil failure:nil]);
}

- (void) test_SendMessage_HavingNilMessage_ShouldFail {
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"expectation"];

    XCTAssertNoThrow([self.api sendMessage:nil
                                   success:nil
                                   failure:^(NSError * _Nonnull error) {
                                       [expectation1 fulfill];
                                       XCTAssertNotNil(error);
    }]);
    
    [self waitForExpectationsWithTimeout:15 handler:nil];
}

- (void) test_SendMessage_HavingEmptyMessage_ShouldFail {
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"expectation"];
    
    XCTAssertNoThrow([self.api sendMessage:@""
                                   success:nil
                                   failure:^(NSError * _Nonnull error) {
                                       [expectation1 fulfill];
                                       XCTAssertNotNil(error);
                                   }]);
    
    [self waitForExpectationsWithTimeout:15 handler:nil];
}

- (void) test_SendMessage_HavingValidMessage_ShouldBeASuccess {
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"expectation"];
    
    __block BOOL success = NO;

    [self.api sendMessage:@"mensaje"
                                   success:^{
                                       success = YES;
                                       [expectation1 fulfill];
                                   } failure:nil];
    
    [self waitForExpectationsWithTimeout:15 handler:^(NSError * _Nullable error) {
        XCTAssertTrue(success);
    }];
}

- (void) test_SendMessage_HavingValidMessageButMissingSession_ShouldFailOnNewMessageNotification {
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"expectation"];

    __block BOOL messageNotificationBlockCalled = NO;

    void (^block)(_Nullable id<Message> message);
    block = ^void(_Nullable id<Message> message) {
        messageNotificationBlockCalled = YES;
        [expectation1 fulfill];
    };
    
    self.api.messageReceived = block;
    [self.api sendMessage:@"mensaje" success:^{
        [expectation1 fulfill];
    } failure:nil];
    
    [self waitForExpectationsWithTimeout:2 handler:^(NSError * _Nullable error) {
        XCTAssertFalse(messageNotificationBlockCalled);
    }];
}

- (void) test_SendMessage_HavingValidMessageAndSession_ShouldBeASuccessSendingNewMessageNotification {
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"expectation"];
    
    __block BOOL success = NO;
    [self.api storeSession:@"the session value"];
    
    void (^block)(_Nullable id<Message> message);
    block = ^void(_Nullable id<Message> message) {
        [expectation1 fulfill];
        success = YES;
    };
    
    self.api.messageReceived = block;
    [self.api sendMessage:@"mensaje" success:nil failure:nil];
    
    [self waitForExpectationsWithTimeout:15 handler:^(NSError * _Nullable error) {
        XCTAssertTrue(success);
    }];
}

@end
