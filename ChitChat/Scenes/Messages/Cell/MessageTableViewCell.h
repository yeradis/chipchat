#import <UIKit/UIKit.h>
#import "Messages.h"
#import "ChitChat.h"

@interface MessageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIView *messageView;

@property (strong, nonatomic) id<Message> message;
@property (nonatomic, strong) id<ChitChatProtocol> serviceClient;

-(void) setupWithMessage:(id<Message>) message serviceClient:(id<ChitChatProtocol>) serviceClient;

@end
