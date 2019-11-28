//
//  RCProfileHeader.m
//  XFT
//
//  Created by 夏增明 on 2019/8/28.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCProfileHeader.h"

@interface RCProfileHeader ()
@property (weak, nonatomic) IBOutlet UIView *noLoginView;
@property (weak, nonatomic) IBOutlet UIView *loginView;

@property (weak, nonatomic) IBOutlet UIImageView *headPic;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *roleName1;
@property (weak, nonatomic) IBOutlet UILabel *roleName2;

@end
@implementation RCProfileHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
    if ([MSUserManager sharedInstance].isLogined) {
        self.noLoginView.hidden = YES;
        self.loginView.hidden = NO;
    }else{
        self.noLoginView.hidden = NO;
        self.loginView.hidden = YES;
    }
}
-(void)setMineNum:(RCMineNum *)mineNum
{
    _mineNum = mineNum;
    
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
        self.roleName1.text = @" 社会经纪人 ";
        self.roleName2.hidden = YES;
    }
}
- (IBAction)infoClicked:(UIButton *)sender {
    if (self.profileHeaderClicked) {
        self.profileHeaderClicked();
    }
}

@end
