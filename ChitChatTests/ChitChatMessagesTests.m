#import <XCTest/XCTest.h>
#import "Messages.h"
#import "ChitChat.h"

#import <OCMock/OCMock.h>

@interface ChitChatMessagesTests : XCTestCase
@property ChitChat* api;
@property id partiallyMockedApi;
@end

@implementation ChitChatMessagesTests

- (void)setUp {
    [super setUp];
    
    self.api = [[ChitChat alloc] init];
    self.partiallyMockedApi = [OCMockObject partialMockForObject:self.api];
    
    [[self.partiallyMockedApi expect] fetchMessageDictionaryWithUrl:OCMOCK_ANY params:OCMOCK_ANY completionBlock:[OCMArg invokeBlockWithArgs:[self mockMessagesDictionary],OCMOCK_ANY, nil]];
}

- (void)tearDown {
    [super tearDown];
}

- (void)test_fetchMessageDictionaryWithUrl_HavingNilParams_ShouldNoThrow {
    XCTAssertNoThrow([self.api fetchMessageDictionaryWithUrl:nil params:nil completionBlock:nil]);
}

- (void)test_integration_fetchMessagesDictionaryWithCompletionBlock_ShouldReturnSomething {
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"expectation"];
    
    [self.api fetchMessagesDictionaryWithCompletionBlock:^(NSDictionary * _Nullable responseDictionary, NSError * _Nullable error) {
        [expectation1 fulfill];
        XCTAssertNotNil(responseDictionary);
    }];
    
    [self waitForExpectationsWithTimeout:15 handler:nil];
}

- (void)test_fetchMessagesDictionaryWithCompletionBlock_ShouldReturnSomething {
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"expectation"];
    
    [self.partiallyMockedApi fetchMessagesDictionaryWithCompletionBlock:^(NSDictionary * _Nullable responseDictionary, NSError * _Nullable error) {
        [expectation1 fulfill];
        XCTAssertNotNil(responseDictionary);
    }];

    [self waitForExpectationsWithTimeout:15 handler:nil];
}

- (void)test_fetchMessagesWithCompletionBlock_ShouldReturnSomething {
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"expectation"];
    
    [self.partiallyMockedApi fetchMessagesWithCompletionBlock:^(id<Messages>  _Nullable response, NSError * _Nullable error) {
        [expectation1 fulfill];
        XCTAssertNotNil(response);
    }];
    
    [self waitForExpectationsWithTimeout:15 handler:nil];
}

- (void)test_fetchMessagesWithCompletionBlock_ShouldReturnSomeMessages {
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"expectation"];
    
    [self.partiallyMockedApi fetchMessagesWithCompletionBlock:^(id<Messages>  _Nullable response, NSError * _Nullable error) {
        [expectation1 fulfill];
        NSArray<Message>* messages = response.messages;
        XCTAssertTrue(messages.count > 0);
    }];
    
    [self waitForExpectationsWithTimeout:15 handler:nil];
}

- (void)test_fetchMessagesWithCompletionBlock_FirstObjectShouldMatch {
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"expectation"];
    
    [self.partiallyMockedApi fetchMessagesWithCompletionBlock:^(id<Messages>  _Nullable response, NSError * _Nullable error) {
        [expectation1 fulfill];
        Message* message = [response.messages firstObject];
        XCTAssertTrue([message.username isEqualToString:@"Valerie"]);
    }];
    
    [self waitForExpectationsWithTimeout:15 handler:nil];
}

-(NSDictionary*) mockMessagesDictionary {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:@"chat" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                         options:kNilOptions
                                                           error:&error];
    return json;
}

@end
