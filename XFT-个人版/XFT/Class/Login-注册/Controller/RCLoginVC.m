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

@interface RCLoginVC ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *agreeMentTV;
@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet UIView *pwdView;

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
    
    [self setAgreeMentProtocol];
}

-(void)setAgreeMentProtocol
{
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
- (IBAction)loginTypeClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.isSelected) {
        self.codeView.hidden = NO;
        self.pwdView.hidden = YES;
    }else{
        self.codeView.hidden = YES;
        self.pwdView.hidden = NO;
    }
}
- (IBAction)getCodeClicked:(UIButton *)sender {
    [sender startWithTime:60 title:@"验证码" countDownTitle:@"s" mainColor:[UIColor whiteColor] countColor:[UIColor whiteColor]];
}

- (IBAction)loginHandleClicked:(UIButton *)sender {
    if (sender.tag == 1) {
        RCForgetPwdVC *pvc = [RCForgetPwdVC new];
        [self.navigationController pushViewController:pvc animated:YES];
    }else if (sender.tag == 2) {
        HXTabBarController *tabBarController = [[HXTabBarController alloc] init];
        [UIApplication sharedApplication].keyWindow.rootViewController = tabBarController;
        
        //推出主界面出来
        CATransition *ca = [CATransition animation];
        ca.type = @"movein";
        ca.duration = 0.5;
        [[UIApplication sharedApplication].keyWindow.layer addAnimation:ca forKey:nil];
    }else if (sender.tag == 3) {
        RCRegisterVC *rvc = [RCRegisterVC new];
        [self.navigationController pushViewController:rvc animated:YES];
    }else{
        
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
