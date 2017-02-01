#import "MessagesTableViewController.h"
#import "MessageTableViewCell.h"
#import "SendMessageViewController.h"
#import  "CurrentUserMessageTableViewCell.h"

@interface MessagesTableViewController ()

@end

@implementation MessagesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 104;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"MessageCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CurrentUserMessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"CurrentUserMessageCell"];
    
    [self setupServiceClient];
    
    self.title = [NSString stringWithFormat:@"Chat - %@",self.serviceClient.session];
}

-(id<ChitChatProtocol>) serviceClient {
    if (!_serviceClient) {
        _serviceClient = [[ChitChat alloc] init];
    }
    return _serviceClient;
}

-(void) setupServiceClient {
    self.serviceClient.messageReceived = [self handleNewMessageReceived];
    [self.serviceClient fetchMessagesWithCompletionBlock:[self handleMessageListReceived]];
}

// called after a single new message received, like those the current user sends
- (void (^)(_Nullable id<Message> message))handleNewMessageReceived {
    __weak MessagesTableViewController *weakself = self;
    return ^(_Nullable id<Message> message) {
        [weakself.messages addObject:message];
        [weakself.tableView reloadData];
        [weakself.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:weakself.messages.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    };
}

// handle the list of messages, the full list loaded at launch
- (void (^)(id<Messages>  _Nullable response, NSError * _Nullable error))handleMessageListReceived {
    __weak MessagesTableViewController *weakself = self;
    return ^(id<Messages>  _Nullable response, NSError * _Nullable error) {
        if (response) {
            
            weakself.messages = [NSMutableArray<Message> arrayWithArray:response.messages];
            [weakself.tableView reloadData];
            [weakself.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messages.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            
        }
    };
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (self.messages) ? self.messages.count : 0;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Message* message = (Message*)[self.messages objectAtIndex:indexPath.row];
    
    UITableViewCell* cell;
    if ([message.username isEqualToString:self.serviceClient.session]) {
        cell = [self cellForCurrentUserMessage:message table:tableView indexPath:indexPath];
    } else {
        cell = [self cellForMessage:message table:tableView indexPath:indexPath];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(UITableViewCell*) cellForMessage:(id<Message>) message
                             table:(UITableView*) tableView
                         indexPath:(NSIndexPath *)indexPath {
    MessageTableViewCell *cell = (MessageTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"MessageCell" forIndexPath:indexPath];
    [cell setupWithMessage:message serviceClient:self.serviceClient];
    return cell;
}

-(UITableViewCell*) cellForCurrentUserMessage:(id<Message>) message
                                        table:(UITableView*) tableView
                                    indexPath:(NSIndexPath *)indexPath {
    CurrentUserMessageTableViewCell *cell = (CurrentUserMessageTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"CurrentUserMessageCell" forIndexPath:indexPath];
    [cell setupWithMessage:message];
    return cell;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"closeChat"])
    {
        [self.serviceClient removeSession];
    }
    
    if ([[segue identifier] isEqualToString:@"EmbedSegue"]) {
        SendMessageViewController *embed = segue.destinationViewController;
        embed.serviceClient = self.serviceClient;
    }
}


@end
