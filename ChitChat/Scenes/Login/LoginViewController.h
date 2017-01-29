#import <UIKit/UIKit.h>
#import "ChitChatProtocol.h"

@interface LoginViewController : UIViewController
@property (nonatomic, strong) id<ChitChatProtocol> serviceClient;
@property (nonatomic, weak) IBOutlet UITextField *loginInput;
@property (nonatomic, weak) IBOutlet UILabel *loginError;
- (IBAction)doLogin:(id)sender;

@end
