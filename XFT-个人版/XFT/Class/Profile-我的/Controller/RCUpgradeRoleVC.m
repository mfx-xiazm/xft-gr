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
@property (weak, nonatomic) IBOutlet UIView *roleInfoView0;
@property (weak, nonatomic) IBOutlet UIImageView *shTagImg;
@property (weak, nonatomic) IBOutlet UIImageView *yzTagImg;
@property (weak, nonatomic) IBOutlet UIImageView *ygTagImg;

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
}

- (IBAction)clientSexClicked:(UIButton *)sender {
    self.sexBtn.selected = NO;
    self.sexBtn.boderColor = UIColorFromRGB(0xCCCCCC);
    sender.selected = YES;
    sender.boderColor = UIColorFromRGB(0x666666);
    self.sexBtn = sender;
}

@end
