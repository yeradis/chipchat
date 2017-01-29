#import <UIKit/UIKit.h>
#import "Messages.h"

@interface CurrentUserMessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIView *messageView;

-(void) setupWithMessage:(id<Message>) message;
@end
