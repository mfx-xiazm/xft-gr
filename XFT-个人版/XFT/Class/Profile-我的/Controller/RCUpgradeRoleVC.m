//
//  RCUpgradeRoleVC.m
//  XFT
//
//  Created by 夏增明 on 2019/8/29.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCUpgradeRoleVC.h"
#import "UITextField+GYExpand.h"
#import "FSActionSheet.h"
#import "HXTabBarController.h"

@interface RCUpgradeRoleVC ()
@property (weak, nonatomic) IBOutlet UIView *roleInfoView;
@property (weak, nonatomic) IBOutlet UIView *roleInfoView0;
/* 社会经纪人 */
@property (weak, nonatomic) IBOutlet UITextField *shName;
@property (weak, nonatomic) IBOutlet UITextField *shPhone;
// 上一次选择的性别
@property(nonatomic,strong) UIButton *shSexBtn;
@property (weak, nonatomic) IBOutlet UIImageView *shTagImg;
/* 业主或者员工经纪人 */
@property (weak, nonatomic) IBOutlet UIImageView *yzTagImg;
@property (weak, nonatomic) IBOutlet UIImageView *ygTagImg;
@property (weak, nonatomic) IBOutlet UITextField *otName;
// 上一次选择的性别
@property(nonatomic,strong) UIButton *otSexBtn;
@property (weak, nonatomic) IBOutlet UITextField *otPhone;
@property (weak, nonatomic) IBOutlet UITextField *otIdType;
@property (weak, nonatomic) IBOutlet UITextField *otIdCard;
/* 注册身份 1:个人经纪人,2:业主经纪人,3:员工经纪人 */
@property(nonatomic,assign) NSInteger accRole;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@end

@implementation RCUpgradeRoleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"成为经纪人"];
    
    self.shPhone.text = [MSUserManager sharedInstance].curUserInfo.userinfo.regPhone;
    self.otPhone.text = [MSUserManager sharedInstance].curUserInfo.userinfo.regPhone;
    
    hx_weakify(self);
    [self.shPhone lengthLimit:^{
        hx_strongify(weakSelf);
        if (strongSelf.shPhone.text.length > 11) {
            strongSelf.shPhone.text = [strongSelf.shPhone.text substringToIndex:11];
        }
    }];
    [self.otPhone lengthLimit:^{
        hx_strongify(weakSelf);
        if (strongSelf.otPhone.text.length > 11) {
            strongSelf.otPhone.text = [strongSelf.otPhone.text substringToIndex:11];
        }
    }];
    
    
    [self.sureBtn BindingBtnJudgeBlock:^BOOL{
        hx_strongify(weakSelf);
        if (strongSelf.accRole == 0) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请选择经纪人身份"];
            return NO;
        }
        if (strongSelf.accRole == 1) {
            if (![strongSelf.shName hasText]) {
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入姓名"];
                return NO;
            }
            if (!strongSelf.shSexBtn) {
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请选择性别"];
                return NO;
            }
            if (![strongSelf.shPhone hasText]) {
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入电话"];
                return NO;
            }
            if (strongSelf.shPhone.text.length != 11) {
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"电话格式有误"];
                return NO;
            }
        }else{
            if (![strongSelf.otName hasText]) {
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入姓名"];
                return NO;
            }
            if (!strongSelf.otSexBtn) {
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请选择性别"];
                return NO;
            }
            if (![strongSelf.otPhone hasText]) {
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入电话"];
                return NO;
            }
            if (strongSelf.otPhone.text.length != 11) {
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"电话格式有误"];
                return NO;
            }
            if (![strongSelf.otIdType hasText]) {
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请选择身份类型"];
                return NO;
            }
            if (![strongSelf.otIdCard hasText]) {
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入证件号码"];
                return NO;
            }
            if (![strongSelf.otIdCard.text judgeIdentityStringValid]) {
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"证件号码有误"];
                return NO;
            }
        }
        return YES;
    } ActionBlock:^(UIButton * _Nullable button) {
        hx_strongify(weakSelf);
        [strongSelf submitRoleMsgRequest:button];
    }];
}

- (IBAction)roleTypeCliked:(UIButton *)sender {
    if (sender.tag == 1) {
        self.roleInfoView0.hidden = NO;
        self.roleInfoView.hidden = YES;
        self.shTagImg.hidden = NO;
        self.yzTagImg.hidden = YES;
        self.ygTagImg.hidden = YES;
    }else if (sender.tag == 2){
        self.roleInfoView0.hidden = YES;
        self.roleInfoView.hidden = NO;
        self.shTagImg.hidden = YES;
        self.yzTagImg.hidden = NO;
        self.ygTagImg.hidden = YES;
    }else{
        self.roleInfoView0.hidden = YES;
        self.roleInfoView.hidden = NO;
        self.shTagImg.hidden = YES;
        self.yzTagImg.hidden = YES;
        self.ygTagImg.hidden = NO;
    }
    self.accRole = sender.tag;
}

