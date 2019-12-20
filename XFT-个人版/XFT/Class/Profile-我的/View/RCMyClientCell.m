//
//  RCMyClientCell.m
//  XFT
//
//  Created by 夏增明 on 2019/8/29.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCMyClientCell.h"
#import "RCMyClient.h"

@interface RCMyClientCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headPic;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *proName;
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;

@end
@implementation RCMyClientCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setClient:(RCMyClient *)client
{
    _client = client;
    self.name.text = _client.name;
    if (_client.phone && _client.phone.length) {
        self.phone.text = _client.phone;
    }else{
        self.phone.text = @"";
    }
    // 我的客户状态0:已报备 2:到访 4:认筹 5:认购 6:签约 7:退房 8:失效 9:已发展
    if ([_client.cusState isEqualToString:@"0"]) {
        self.state.text = @"已报备";
        self.state.backgroundColor = UIColorFromRGB(0x42CDC5);
        self.time.text = [NSString stringWithFormat:@"报备时间:%@",_client.createTime];
        self.proName.text = [NSString stringWithFormat:@"报备项目:%@",_client.proName];
        [self.codeBtn setTitle:_client.baobeiYuqiTime forState:UIControlStateNormal];
    }else if ([_client.cusState isEqualToString:@"2"]) {
        self.state.text = @"已到访";
        self.state.backgroundColor = UIColorFromRGB(0x428DCD);
        self.time.text = [NSString stringWithFormat:@"到访时间:%@",_client.lastVistTime];
        self.proName.text = [NSString stringWithFormat:@"到访项目:%@",_client.proName];
    }else if ([_client.cusState isEqualToString:@"4"]) {
        self.state.text = @"已认筹";
        self.state.backgroundColor = [UIColor greenColor];
        self.time.text = [NSString stringWithFormat:@"认筹时间:%@",_client.tradesTime];
        self.proName.text = [NSString stringWithFormat:@"认筹项目:%@",_client.proName];
    }else if ([_client.cusState isEqualToString:@"5"]) {
        self.state.text = @"已认购";
        self.state.backgroundColor = UIColorFromRGB(0xCD9442);
        self.time.text = [NSString stringWithFormat:@"认购时间:%@",_client.tradesTime];
        self.proName.text = [NSString stringWithFormat:@"认购项目:%@",_client.proName];
    }else if ([_client.cusState isEqualToString:@"6"]) {
        self.state.text = @"已签约";
        self.state.backgroundColor = UIColorFromRGB(0xF39800);
        self.time.text = [NSString stringWithFormat:@"签约时间:%@",_client.tradesTime];
        self.proName.text = [NSString stringWithFormat:@"签约项目:%@",_client.proName];
    }else if ([_client.cusState isEqualToString:@"7"]) {
        self.state.text = @"已退房";
        self.state.backgroundColor = UIColorFromRGB(0xEC142D);
        self.time.text = [NSString stringWithFormat:@"退房时间:%@",_client.tradesTime];
        self.proName.text = [NSString stringWithFormat:@"退房项目:%@",_client.proName];
    }else if ([_client.cusState isEqualToString:@"8"]){
        self.state.text = @"已失效";
        self.state.backgroundColor = UIColorFromRGB(0xBCC8D6);
        self.time.text = [NSString stringWithFormat:@"失效时间:%@",_client.invalidTime];
        self.proName.text = [NSString stringWithFormat:@"失效项目:%@",_client.proName];
    }else{
        self.state.text = @"已发展";
        self.state.backgroundColor = [UIColor redColor];
        self.time.text = [NSString stringWithFormat:@"发展时间:%@",_client.createTime];
        self.proName.text = @"";
    }
    
    self.collectBtn.selected = [_client.isLove isEqualToString:@"1"]?YES:NO;

    if ([_client.cusState isEqualToString:@"0"]) {// 已报备
        self.pushBtn.hidden = YES;
        self.codeBtn.hidden = NO;
    }else if ([_client.cusState isEqualToString:@"8"]){// 已失效
        self.pushBtn.hidden = NO;
        self.codeBtn.hidden = YES;
    }else{
        self.pushBtn.hidden = YES;
        self.codeBtn.hidden = YES;
    }
}
- (IBAction)clientHandleClicked:(UIButton *)sender {
    if (self.clientHandleCall) {
        self.clientHandleCall(sender.tag);
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

