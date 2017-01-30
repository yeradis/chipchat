#import <XCTest/XCTest.h>
#import "LoginViewController.h"
#import "ChitChat.h"

@interface LoginViewControllerTests : XCTestCase
@property LoginViewController* vc;
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

@end
