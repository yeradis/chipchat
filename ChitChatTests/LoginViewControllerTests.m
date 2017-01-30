#import <XCTest/XCTest.h>
#import "LoginViewController.h"
#import "ChitChat.h"
#import <OCMock/OCMock.h>

@interface LoginViewController (Testing)
-(void) showMessages;
-(void) setLoginErrorStateWithMessage:(NSString*) msg;
@end

@interface LoginViewControllerTests : XCTestCase
@property LoginViewController* vc;
@property id partiallyMockedApi;
@end

@implementation LoginViewControllerTests

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
    self.vc = (LoginViewController *)[storyboard instantiateViewControllerWithIdentifier: @"login"];
}

-(void) test_viewLoad_ShouldNoThrow {
    XCTAssertNoThrow(self.vc.view);
}

-(void) test_doLogin_HavingAValidUserName_ShouldCallshowMessages {
    ChitChat* api = [[ChitChat alloc] init];
    self.vc.serviceClient = api;
    self.partiallyMockedApi = [OCMockObject partialMockForObject:self.vc];
    [[self.partiallyMockedApi expect] showMessages];

    XCTAssertNoThrow([self.partiallyMockedApi view]);
    [self.partiallyMockedApi loginInput].text = @"user name";
    [self.partiallyMockedApi doLogin:nil];
    [self.partiallyMockedApi verify];
}

-(void) test_doLogin_HavingAnInvalidValidUserName_ShouldCallSetsetLoginErrorStateWithMessage {
    ChitChat* api = [[ChitChat alloc] init];
    self.vc.serviceClient = api;
    self.partiallyMockedApi = [OCMockObject partialMockForObject:self.vc];
    [[self.partiallyMockedApi expect] setLoginErrorStateWithMessage:OCMOCK_ANY];
    
    XCTAssertNoThrow([self.partiallyMockedApi view]);
    [self.partiallyMockedApi loginInput].text = @"";
    [self.partiallyMockedApi doLogin:nil];
    [self.partiallyMockedApi verify];
}

-(void) test_doLogin_HavingAReservedUserName_ShouldCallSetsetLoginErrorStateWithMessage {
    ChitChat* api = [[ChitChat alloc] init];
    self.vc.serviceClient = api;
    self.partiallyMockedApi = [OCMockObject partialMockForObject:self.vc];
    [[self.partiallyMockedApi expect] setLoginErrorStateWithMessage:OCMOCK_ANY];
    
    XCTAssertNoThrow([self.partiallyMockedApi view]);
    [self.partiallyMockedApi loginInput].text = @"Lily";
    [self.partiallyMockedApi doLogin:nil];
    
    [self.partiallyMockedApi verify];
}

@end
