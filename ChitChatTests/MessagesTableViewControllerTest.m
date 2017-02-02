#import <XCTest/XCTest.h>
#import "MessagesTableViewController.h"
#import <OCMock/OCMock.h>
#import "Messages.h"

@interface MessagesTableViewControllerTest : XCTestCase
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MessagesTableViewController* vc;

@property id partiallyMockedApi;

@end

@implementation MessagesTableViewControllerTest

- (void)setUp {
    [super setUp];
    [self setupViewController];
    [self setupServiceClient:[self mockMessagesDictionary]];
}

- (void)tearDown {
    [super tearDown];
}

-(void) setupServiceClient:(NSDictionary*) messages {
    ChitChat* api = [[ChitChat alloc] init];
    self.partiallyMockedApi = [OCMockObject partialMockForObject:api];
    
    [[self.partiallyMockedApi expect] fetchMessageDictionaryWithUrl:OCMOCK_ANY params:OCMOCK_ANY completionBlock:[OCMArg invokeBlockWithArgs:messages,OCMOCK_ANY, nil]];
}

- (void)setupViewController
{
    NSBundle *bundle = [NSBundle mainBundle];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Main" bundle: bundle];
    self.vc = (MessagesTableViewController *)[storyboard instantiateViewControllerWithIdentifier: @"messages"];
}

-(void) test_viewLoad_ShouldNoThrow {
    XCTAssertNoThrow(self.vc.view);
}

-(void) test_tableView_WithoutMessages_ShouldReturnCERORows {
    [self setupServiceClient:@{}];
    
    self.vc.serviceClient = self.partiallyMockedApi;
    XCTAssertNoThrow(self.vc.view);
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:2]];
    XCTAssertTrue([self.vc.tableView numberOfRowsInSection:0] == 0);
}

-(void) test_tableView_WithSomeMessages_ShouldReturnSomeRows {
    [self setupServiceClient:[self mockMessagesDictionary]];
    
    self.vc.serviceClient = self.partiallyMockedApi;
    XCTAssertNoThrow(self.vc.view);
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:2]];
    XCTAssertTrue([self.vc.tableView numberOfRowsInSection:0] > 0);
}

-(void) test_tableView_WithOneMessageFromCurrentUser_ShouldReturnOneRow {
    NSDictionary* message = @{kItemUserName:@"my user name",
                              kItemUserImageUrl:@"",
                              kItemContent:@"some simple message",
                              kItemTime:@"just now"};
    NSDictionary* messages = @{kItemChats:@[message]};
    [self setupServiceClient:messages];
    [self.partiallyMockedApi storeSession:@"my user name"];

    self.vc.serviceClient = self.partiallyMockedApi;
    XCTAssertNoThrow(self.vc.view);
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:2]];
    
    XCTAssertTrue([self.vc.tableView numberOfRowsInSection:0] == 1);
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

-(void) test_messageReceived_HavingNilMessage_ShouldNoThrow {
    [self setupServiceClient:[self mockMessagesDictionary]];
    self.vc.serviceClient = self.partiallyMockedApi;
    
    XCTAssertNoThrow(self.vc.view);
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:2]];
    
    XCTAssertNoThrow(self.vc.serviceClient.messageReceived(nil));
}

-(void) test_messageReceived_HavingValidMessage_ShouldNoThrow {
    [self setupServiceClient:[self mockMessagesDictionary]];
    self.vc.serviceClient = self.partiallyMockedApi;
    
    XCTAssertNoThrow(self.vc.view);
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:2]];
    
    id<Message> message = [Message messageWithCurrentSession:@"just the session" message:@"just a message"];
    XCTAssertNoThrow(self.vc.serviceClient.messageReceived(message));
}


@end
