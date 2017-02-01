#import "MessageTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation MessageTableViewCell

@synthesize message = _message;
@synthesize serviceClient = _serviceClient;

- (void)awakeFromNib {
    [super awakeFromNib];
    self.messageView.layer.cornerRadius = 16;
    self.messageView.layer.masksToBounds = YES;
    
    self.userIcon.layer.cornerRadius = 16;
    self.userIcon.layer.masksToBounds = YES;
    self.userIcon.layer.borderWidth = 2.0f;
    self.userIcon.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void) prepareForReuse {
    self.userIcon.image = [UIImage imageNamed:@"person-icon.jpg"];
    self.userName.text = @"";
    self.content.text = @"";
    self.time.text = @"";
    self.serviceClient = nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) setupWithMessage:(id<Message>)message
            serviceClient:(id<ChitChatProtocol>)serviceClient {
    self.serviceClient = serviceClient;
    self.message = message;
    
    [self setupContentWithMessage:self.message];
    [self setuptUserIconWithMessage:self.message serviceClient:self.serviceClient];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

-(void) setupContentWithMessage:(id<Message>) message {
    self.content.text = message.content;
    self.userName.text = message.username;
    self.time.text = message.time;
}

-(void) setuptUserIconWithMessage:(id<Message>) message serviceClient:(id<ChitChatProtocol>) serviceClient {
    if (serviceClient) {
        [serviceClient fetchUserImageForMessage:message completionBlock:^(UIImage * _Nullable responseImage, NSError * _Nullable error) {
            if (responseImage) {
                [self setupUserIcon:responseImage];
            }
        }];
    }
}

-(void) setupUserIcon:(UIImage*) image {
    if(image) {
        dispatch_async(dispatch_get_main_queue(), ^(){
            self.userIcon.image = image;
            [self.userIcon setNeedsDisplay];            
        });
    }
}

@end
