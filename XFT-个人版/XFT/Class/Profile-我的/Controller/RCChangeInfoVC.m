//
//  RCChangeInfoVC.m
//  XFT
//
//  Created by 夏增明 on 2019/8/28.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCChangeInfoVC.h"
#import "UITextField+GYExpand.h"

@interface RCChangeInfoVC ()
@property (weak, nonatomic) IBOutlet UITextField *nick;

@end

@implementation RCChangeInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"我的信息"];
    [self setUpNavBar];
    hx_weakify(self);
    [self.nick lengthLimit:^{
        hx_strongify(weakSelf);
        if (strongSelf.nick.text.length > 10) {
            strongSelf.nick.text = [strongSelf.nick.text substringToIndex:10];
        }
    }];
    self.nick.text = [MSUserManager sharedInstance].curUserInfo.userinfo.nick;
}
-(void)setUpNavBar
{
    SPButton *item = [[SPButton alloc] initWithImagePosition:SPButtonImagePositionLeft];
    item.layer.cornerRadius = 4.f;
    item.layer.masksToBounds = YES;
    item.hxn_size = CGSizeMake(50, 30);
    item.backgroundColor = HXControlBg;
    item.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    [item setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    [item setTitle:@"完成" forState:UIControlStateNormal];
    [item addTarget:self action:@selector(sureClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:item];
}
-(void)sureClicked
{
    if (![self.nick hasText]) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请填写昵称"];
        return;
    }
    if (self.nick.text.length < 4) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"昵称需4-10个字符"];
        return;
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"nick"] = self.nick.text;//反馈意见
    parameters[@"data"] = data;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"sso/sso/acclogin/updateNick" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if ([responseObject[@"code"] integerValue] == 0) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
            [MSUserManager sharedInstance].curUserInfo.userinfo.nick = strongSelf.nick.text;
            [[MSUserManager sharedInstance] saveUserInfo];
            if (strongSelf.changeNickCall) {
                strongSelf.changeNickCall();
            }
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
@end
