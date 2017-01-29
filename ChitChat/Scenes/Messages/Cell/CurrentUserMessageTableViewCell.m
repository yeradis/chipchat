#import "CurrentUserMessageTableViewCell.h"

@implementation CurrentUserMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.messageView.layer.cornerRadius = 16;
    self.messageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void) setupWithMessage:(id<Message>)message {
    self.content.text = message.content;
    self.time.text = message.time;
}

@end
