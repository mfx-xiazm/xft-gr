//
//  RCUpgradeRoleVC.m
//  XFT
//
//  Created by 夏增明 on 2019/8/29.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCUpgradeRoleVC.h"

@interface RCUpgradeRoleVC ()
@property (weak, nonatomic) IBOutlet UIView *roleInfoView;
/* 上一次选择的性别 */
@property(nonatomic,strong) UIButton *sexBtn;
@end

@implementation RCUpgradeRoleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"成为经纪人"];
}

- (IBAction)roleTypeCliked:(UIButton *)sender {
    if (sender.tag == 1) {
        self.roleInfoView.hidden = YES;
    }else{
        self.roleInfoView.hidden = NO;
    }
}

- (IBAction)clientSexClicked:(UIButton *)sender {
    self.sexBtn.selected = NO;
    self.sexBtn.boderColor = UIColorFromRGB(0xCCCCCC);
    sender.selected = YES;
    sender.boderColor = UIColorFromRGB(0x666666);
    self.sexBtn = sender;
}

@end
