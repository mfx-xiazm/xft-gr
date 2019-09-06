//
//  RCChangeInfoVC.m
//  XFT
//
//  Created by 夏增明 on 2019/8/28.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCChangeInfoVC.h"

@interface RCChangeInfoVC ()

@end

@implementation RCChangeInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"我的信息"];
    
    [self setUpNavBar];
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
    [self.navigationController popViewControllerAnimated:YES];
}
@end
