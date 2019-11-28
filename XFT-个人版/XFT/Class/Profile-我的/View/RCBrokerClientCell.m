//
//  RCBrokerClientCell.m
//  XFT
//
//  Created by 夏增明 on 2019/9/7.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCBrokerClientCell.h"
#import "RCMyClient.h"

@interface RCBrokerClientCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headPic;
@property (weak, nonatomic) IBOutlet UILabel *state;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *reportTime;

@end
@implementation RCBrokerClientCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setClient:(RCMyClient *)client
{
    _client = client;
    self.name.text = _client.name;
    if (_client.phone && _client.phone.length) {
        self.phone.text = [NSString stringWithFormat:@"%@****%@",[_client.phone substringToIndex:3],[_client.phone substringFromIndex:_client.phone.length-4]];
    }else{
        self.phone.text = @"";
    }
    /* 客户状态 0:报备成功 2:到访 4:认筹 5:认购 6:签约 7:退房 其他100:已失效 */
    if ([_client.cusState isEqualToString:@"0"]) {
        self.state.text = @"已报备";
        self.state.backgroundColor = UIColorFromRGB(0x42CDC5);
        self.reportTime.hidden = YES;
        self.time.text = [NSString stringWithFormat:@"报备时间:%@",_client.createTime];
    }else if ([_client.cusState isEqualToString:@"2"]) {
        self.state.text = @"已到访";
        self.state.backgroundColor = UIColorFromRGB(0x428DCD);
        self.reportTime.hidden = NO;
        self.time.text = [NSString stringWithFormat:@"到访时间:%@",_client.lastVistTime];
        self.reportTime.text = [NSString stringWithFormat:@"报备时间:%@",_client.createTime];
    }else if ([_client.cusState isEqualToString:@"4"]) {
        self.state.text = @"已认筹";
        self.state.backgroundColor = [UIColor greenColor];
        self.reportTime.hidden = NO;
        self.time.text = [NSString stringWithFormat:@"认筹时间:%@",_client.transTime];
        self.reportTime.text = [NSString stringWithFormat:@"报备时间:%@",_client.createTime];
    }else if ([_client.cusState isEqualToString:@"5"]) {
        self.state.text = @"已认购";
        self.state.backgroundColor = UIColorFromRGB(0xCD9442);
        self.reportTime.hidden = NO;
        self.time.text = [NSString stringWithFormat:@"认购时间:%@",_client.transTime];
        self.reportTime.text = [NSString stringWithFormat:@"报备时间:%@",_client.createTime];
    }else if ([_client.cusState isEqualToString:@"6"]) {
        self.state.text = @"已签约";
        self.state.backgroundColor = UIColorFromRGB(0xF39800);
        self.reportTime.hidden = NO;
        self.time.text = [NSString stringWithFormat:@"签约时间:%@",_client.transTime];
        self.reportTime.text = [NSString stringWithFormat:@"报备时间:%@",_client.createTime];
    }else if ([_client.cusState isEqualToString:@"7"]) {
        self.state.text = @"已退房";
        self.state.backgroundColor = UIColorFromRGB(0xEC142D);
        self.reportTime.hidden = NO;
        self.time.text = [NSString stringWithFormat:@"退房时间:%@",_client.transTime];
        self.reportTime.text = [NSString stringWithFormat:@"报备时间:%@",_client.createTime];
    }else{
        self.state.text = @"已失效";
        self.state.backgroundColor = UIColorFromRGB(0xBCC8D6);
        self.reportTime.hidden = NO;
        self.time.text = [NSString stringWithFormat:@"失效时间:%@",_client.transTime];
        self.reportTime.text = [NSString stringWithFormat:@"报备时间:%@",_client.createTime];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
