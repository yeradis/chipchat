#import <XCTest/XCTest.h>
#import "Messages.h"

@interface MessagesTests : XCTestCase

@end

@implementation MessagesTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test_initWithDictionary_havingNilParam_ShouldThrow {
    XCTAssertThrows([[Messages alloc] initWithDictionary:nil]);
}

- (void)test_initWithDictionary_havingEmptyDictionary_ShouldThrow {
    XCTAssertThrows([[Messages alloc] initWithDictionary:@{}]);
}

- (void)test_initWithDictionary_havingValidRootButWrongMessagesDictionary_ShouldThrow {
    NSDictionary* messages = @{kItemChats:@[@{@"hello":@"world"}]};
    XCTAssertThrows([[Messages alloc] initWithDictionary:messages]);
}

- (void)test_initWithDictionary_havingValidDictionary_ShouldNoThrow {
    NSDictionary* msg = @{
                          kItemUserName:@"the user",
                          kItemUserImageUrl:@"the url",
                          kItemContent:@"some content",
                          kItemTime:@"somw time"
                          };
    NSDictionary* dic = @{kItemChats:@[msg]};
    XCTAssertNoThrow([[Messages alloc] initWithDictionary:dic]);
}

- (void)test_initWithDictionary_havingValidDictionary_ShouldReturnSomeMessages {
    NSDictionary* msg = @{
                          kItemUserName:@"the user",
                          kItemUserImageUrl:@"the url",
                          kItemContent:@"some content",
                          kItemTime:@"somw time"
                          };
    NSDictionary* dic = @{kItemChats:@[msg]};
    XCTAssertTrue([[Messages alloc] initWithDictionary:dic].messages.count > 0);
}

- (void)test_initWithDictionary_havingValidDictionary_ShouldMatch {
    NSDictionary* msgDic = @{
                          kItemUserName:@"the user",
                          kItemUserImageUrl:@"the url",
                          kItemContent:@"some content",
                          kItemTime:@"somw time"
                          };
    NSDictionary* dic = @{kItemChats:@[msgDic]};
    
    Messages* messages = [[Messages alloc] initWithDictionary:dic];
    Message* msg = [messages.messages firstObject];
    BOOL match = [msg.username isEqualToString:msg.username] &&
    [msg.userImageUrl isEqualToString:msg.userImageUrl] &&
    [msg.content isEqualToString:msg.content] &&
    [msg.time isEqualToString:msg.time];
    XCTAssertTrue(match);

}

- (void) test_isValidMessagesDictionary_HavingNilParam_ShouldNoThrow {
    XCTAssertNoThrow([Messages isValidMessagesDictionary:nil]);
}

- (void) test_isValidMessagesDictionary_HavingEmptyParam_ShouldNoThrow {
    XCTAssertNoThrow([Messages isValidMessagesDictionary:@{}]);
}

- (void) test_isValidMessagesDictionary_HavingWrongDictionary_ShouldNoThrow {
    XCTAssertNoThrow([Messages isValidMessagesDictionary:@{@"hello":@"world"}]);
}

- (void) test_isValidMessagesDictionary_HavingWrongDictionary_ShouldReturnNO {
    XCTAssertFalse([Messages isValidMessagesDictionary:@{@"hello":@"world"}]);
}

- (void) test_isValidMessagesDictionary_HavingValidDictionary_ShouldReturnNO {
    NSDictionary* dic = @{
                          kItemChats:@[]};
    XCTAssertTrue([Messages isValidMessagesDictionary:dic]);
}

@end
