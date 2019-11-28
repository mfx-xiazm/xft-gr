//
//  RCBindCardVC.m
//  XFT
//
//  Created by 夏增明 on 2019/8/31.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCBindCardVC.h"
#import "UITextField+GYExpand.h"

@interface RCBindCardVC ()
@property (weak, nonatomic) IBOutlet UIView *authView;
@property (weak, nonatomic) IBOutlet UITextField *realName;
@property (weak, nonatomic) IBOutlet UITextField *cardNo;
@property (weak, nonatomic) IBOutlet UITextField *bankAccNo;
@property (weak, nonatomic) IBOutlet UITextField *bankPhone;
@property (weak, nonatomic) IBOutlet UIButton *sumitBtn;

@property (weak, nonatomic) IBOutlet UIView *authedView;
@property (weak, nonatomic) IBOutlet UILabel *realName1;
@property (weak, nonatomic) IBOutlet UILabel *cardNo1;
@property (weak, nonatomic) IBOutlet UILabel *bankAccNo1;
@property (weak, nonatomic) IBOutlet UILabel *bankPhone1;
@end

@implementation RCBindCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"实名认证"];
    [self startShimmer];
    [self realNameRequest:@"2" button:nil];
    
    hx_weakify(self);
    [self.bankPhone lengthLimit:^{
        hx_strongify(weakSelf);
        if (strongSelf.bankPhone.text.length >11) {
            strongSelf.bankPhone.text = [strongSelf.bankPhone.text substringToIndex:11];
        }
    }];
    
    [self.sumitBtn BindingBtnJudgeBlock:^BOOL{
        hx_strongify(weakSelf);
        if (![strongSelf.realName hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入真是姓名"];
            return NO;
        }
        if (![strongSelf.cardNo hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入身份证号"];
            return NO;
        }
        if (![strongSelf.cardNo.text judgeIdentityStringValid]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"身份证号有误"];
            return NO;
        }
        if (![strongSelf.bankAccNo hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入银行卡号"];
            return NO;
        }
        if (![strongSelf.bankPhone hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入预留手机号"];
            return NO;
        }
        if (strongSelf.bankPhone.text.length != 11) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"手机号格式有误"];
            return NO;
        }
        return YES;
    } ActionBlock:^(UIButton * _Nullable button) {
        hx_strongify(weakSelf);
        [strongSelf realNameRequest:@"1" button:button];
    }];
}

-(void)realNameRequest:(NSString *)type button:(UIButton *)sender
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    if ([type isEqualToString:@"2"]) {
        data[@"type"] = type;//类型 1:提交绑定,2:校验
    }else{
        data[@"type"] = type;//类型 1:提交绑定,2:校验
        data[@"realName"] = self.realName.text;
        data[@"cardNo"] = self.cardNo.text;
        data[@"bankAccNo"] = self.bankAccNo.text;
        data[@"bankPhone"] = self.bankPhone.text;
    }
    parameters[@"data"] = data;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"sso/sso/acclogin/saveRealName" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        [sender stopLoading:@"提交绑定" image:nil textColor:nil backgroundColor:nil];
        if ([responseObject[@"code"] integerValue] == 0) {
            if ([responseObject[@"data"][@"flag"] boolValue]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    strongSelf.authView.hidden = YES;
                    strongSelf.authedView.hidden = NO;
                    strongSelf.realName1.text = [NSString stringWithFormat:@"%@**",responseObject[@"data"][@"realName"]];
                    strongSelf.cardNo1.text = [NSString stringWithFormat:@"%@***********%@",[responseObject[@"data"][@"cardNo"] substringToIndex:4],[responseObject[@"data"][@"cardNo"] substringFromIndex:((NSString *)responseObject[@"data"][@"cardNo"]).length-4]];
                    strongSelf.bankAccNo1.text = [NSString stringWithFormat:@"%@***********%@",[responseObject[@"data"][@"bankAccNo"] substringToIndex:4],[responseObject[@"data"][@"bankAccNo"] substringFromIndex:((NSString *)responseObject[@"data"][@"bankAccNo"]).length-4]];
                    strongSelf.bankPhone1.text = [NSString stringWithFormat:@"%@****%@",[responseObject[@"data"][@"bankPhone"] substringToIndex:3],[responseObject[@"data"][@"bankPhone"] substringFromIndex:((NSString *)responseObject[@"data"][@"bankPhone"]).length-4]];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    strongSelf.authView.hidden = NO;
                    strongSelf.authedView.hidden = YES;
                });
            }
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        [sender stopLoading:@"提交绑定" image:nil textColor:nil backgroundColor:nil];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}

@end
