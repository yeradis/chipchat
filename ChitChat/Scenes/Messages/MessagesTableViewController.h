#import <UIKit/UIKit.h>
#import "Messages.h"
#import "ChitChat.h"

@interface MessagesTableViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonnull, strong, nonatomic) id<ChitChatProtocol> serviceClient;
@property (nullable, strong, atomic) NSMutableArray<Message>* messages;
@end