- (IBAction)clientSexClicked:(UIButton *)sender {
    if (self.accRole == 1) {
        self.shSexBtn.selected = NO;
        self.shSexBtn.boderColor = UIColorFromRGB(0xCCCCCC);
        sender.selected = YES;
        sender.boderColor = UIColorFromRGB(0x666666);
        self.shSexBtn = sender;
    }else{
        self.otSexBtn.selected = NO;
        self.otSexBtn.boderColor = UIColorFromRGB(0xCCCCCC);
        sender.selected = YES;
        sender.boderColor = UIColorFromRGB(0x666666);
        self.otSexBtn = sender;
    }
}
- (IBAction)cardTypeClicked:(UIButton *)sender {
    FSActionSheet *sheet = [[FSActionSheet alloc] initWithTitle:@"证件类型" delegate:nil currentButtonTitle:[self.otIdType hasText]?self.otIdType.text:@""  cancelButtonTitle:@"取消" highlightedButtonTitle:nil otherButtonTitles:@[@"身份证"]];
    hx_weakify(self);
    [sheet showWithSelectedCompletion:^(NSInteger selectedIndex) {
        hx_strongify(weakSelf);
        strongSelf.otIdType.text = @"身份证";
    }];
}
-(void)submitRoleMsgRequest:(UIButton *)sender
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"accRole"] = @(self.accRole);//经纪人注册类型:1:个人经纪人,2:业主经纪人,3:员工经纪人
    if (self.accRole == 1) {
        data[@"name"] = self.shName.text;//注册姓名
        data[@"phone"] = self.shPhone.text;//电话
        data[@"sex"] = @(self.shSexBtn.tag);//性别 1:男 2:女
    }else{
        data[@"name"] = self.otName.text;//注册姓名
        data[@"cardType"] = @"1";//证件类型(业主经纪人必传), 1:身份证
        data[@"cardNo"] = self.otIdCard.text;//证件号码(业主/员工经纪人必传)
        data[@"phone"] = self.otPhone.text;//电话
        data[@"sex"] = @(self.otSexBtn.tag);//性别 1:男 2:女
    }
    data[@"type"] = @"1";//类型 1:泛营销 2:案场 3:展厅
    data[@"registeredType"] = @"2";//注册类型:1.推荐注册,2.自己注册,3:app分享注册
    data[@"invitationCode"] = @"";//邀请码
    data[@"prouuid"] = @"";//项目uuid
    data[@"recommendUuid"] = @"";//推荐人UUID
    data[@"roleType"] = @"";//上级推荐角色类型 1:顾问2：专员
    data[@"showRoomuuid"] = @"";//展厅uuid

    parameters[@"data"] = data;

    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"sys/sys/agent/brokerRegistered" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [sender stopLoading:@"确认" image:nil textColor:nil backgroundColor:nil];
        if ([responseObject[@"code"] integerValue] == 0) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
            if (strongSelf.accRole == 1) {
                [MSUserManager sharedInstance].curUserInfo.userinfo.accRole = @"13";
                [MSUserManager sharedInstance].curUserInfo.userinfo.isStaff = @"0";
                [MSUserManager sharedInstance].curUserInfo.userinfo.isOwner = @"0";
                [MSUserManager sharedInstance].curUserInfo.userinfo.name = strongSelf.shName.text;
                [MSUserManager sharedInstance].curUserInfo.userinfo.sex = [NSString stringWithFormat:@"%ld",(long)strongSelf.shSexBtn.tag];
            }else if (strongSelf.accRole == 2){
                [MSUserManager sharedInstance].curUserInfo.userinfo.accRole = @"13";
                [MSUserManager sharedInstance].curUserInfo.userinfo.isStaff = @"0";
                [MSUserManager sharedInstance].curUserInfo.userinfo.isOwner = @"1";
                [MSUserManager sharedInstance].curUserInfo.userinfo.name = strongSelf.shName.text;
                [MSUserManager sharedInstance].curUserInfo.userinfo.sex = [NSString stringWithFormat:@"%ld",(long)strongSelf.shSexBtn.tag];
                [MSUserManager sharedInstance].curUserInfo.userinfo.cardNo = strongSelf.otIdCard.text;
            }else{
                [MSUserManager sharedInstance].curUserInfo.userinfo.accRole = @"13";
                [MSUserManager sharedInstance].curUserInfo.userinfo.isStaff = @"1";
                [MSUserManager sharedInstance].curUserInfo.userinfo.isOwner = @"0";
                [MSUserManager sharedInstance].curUserInfo.userinfo.name = strongSelf.shName.text;
                [MSUserManager sharedInstance].curUserInfo.userinfo.sex = [NSString stringWithFormat:@"%ld",(long)strongSelf.shSexBtn.tag];
                [MSUserManager sharedInstance].curUserInfo.userinfo.cardNo = strongSelf.otIdCard.text;
            }
            [[MSUserManager sharedInstance] saveUserInfo];
            
            HXTabBarController *tabBarController = [[HXTabBarController alloc] init];
            [UIApplication sharedApplication].keyWindow.rootViewController = tabBarController;
            
            //推出主界面出来
            CATransition *ca = [CATransition animation];
            ca.type = @"movein";
            ca.duration = 0.5;
            [[UIApplication sharedApplication].keyWindow.layer addAnimation:ca forKey:nil];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [sender stopLoading:@"确认" image:nil textColor:nil backgroundColor:nil];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
@end
