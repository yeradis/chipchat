#import <UIKit/UIKit.h>
#import "ChitChatProtocol.h"

@interface SendMessageViewController : UIViewController

@property (nonnull, strong, nonatomic) id<ChitChatProtocol> serviceClient;
@property (weak, nonatomic) IBOutlet UITextField *message;

- (IBAction)sendMessage:(nonnull id)sender;


@end
