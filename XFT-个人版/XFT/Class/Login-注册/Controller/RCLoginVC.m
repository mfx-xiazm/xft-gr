//
//  RCLoginVC.m
//  XFT
//
//  Created by 夏增明 on 2019/8/26.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCLoginVC.h"
#import "RCWebContentVC.h"
#import "RCRegisterVC.h"
#import "RCForgetPwdVC.h"
#import "HXTabBarController.h"
#import "UITextField+GYExpand.h"

@interface RCLoginVC ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (weak, nonatomic) IBOutlet UIView *agreeMentView;
@property (strong, nonatomic) UITextView *agreeMentTV;
@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet UIView *pwdView;
@property (weak, nonatomic) IBOutlet UIView *accountView;
@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *code;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;

@end

@implementation RCLoginVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.backBtn.hidden = self.isInnerLogin?NO:YES;
    [self setAgreeMentProtocol];
    
    hx_weakify(self);
    [self.loginBtn BindingBtnJudgeBlock:^BOOL{
        hx_strongify(weakSelf);
        if (![strongSelf.phone hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入手机号"];
            return NO;
        }
        if (strongSelf.phone.text.length != 11) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"手机格式有误"];
            return NO;
        }
        if (![strongSelf.code hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入验证码"];
            return NO;
        }
        if (!self.agreeBtn.isSelected) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请阅读并同意《幸福通用户协议》和《幸福通隐私协议》"];
            return NO;
        }
        return YES;
    } ActionBlock:^(UIButton * _Nullable button) {
        hx_strongify(weakSelf);
        [strongSelf loginHandleClicked:button];
    }];

    [self.phone lengthLimit:^{
        hx_strongify(weakSelf);
        if (strongSelf.phone.text.length > 11) {
            strongSelf.phone.text = [strongSelf.phone.text substringToIndex:11];
        }
    }];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.agreeMentTV.frame = self.agreeMentView.bounds;
}
-(void)setAgreeMentProtocol
{
    self.agreeMentTV = [[UITextView alloc] initWithFrame:self.agreeMentView.bounds];
    [self.agreeMentView addSubview:self.agreeMentTV];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"已阅读并同意《幸福通用户协议》和《幸福通隐私协议》"];
    [attributedString addAttribute:NSLinkAttributeName value:@"yhxy://" range:[[attributedString string] rangeOfString:@"《幸福通用户协议》"]];
    [attributedString addAttribute:NSLinkAttributeName value:@"ysxy://" range:[[attributedString string] rangeOfString:@"《幸福通隐私协议》"]];
    [attributedString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x999999) range:NSMakeRange(0, attributedString.length)];
    
    _agreeMentTV.attributedText = attributedString;
    _agreeMentTV.linkTextAttributes = @{NSForegroundColorAttributeName: UIColorFromRGB(0x4C8FF7),NSUnderlineColorAttributeName: UIColorFromRGB(0x4C8FF7),NSUnderlineStyleAttributeName: @(NSUnderlinePatternSolid)};
    _agreeMentTV.delegate = self;
    _agreeMentTV.editable = NO;        //必须禁止输入，否则点击将弹出输入键盘
    _agreeMentTV.scrollEnabled = NO;
}
-(IBAction)backClicked
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)loginTypeClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.isSelected) {
        self.phoneView.hidden = NO;
        self.codeView.hidden = NO;
        self.pwdView.hidden = YES;
        self.accountView.hidden = YES;
    }else{
        self.phoneView.hidden = YES;
        self.codeView.hidden = YES;
        self.pwdView.hidden = NO;
        self.accountView.hidden = NO;
    }
}
- (IBAction)getCodeClicked:(UIButton *)sender {
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
    data[@"type"] = @"2";// 类型1:注册,2登录
    parameters[@"data"] = data;
    [MBProgressHUD showLoadToView:nil title:@"加载中..."];
    [HXNetworkTool POST:HXRC_M_URL action:@"sys/sys/personalReg/personalSendSms" parameters:parameters success:^(id responseObject) {
        [MBProgressHUD hideHUD];
        if ([responseObject[@"code"] integerValue] == 0) {
            [sender startWithTime:59 title:@"验证码" countDownTitle:@"s" mainColor:[UIColor whiteColor] countColor:[UIColor whiteColor]];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
- (IBAction)agreeBtnClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (IBAction)loginHandleClicked:(UIButton *)sender {
    if (sender.tag == 1) {
        RCForgetPwdVC *pvc = [RCForgetPwdVC new];
        [self.navigationController pushViewController:pvc animated:YES];
    }else if (sender.tag == 2) {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        NSMutableDictionary *data = [NSMutableDictionary dictionary];
        data[@"phone"] = self.phone.text;
        data[@"code"] = self.code.text;
        parameters[@"data"] = data;
        
        [HXNetworkTool POST:HXRC_M_URL action:@"sso/sso/auth/loginPersonalApp" parameters:parameters success:^(id responseObject) {
            [sender stopLoading:@"登录" image:nil textColor:nil backgroundColor:nil];
            if ([responseObject[@"code"] integerValue] == 0) {
                MSUserInfo *userInfo = [MSUserInfo yy_modelWithDictionary:responseObject[@"data"]];
                [MSUserManager sharedInstance].curUserInfo = userInfo;
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
            [sender stopLoading:@"登录" image:nil textColor:nil backgroundColor:nil];
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
        }];
    }else if (sender.tag == 3) {
        RCRegisterVC *rvc = [RCRegisterVC new];
        [self.navigationController pushViewController:rvc animated:YES];
    }else{
        MSUserInfo *userInfo = [[MSUserInfo alloc] init];
        MSShowUserInfo *showInfo = [[MSShowUserInfo alloc] init];
        showInfo.accRole = @"15";// 游客身份
        userInfo.userinfo = showInfo;
        [MSUserManager sharedInstance].curUserInfo = userInfo;
        [[MSUserManager sharedInstance] saveUserInfo];
        
        HXTabBarController *tabBarController = [[HXTabBarController alloc] init];
        [UIApplication sharedApplication].keyWindow.rootViewController = tabBarController;
        
        //推出主界面出来
        CATransition *ca = [CATransition animation];
        ca.type = @"movein";
        ca.duration = 0.5;
        [[UIApplication sharedApplication].keyWindow.layer addAnimation:ca forKey:nil];
    }
}
#pragma mark -- UITextView代理
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    if ([[URL scheme] isEqualToString:@"yhxy"]) {
        RCWebContentVC *wvc = [RCWebContentVC new];
        wvc.navTitle = @"幸福通用户协议";
        wvc.url = @"https://www.baidu.com/";
        [self.navigationController pushViewController:wvc animated:YES];
        return NO;
    }else if ([[URL scheme] isEqualToString:@"ysxy"]) {
        RCWebContentVC *wvc = [RCWebContentVC new];
        wvc.navTitle = @"幸福通隐私协议";
        wvc.url = @"https://www.baidu.com/";
        [self.navigationController pushViewController:wvc animated:YES];
        return NO;
    }
    return YES;
}

@end
