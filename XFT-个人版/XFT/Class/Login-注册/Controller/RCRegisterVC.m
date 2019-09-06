//
//  RCRegisterVC.m
//  XFT
//
//  Created by 夏增明 on 2019/8/26.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCRegisterVC.h"
#import "FSActionSheet.h"

@interface RCRegisterVC ()<FSActionSheetDelegate>

@end
@implementation RCRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (IBAction)registerHandleClicked:(UIButton *)sender {
    if (sender.tag == 1) {
        FSActionSheet *sheet = [[FSActionSheet alloc] initWithTitle:@"身份类型" delegate:self cancelButtonTitle:@"取消" highlightedButtonTitle:nil otherButtonTitles:@[@"注册为客户随便看看",@"业主经纪人",@"员工经纪人",@"普通经纪人"]];
        [sheet showWithSelectedCompletion:^(NSInteger selectedIndex) {
            HXLog(@"身份-%zd",selectedIndex);
        }];
    }else if (sender.tag == 2) {
        [sender startWithTime:60 title:@"验证码" countDownTitle:@"s" mainColor:[UIColor whiteColor] countColor:[UIColor whiteColor]];
    }else{
        HXLog(@"注册");
    }
}

@end
