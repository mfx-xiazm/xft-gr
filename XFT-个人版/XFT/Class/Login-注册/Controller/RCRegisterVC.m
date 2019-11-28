//
//  RCRegisterVC.m
//  XFT
//
//  Created by 夏增明 on 2019/8/26.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCRegisterVC.h"
#import "UITextField+GYExpand.h"
#import "FSActionSheet.h"

@interface RCRegisterVC ()<FSActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *roleType;
@property (weak, nonatomic) IBOutlet UITextField *idType;
@property (weak, nonatomic) IBOutlet UITextField *idCode;
@property (weak, nonatomic) IBOutlet UITextField *code;
@property (weak, nonatomic) IBOutlet UIView *linceView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *linceViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@end
@implementation RCRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    hx_weakify(self);
    [self.registerBtn BindingBtnJudgeBlock:^BOOL{
        hx_strongify(weakSelf);
        if (![strongSelf.phone hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入手机号"];
            return NO;
        }
        if (strongSelf.phone.text.length != 11) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"手机格式有误"];
            return NO;
        }
        if (![strongSelf.roleType hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请选择注册身份"];
            return NO;
        }
        if (![strongSelf.roleType.text isEqualToString:@"客户"]) {
            if (![strongSelf.idType hasText]) {
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请选择证件类型"];
                return NO;
            }
            if (![strongSelf.idCode hasText]) {
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入证件号码"];
                return NO;
            }
        }
        if (![strongSelf.code hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入验证码"];
            return NO;
        }
        return YES;
    } ActionBlock:^(UIButton * _Nullable button) {
        hx_strongify(weakSelf);
        [strongSelf registerHandleClicked:button];
    }];

    [self.phone lengthLimit:^{
        hx_strongify(weakSelf);
        if (strongSelf.phone.text.length > 11) {
            strongSelf.phone.text = [strongSelf.phone.text substringToIndex:11];
        }
    }];
}
- (IBAction)registerHandleClicked:(UIButton *)sender {
    hx_weakify(self);
    if (sender.tag == 1) {
        NSArray *roles = @[@"注册为客户随便看看",@"业主经纪人",@"员工经纪人",@"普通经纪人"];
        FSActionSheet *sheet = [[FSActionSheet alloc] initWithTitle:@"身份类型" delegate:self currentButtonTitle:[self.roleType hasText]?self.roleType.text:@"" cancelButtonTitle:@"取消" highlightedButtonTitle:nil otherButtonTitles:roles];
        [sheet showWithSelectedCompletion:^(NSInteger selectedIndex) {
            hx_strongify(weakSelf);
            if (selectedIndex == 0) {
                strongSelf.roleType.text = @"客户";
                strongSelf.linceView.hidden = YES;
                strongSelf.linceViewHeight.constant = 0;
            }else{
                strongSelf.roleType.text = roles[selectedIndex];
                strongSelf.linceView.hidden = NO;
                strongSelf.linceViewHeight.constant = 100;
            }
        }];
    }else if (sender.tag == 2) {
        FSActionSheet *sheet = [[FSActionSheet alloc] initWithTitle:@"证件类型" delegate:self currentButtonTitle:[self.idType hasText]?self.idType.text:@""  cancelButtonTitle:@"取消" highlightedButtonTitle:nil otherButtonTitles:@[@"身份证"]];
        [sheet showWithSelectedCompletion:^(NSInteger selectedIndex) {
            hx_strongify(weakSelf);
            strongSelf.idType.text = @"身份证";
        }];
    }else if (sender.tag == 3) {
        if (![self.phone hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入手机号"];
            return;
        }
        if (self.phone.text.length != 11) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"手机格式有误"];
            return;
        }
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        NSMutableDictionary *data = [NSMutableDictionary dictionary];
        data[@"phone"] = self.phone.text;
        data[@"type"] = @"1";// 类型1:注册,2登录
        
        parameters[@"data"] = data;
        
        [HXNetworkTool POST:HXRC_M_URL action:@"sys/sys/personalReg/personalSendSms" parameters:parameters success:^(id responseObject) {
            if ([responseObject[@"code"] integerValue] == 0) {
                [sender startWithTime:59 title:@"验证码" countDownTitle:@"s" mainColor:[UIColor whiteColor] countColor:[UIColor whiteColor]];
            }else{
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
        }];
    }else{
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        NSMutableDictionary *data = [NSMutableDictionary dictionary];
        data[@"phone"] = self.phone.text;
        data[@"code"] = self.code.text;
        // 注册身份类型 1 业主经纪人 2 员工经纪人 3普通经济人 4注册成为客户随便看看
        if ([self.roleType.text isEqualToString:@"客户"]) {
            data[@"idType"] = @"4";
        }else{
            if ([self.roleType.text isEqualToString:@"业主经纪人"]) {
                data[@"idType"] = @"1";
            }else if ([self.roleType.text isEqualToString:@"员工经纪人"]) {
                data[@"idType"] = @"2";
            }else{
                data[@"idType"] = @"3";
            }
            data[@"idCardType"] = @"1";
            data[@"idCardCode"] = self.idCode.text;
        }

        parameters[@"data"] = data;
        
        [HXNetworkTool POST:HXRC_M_URL action:@"sso/sso/auth/loginPersonalRegisterApp" parameters:parameters success:^(id responseObject) {
            hx_strongify(weakSelf);
            [sender stopLoading:@"注册" image:nil textColor:nil backgroundColor:nil];
            if ([responseObject[@"code"] integerValue] == 0) {
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
                [strongSelf.navigationController popViewControllerAnimated:YES];
            }else{
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
            }
        } failure:^(NSError *error) {
            [sender stopLoading:@"注册" image:nil textColor:nil backgroundColor:nil];
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
        }];
    }
}

@end
