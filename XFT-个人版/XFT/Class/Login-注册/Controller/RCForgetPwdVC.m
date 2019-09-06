//
//  RCForgetPwdVC.m
//  XFT
//
//  Created by 夏增明 on 2019/8/26.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCForgetPwdVC.h"

@implementation RCForgetPwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)ForgetHandleClicked:(UIButton *)sender {
    if (sender.tag == 1) {
        [sender startWithTime:60 title:@"验证码" countDownTitle:@"s" mainColor:[UIColor whiteColor] countColor:[UIColor whiteColor]];
    }else{
        HXLog(@"注册");
    }
}
@end
