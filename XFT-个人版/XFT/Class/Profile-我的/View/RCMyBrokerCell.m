//
//  RCMyBrokerCell.m
//  XFT
//
//  Created by 夏增明 on 2019/9/7.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCMyBrokerCell.h"
#import "RCMyBroker.h"

@interface RCMyBrokerCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headPic;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *accRole;
@property (weak, nonatomic) IBOutlet UILabel *creaTime;
@property (weak, nonatomic) IBOutlet UILabel *reportNUm;
@end
@implementation RCMyBrokerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setBroker:(RCMyBroker *)broker
{
    _broker = broker;
    [self.headPic sd_setImageWithURL:[NSURL URLWithString:_broker.headPic]];
    self.name.text = _broker.name;
    self.accRole.text = [NSString stringWithFormat:@" %@ ",_broker.accRole];
    self.creaTime.text = [NSString stringWithFormat:@"发展时间：%@",_broker.creaTime];
    self.reportNUm.text = [NSString stringWithFormat:@"报备客户：%@人",_broker.reportNum];
}
- (IBAction)phoneClicked:(UIButton *)sender {
    if (self.brokerPhoneCall) {
        self.brokerPhoneCall();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
