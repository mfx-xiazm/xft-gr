//
//  RCStaffHeader.m
//  XFT
//
//  Created by 夏增明 on 2019/8/29.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCStaffHeader.h"
#import "RCMineNum.h"

@interface RCStaffHeader ()
@property (weak, nonatomic) IBOutlet UIImageView *headPic;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *roleName1;
@property (weak, nonatomic) IBOutlet UILabel *roleName2;

@property (weak, nonatomic) IBOutlet UILabel *developedNUM;
@property (weak, nonatomic) IBOutlet UILabel *reportedNUM;
@property (weak, nonatomic) IBOutlet UILabel *haveVisitedNUM;
@property (weak, nonatomic) IBOutlet UILabel *subscribedNUM;

@property (weak, nonatomic) IBOutlet UILabel *develBrokerNUM;
@property (weak, nonatomic) IBOutlet UILabel *brokerDevelCusNUM;

@property (weak, nonatomic) IBOutlet UILabel *totalSalary;
@property (weak, nonatomic) IBOutlet UILabel *canCashSalary;
@end
@implementation RCStaffHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
}
- (IBAction)hiddenSalaryClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.isSelected) {
        self.totalSalary.text = @"***";
        self.canCashSalary.text = @"***";
    }else{
        self.totalSalary.text = (_mineNum.totalCommNUM && _mineNum.totalCommNUM.length)?_mineNum.totalCommNUM:@"0";
        self.canCashSalary.text = (_mineNum.commPaid && _mineNum.commPaid.length)?_mineNum.commPaid:@"0";
    }
}

- (IBAction)staffBtnClicked:(UIButton *)sender {
    if (self.staffHeaderBtnCall) {
        self.staffHeaderBtnCall(sender.tag);
    }
}

-(void)setMineNum:(RCMineNum *)mineNum
{
    _mineNum = mineNum;
    
    self.developedNUM.text = (_mineNum.developedNUM && _mineNum.developedNUM.length)?_mineNum.developedNUM:@"0";
    self.reportedNUM.text = (_mineNum.reportedNUM && _mineNum.reportedNUM.length)?_mineNum.reportedNUM:@"0";
    self.haveVisitedNUM.text = (_mineNum.haveVisitedNUM && _mineNum.haveVisitedNUM.length)?_mineNum.haveVisitedNUM:@"0";
    self.subscribedNUM.text = (_mineNum.subscribedNUM && _mineNum.subscribedNUM.length)?_mineNum.subscribedNUM:@"0";
    
    self.develBrokerNUM.text = (_mineNum.develBrokerNUM && _mineNum.develBrokerNUM.length)?_mineNum.develBrokerNUM:@"0";
    self.brokerDevelCusNUM.text = (_mineNum.brokerDevelCusNUM && _mineNum.brokerDevelCusNUM.length)?_mineNum.brokerDevelCusNUM:@"0";
   
    self.totalSalary.text = (_mineNum.totalCommNUM && _mineNum.totalCommNUM.length)?_mineNum.totalCommNUM:@"0";
    self.canCashSalary.text = (_mineNum.commPaid && _mineNum.commPaid.length)?_mineNum.commPaid:@"0";
    
    
    [self.headPic sd_setImageWithURL:[NSURL URLWithString:[MSUserManager sharedInstance].curUserInfo.userinfo.headpic]];
    self.name.text = ([MSUserManager sharedInstance].curUserInfo.userinfo.name && [MSUserManager sharedInstance].curUserInfo.userinfo.name.length)?[MSUserManager sharedInstance].curUserInfo.userinfo.name:[MSUserManager sharedInstance].curUserInfo.userinfo.nick;
    
    if ([[MSUserManager sharedInstance].curUserInfo.userinfo.isStaff isEqualToString:@"1"] && [[MSUserManager sharedInstance].curUserInfo.userinfo.isOwner isEqualToString:@"1"]) {
        self.roleName1.hidden = NO;
        self.roleName1.text = @" 业主经纪人 ";
        self.roleName2.hidden = NO;
        self.roleName2.text = @" 员工经纪人 ";
    }else if ([[MSUserManager sharedInstance].curUserInfo.userinfo.isStaff isEqualToString:@"1"]) {
        self.roleName1.hidden = NO;
        self.roleName1.text = @" 员工经纪人 ";
        self.roleName2.hidden = YES;
    }else if ([[MSUserManager sharedInstance].curUserInfo.userinfo.isOwner isEqualToString:@"1"]) {
        self.roleName1.hidden = NO;
        self.roleName1.text = @" 业主经纪人 ";
        self.roleName2.hidden = YES;
    }else{
        self.roleName1.hidden = NO;
        self.roleName1.text = @" 个人经纪人 ";
        self.roleName2.hidden = YES;
    }
}
@end
