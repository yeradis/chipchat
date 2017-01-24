#import <XCTest/XCTest.h>
#import "Messages.h"

@interface MessageTest : XCTestCase

@end

@implementation MessageTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test_initWithDictionary_havingNilParam_ShouldNoThrow {
    XCTAssertThrows([[Message alloc] initWithDictionary:nil]);
}

- (void)test_initWithDictionary_havingEmptyDictionary_ShouldNoThrow {
    XCTAssertThrows([[Message alloc] initWithDictionary:@{}]);
}

- (void)test_initWithDictionary_havingWrongDictionary_ShouldNoThrow {
    XCTAssertThrows([[Message alloc] initWithDictionary:@{@"hello":@"world"}]);
}


- (void)test_initWithDictionary_havingValidDic_ShouldNoThrow {
    NSDictionary* message = @{kItemUserName:@"the user",
                              kItemUserImageUrl:@"the url",
                              kItemContent:@"some content",
                              kItemTime:@"somw time"};
    XCTAssertNoThrow([[Message alloc] initWithDictionary:message]);
}

- (void)test_initWithDictionary_havingValidDic_ShouldMatch {
    NSDictionary* dic = @{
                          kItemUserName:@"the user",
                          kItemUserImageUrl:@"the url",
                          kItemContent:@"some content",
                          kItemTime:@"somw time"
                          };
    
    Message* msg = [[Message alloc] initWithDictionary:dic];
    BOOL match = [dic[kItemUserName] isEqualToString:msg.username] &&
                    [dic[kItemUserImageUrl] isEqualToString:msg.userImageUrl] &&
                    [dic[kItemContent] isEqualToString:msg.content] &&
                    [dic[kItemTime] isEqualToString:msg.time];
    XCTAssertTrue(match);
}

- (void) test_isValidMessageDictionary_HavingNilParam_ShouldNoThrow {
    XCTAssertNoThrow([Message isValidMessageDictionary:nil]);
}

- (void) test_isValidMessageDictionary_HavingEmptyParam_ShouldNoThrow {
    XCTAssertNoThrow([Message isValidMessageDictionary:@{}]);
}

- (void) test_isValidMessageDictionary_HavingWrongDictionary_ShouldNoThrow {
    XCTAssertNoThrow([Message isValidMessageDictionary:@{@"hello":@"world"}]);
}

- (void) test_isValidMessageDictionary_HavingWrongDictionary_ShouldReturnNO {
    XCTAssertFalse([Message isValidMessageDictionary:@{@"hello":@"world"}]);
}

- (void) test_isValidMessageDictionary_HavingValidDictionary_ShouldReturnNO {
    NSDictionary* dic = @{
                          kItemUserName:@"the user",
                          kItemUserImageUrl:@"the url",
                          kItemContent:@"some content",
                          kItemTime:@"somw time"
                          };
    XCTAssertTrue([Message isValidMessageDictionary:dic]);
}

@end
