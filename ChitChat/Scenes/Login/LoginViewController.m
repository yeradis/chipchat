#import "LoginViewController.h"
#import "ChitChat.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.service) {
        self.service = [[ChitChat alloc] init];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)doLogin:(id)sender {
    [self clearLoginState];
    if (self.service) {
        [self.service loginWithUserName:self.loginInput.text success:^{

        } failure:^(NSError * _Nonnull error) {
            [self setLoginErrorStateWithMessage:error.domain];
        }];
    }
}

-(void) setLoginErrorStateWithMessage:(NSString*) msg {
    self.loginError.hidden = NO;
    self.loginInput.layer.borderWidth = 2;
    self.loginInput.layer.borderColor = [UIColor redColor].CGColor;
    self.loginError.text = msg;
}
-(void) clearLoginState {
    self.loginError.hidden = YES;
    self.loginError.text = @"";
    self.loginInput.layer.borderWidth = 0;
    self.loginError.layer.borderColor = [UIColor clearColor].CGColor;
}

@end
