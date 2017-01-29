#import "SendMessageViewController.h"

@interface SendMessageViewController ()

@end

@implementation SendMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)sendMessage:(id)sender {
    if (self.serviceClient) {
        [self.serviceClient sendMessage:self.message.text success:^{
            self.message.text = @"";
        } failure:^(NSError * _Nonnull error) {
            
        }];
    }
}
@end
