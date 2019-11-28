//
//  RCLoanDetailCell.m
//  XFT
//
//  Created by 夏增明 on 2019/8/30.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCLoanDetailCell.h"
#import "RCCalculateResultModel.h"

@interface RCLoanDetailCell ()
@property (weak, nonatomic) IBOutlet UILabel *nperString;// 期数（第一期、第二期，按月分的）
@property (weak, nonatomic) IBOutlet UILabel *needPayString;//月供（每月需支付金额）
@property (weak, nonatomic) IBOutlet UILabel *benjinString;//本金
@property (weak, nonatomic) IBOutlet UILabel *lixiString;//利息
@property (weak, nonatomic) IBOutlet UILabel *surplusPayString;//剩余还款

@property (weak, nonatomic) IBOutlet UILabel *zNperString;// 期数（第一期、第二期，按月分的）
@property (weak, nonatomic) IBOutlet UILabel *zNeedPayString;//月供（每月需支付金额）
@property (weak, nonatomic) IBOutlet UILabel *zsPayString;//商贷月供（每月需支付金额）
@property (weak, nonatomic) IBOutlet UILabel *zgPayString;//公积金月供（每月需支付金额）

@end
@implementation RCLoanDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setMonth:(RCCalculateResultMonthModel *)month
{
    _month = month;
    self.nperString.text = _month.nperString;// 期数（第一期、第二期，按月分的）
    self.needPayString.text = [NSString stringWithFormat:@"%.1f",_month.needPay];//月供（每月需支付金额）
    self.benjinString.text = [NSString stringWithFormat:@"%.1f",_month.benjin];//本金
    self.lixiString.text = [NSString stringWithFormat:@"%.1f",_month.lixi];//利息
    self.surplusPayString.text = [NSString stringWithFormat:@"%.1f",_month.surplusPay];//剩余还款
}
-(void)setZmonth:(RCCalculateResultMonthModel *)zmonth
{
    _zmonth = zmonth;
    self.zNperString.text = _zmonth.nperString;// 期数（第一期、第二期，按月分的）
    self.zNeedPayString.text = [NSString stringWithFormat:@"%.1f",_zmonth.needPay];//月供（每月需支付金额）
    self.zsPayString.text = [NSString stringWithFormat:@"%.1f",_zmonth.sdNeedPay];//商贷月供（每月需支付金额）
    self.zgPayString.text = [NSString stringWithFormat:@"%.1f",_zmonth.gjjNeedPay];//公积金月供（每月需支付金额）
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
