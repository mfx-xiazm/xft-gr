//
//  RCFeedbackVC.m
//  XFT
//
//  Created by 夏增明 on 2019/8/29.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCFeedbackVC.h"
#import "HXPlaceholderTextView.h"
#import "HCSStarRatingView.h"

@interface RCFeedbackVC ()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIView *remarkView;
@property (strong, nonatomic) HXPlaceholderTextView *remark;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *starView;
@property (weak, nonatomic) IBOutlet UIButton *hiddenNameBtn;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@end

@implementation RCFeedbackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"意见反馈"];
    self.remark = [[HXPlaceholderTextView alloc] initWithFrame:self.remarkView.bounds];
    self.remark.backgroundColor = UIColorFromRGB(0xF6F7FB);
    self.remark.placeholder = @"请输入意见和建议";
    [self.remarkView addSubview:self.remark];
    
    if ([MSUserManager sharedInstance].isLogined) {
        self.name.text = [NSString stringWithFormat:@"%@，您好，请您留下您的宝贵意见。",([MSUserManager sharedInstance].curUserInfo.userinfo.name&& [MSUserManager sharedInstance].curUserInfo.userinfo.name.length)?[MSUserManager sharedInstance].curUserInfo.userinfo.name:[MSUserManager sharedInstance].curUserInfo.userinfo.nick];
    }else{
        self.name.text = @"游客，您好，请您留下您的宝贵意见。";
    }
    
    hx_weakify(self);
    [self.submitBtn BindingBtnJudgeBlock:^BOOL{
        hx_strongify(weakSelf);
        if (strongSelf.starView.value == 0) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请做出星级评价"];
            return NO;
        }
        if (![strongSelf.remark hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请留下对我们产品的意见"];
            return NO;
        }
        return YES;
    } ActionBlock:^(UIButton * _Nullable button) {
        hx_strongify(weakSelf);
        [strongSelf submitIdeaRequest:button];
    }];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.remark.frame = self.remarkView.bounds;
}
- (IBAction)hiddenSubmitClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
}
-(void)submitIdeaRequest:(UIButton *)sender
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"num"] = @(self.starView.value);//星级数
    data[@"viewOpinion"] = self.remark.text;//反馈意见
    data[@"anonymous"] = self.hiddenNameBtn.isSelected?@"1":@"0";//是否匿名 1是 0否
    parameters[@"data"] = data;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"sys/sys/back/feedback" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [sender stopLoading:@"提交评论" image:nil textColor:nil backgroundColor:nil];
        if ([responseObject[@"code"] integerValue] == 0) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"提交成功"];
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [sender stopLoading:@"提交评论" image:nil textColor:nil backgroundColor:nil];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
@end
