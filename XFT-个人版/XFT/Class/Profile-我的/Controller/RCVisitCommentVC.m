//
//  RCVisitCommentVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/7.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCVisitCommentVC.h"
#import "HXPlaceholderTextView.h"
#import "HCSStarRatingView.h"

@interface RCVisitCommentVC ()

@property (weak, nonatomic) IBOutlet HCSStarRatingView *starView1;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *starView2;
@property (weak, nonatomic) IBOutlet UIView *remarkView;
@property (strong, nonatomic) HXPlaceholderTextView *remark;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@end

@implementation RCVisitCommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"回访调查表"];
    self.remark = [[HXPlaceholderTextView alloc] initWithFrame:self.remarkView.bounds];
    self.remark.backgroundColor = UIColorFromRGB(0xF6F7FB);
    self.remark.placeholder = @"请输入意见和建议";
    [self.remarkView addSubview:self.remark];
    
    hx_weakify(self);
    [self.submitBtn BindingBtnJudgeBlock:^BOOL{
        hx_strongify(weakSelf);
        if (![strongSelf.remark hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请留下对我们产品的意见"];
            return NO;
        }
        return YES;
    } ActionBlock:^(UIButton * _Nullable button) {
        hx_strongify(weakSelf);
        [strongSelf submitCusQuestionnaireRequest:button];
    }];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.remark.frame = self.remarkView.bounds;
}
-(void)submitCusQuestionnaireRequest:(UIButton *)sender
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"proUuid"] = self.proUuid;//项目uuid
    data[@"viewOpinion"] = self.remark.text;//反馈意见
    data[@"backTime"] = @"";//反馈时间
    data[@"createTime"] = @"";//创建时间
    data[@"editTime"] = @"";//修改时间
    data[@"num1"] = @(self.starView1.value);//星级问题1
    data[@"num2"] = @(self.starView2.value);//星级问题2
    data[@"num3"] = @"";//星级问题3
    data[@"num4"] = @"";//星级问题4
    
    parameters[@"data"] = data;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"cus/cus/cusquestionnaire/addCusQuestionnaire" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [sender stopLoading:@"提交评论" image:nil textColor:nil backgroundColor:nil];
        if ([responseObject[@"code"] integerValue] == 0) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"提交成功"];
            if (strongSelf.submitCall) {
                strongSelf.submitCall();
            }
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
