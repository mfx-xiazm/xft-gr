//
//  RCHouseAppointVC.m
//  XFT
//
//  Created by 夏增明 on 2019/8/29.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCHouseAppointVC.h"
#import "WSDatePickerView.h"
#import "UITextField+GYExpand.h"

@interface RCHouseAppointVC ()
/* 上一次选择的性别 */
@property(nonatomic,strong) UIButton *sexBtn;
@property (weak, nonatomic) IBOutlet UITextField *appointDate;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UIButton *appointBtn;
@property(nonatomic,assign) NSInteger arriveTime;

@end

@implementation RCHouseAppointVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"预约看房"];
    
    hx_weakify(self);
    [self.phone lengthLimit:^{
        hx_strongify(weakSelf);
        if (strongSelf.phone.text.length >11) {
            strongSelf.phone.text = [strongSelf.phone.text substringToIndex:11];
        }
    }];
    
    self.phone.text = [MSUserManager sharedInstance].curUserInfo.userinfo.regPhone;
    
    [self.appointBtn BindingBtnJudgeBlock:^BOOL{
        hx_strongify(weakSelf);
        if (![strongSelf.name hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入姓名"];
            return NO;
        }
//        if (![strongSelf.phone hasText]) {
//            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入电话"];
//            return NO;
//        }
//        if (strongSelf.phone.text.length !=11) {
//            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"电话格式有误"];
//            return NO;
//        }
        if (![strongSelf.appointDate hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请选择预约日期"];
            return NO;
        }
        return YES;
    } ActionBlock:^(UIButton * _Nullable button) {
        hx_strongify(weakSelf);
        [strongSelf submittAppointRequest:button];
    }];
}
- (IBAction)clientSexClicked:(UIButton *)sender {
    self.sexBtn.selected = NO;
    self.sexBtn.boderColor = UIColorFromRGB(0xCCCCCC);
    sender.selected = YES;
    sender.boderColor = UIColorFromRGB(0x666666);
    self.sexBtn = sender;
}
- (IBAction)appointTimeClicked:(UIButton *)sender {
    hx_weakify(self);
    //年-月-日
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay CompleteBlock:^(NSDate *selectDate) {
        
        NSString *dateString = [selectDate stringWithFormat:@"yyyy-MM-dd"];
        weakSelf.appointDate.text = dateString;
       
        weakSelf.arriveTime = [selectDate timeIntervalSince1970];
    }];
    datepicker.minLimitDate = [NSDate date];
    datepicker.dateLabelColor = HXControlBg;//年-月-日 颜色
    datepicker.datePickerColor = [UIColor blackColor];//滚轮日期颜色
    datepicker.doneButtonColor = HXControlBg;//确定按钮的颜色
    [datepicker show];
}
-(void)submittAppointRequest:(UIButton *)btn
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"arriveTime"] = @(self.arriveTime);
    data[@"name"] = self.name.text;
    data[@"productUuid"] = self.productUuid;
    data[@"reqPhone"] = self.phone.text;

    parameters[@"data"] = data;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"cus/cus/cusseehouse/bookHouse" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [btn stopLoading:@"预约" image:nil textColor:nil backgroundColor:nil];
        if ([responseObject[@"code"] integerValue] == 0) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [btn stopLoading:@"预约" image:nil textColor:nil backgroundColor:nil];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
@end
