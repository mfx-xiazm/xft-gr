//
//  RCHouseLoanVC.m
//  XFT
//
//  Created by 夏增明 on 2019/8/30.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCHouseLoanVC.h"
#import "RCLoanDetailVC.h"
#import "ZJPickerView.h"
#import "RCLoanListVC.h"

@interface RCHouseLoanVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
@property (weak, nonatomic) IBOutlet UILabel *savedNum;
/** 商业贷款 */
@property (weak, nonatomic) IBOutlet UIView *busnessView;
@property (weak, nonatomic) IBOutlet UITextField *b_total;
@property (weak, nonatomic) IBOutlet UITextField *b_scale;
@property (weak, nonatomic) IBOutlet UITextField *b_year;
@property(nonatomic,assign) NSInteger b_yearNum;//还款年限
@property (weak, nonatomic) IBOutlet UITextField *b_rate;
@property (weak, nonatomic) IBOutlet UITextField *b_type;
@property(nonatomic,assign) NSInteger b_typeNum;//还款方式
/** 公积金贷款 */
@property (weak, nonatomic) IBOutlet UIView *fundView;
@property (weak, nonatomic) IBOutlet UITextField *f_total;
@property (weak, nonatomic) IBOutlet UITextField *f_scale;
@property (weak, nonatomic) IBOutlet UITextField *f_year;
@property(nonatomic,assign) NSInteger f_yearNum;//还款年限
@property (weak, nonatomic) IBOutlet UITextField *f_rate;
@property (weak, nonatomic) IBOutlet UITextField *f_type;
@property(nonatomic,assign) NSInteger f_typeNum;//还款方式
/** 混合贷款 */
@property (weak, nonatomic) IBOutlet UIView *mixtureView;
@property (weak, nonatomic) IBOutlet UITextField *mb_total;
@property (weak, nonatomic) IBOutlet UITextField *mb_year;
@property(nonatomic,assign) NSInteger mb_yearNum;//还款年限
@property (weak, nonatomic) IBOutlet UITextField *mb_rate;
@property (weak, nonatomic) IBOutlet UITextField *mf_total;
@property (weak, nonatomic) IBOutlet UITextField *mf_year;
@property(nonatomic,assign) NSInteger mf_yearNum;//还款年限
@property (weak, nonatomic) IBOutlet UITextField *mf_rate;
@property (weak, nonatomic) IBOutlet UITextField *m_type;
@property(nonatomic,assign) NSInteger m_typeNum;//还款方式
/* 上一次选择的按钮 */
@property(nonatomic,strong) UIButton *lastBtn;
@end

@implementation RCHouseLoanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"房贷计算器"];
    self.lastBtn = self.firstBtn;
    
    self.busnessView.hidden = NO;
    self.fundView.hidden = YES;
    self.mixtureView.hidden = YES;
    
    self.b_total.delegate = self;
    self.b_scale.delegate = self;
    self.b_rate.delegate = self;
    
    self.f_total.delegate = self;
    self.f_scale.delegate = self;
    self.f_rate.delegate = self;
    
    self.mf_total.delegate = self;
    self.mf_rate.delegate = self;
    
    self.mb_total.delegate = self;
    self.mb_rate.delegate = self;
    
    self.b_yearNum = 30;
    self.b_typeNum = 1;
    
    self.f_yearNum = 30;
    self.f_typeNum = 1;
    
    self.mb_yearNum = 30;
    self.mf_yearNum = 30;
    self.m_typeNum = 1;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getNumDataRequest];
}
#pragma mark -- 请求已保存的数量
-(void)getNumDataRequest
{
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"sys/sys/agent/myIndexNum" parameters:@{} success:^(id responseObject) {
        hx_strongify(weakSelf);
        if ([responseObject[@"code"] integerValue] == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.savedNum.text = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"mortgageNUM"]];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
#pragma mark -- 点击事件
- (IBAction)savedListClicked:(UIButton *)sender {
    RCLoanListVC *lvc = [RCLoanListVC new];
    [self.navigationController pushViewController:lvc animated:YES];
}

- (IBAction)loanTypeClicked:(UIButton *)sender {
    self.lastBtn.selected = NO;
    sender.selected = YES;
    self.lastBtn = sender;
    
    if (sender.tag == 1) {
        self.busnessView.hidden = NO;
        self.fundView.hidden = YES;
        self.mixtureView.hidden = YES;
    }else if (sender.tag == 2) {
        self.busnessView.hidden = YES;
        self.fundView.hidden = NO;
        self.mixtureView.hidden = YES;
    }else{
        self.busnessView.hidden = YES;
        self.fundView.hidden = YES;
        self.mixtureView.hidden = NO;
    }
}
- (IBAction)loanYearClicked:(UIButton *)sender {
    NSString *textKey = nil;
    if (sender.tag == 1) {
        textKey = self.b_year.text;
    }else if (sender.tag == 2) {
        textKey = self.f_year.text;
    }else if (sender.tag == 3) {
        textKey = self.mb_year.text;
    }else{
        textKey = self.mf_year.text;
    }
    // 1.Custom propery（自定义属性）
    NSDictionary *propertyDict = @{
                                   ZJPickerViewPropertyCanceBtnTitleKey : @"取消",
                                   ZJPickerViewPropertySureBtnTitleKey  : @"确定",
                                   ZJPickerViewPropertyTipLabelTextKey  : (textKey&&textKey.length)?textKey:@"选择贷款年限", // 提示内容
                                   ZJPickerViewPropertyCanceBtnTitleColorKey : UIColorFromRGB(0xA9A9A9),
                                   ZJPickerViewPropertySureBtnTitleColorKey : UIColorFromRGB(0x232323),
                                   ZJPickerViewPropertyTipLabelTextColorKey :
                                       UIColorFromRGB(0x131D2D),
                                   ZJPickerViewPropertyLineViewBackgroundColorKey : UIColorFromRGB(0xdedede),
                                   ZJPickerViewPropertyCanceBtnTitleFontKey : [UIFont systemFontOfSize:15.0f],
                                   ZJPickerViewPropertySureBtnTitleFontKey : [UIFont systemFontOfSize:15.0f],
                                   ZJPickerViewPropertyTipLabelTextFontKey : [UIFont systemFontOfSize:15.0f],
                                   ZJPickerViewPropertyPickerViewHeightKey : @260.0f,
                                   ZJPickerViewPropertyOneComponentRowHeightKey : @40.0f,
                                   ZJPickerViewPropertySelectRowTitleAttrKey : @{NSForegroundColorAttributeName : UIColorFromRGB(0x131D2D), NSFontAttributeName : [UIFont systemFontOfSize:20.0f]},
                                   ZJPickerViewPropertyUnSelectRowTitleAttrKey : @{NSForegroundColorAttributeName : UIColorFromRGB(0xA9A9A9), NSFontAttributeName : [UIFont systemFontOfSize:20.0f]},
                                   ZJPickerViewPropertySelectRowLineBackgroundColorKey : UIColorFromRGB(0xdedede),
                                   ZJPickerViewPropertyIsTouchBackgroundHideKey : @YES,
                                   ZJPickerViewPropertyIsShowSelectContentKey : @YES,
                                   ZJPickerViewPropertyIsScrollToSelectedRowKey: @YES,
                                   ZJPickerViewPropertyIsAnimationShowKey : @YES};
    
    // 2.Show（显示）
    hx_weakify(self);
    [ZJPickerView zj_showWithDataList:@[@"1年",@"2年",@"3年",@"4年",@"5年",@"6年",@"7年",@"8年",@"9年",@"10年",@"11年",@"12年",@"13年",@"14年",@"15年",@"16年",@"17年",@"18年",@"19年",@"20年",@"21年",@"22年",@"23年",@"24年",@"25年",@"26年",@"27年",@"28年",@"29年",@"30年"] propertyDict:propertyDict completion:^(NSString *selectContent) {
        hx_strongify(weakSelf);
        // show select content|
        NSArray *results = [selectContent componentsSeparatedByString:@"|"];

        NSArray *years = [results.firstObject componentsSeparatedByString:@","];

        NSArray *rows = [results.lastObject componentsSeparatedByString:@","];
        
        if (sender.tag == 1) {
            strongSelf.b_year.text = years.firstObject;
            strongSelf.b_yearNum = [rows.firstObject integerValue]+1;
        }else if (sender.tag == 2) {
            strongSelf.f_year.text = years.firstObject;
            strongSelf.f_yearNum = [rows.firstObject integerValue]+1;
        }else if (sender.tag == 3) {
            strongSelf.mb_year.text = years.firstObject;
            strongSelf.mb_yearNum = [rows.firstObject integerValue]+1;
        }else{
            strongSelf.mf_year.text = years.firstObject;
            strongSelf.mf_yearNum = [rows.firstObject integerValue]+1;
        }
    }];
}
- (IBAction)loanBackTypeClicked:(UIButton *)sender {
    NSString *textKey = nil;
    if (sender.tag == 1) {
        textKey = self.b_type.text;
    }else if (sender.tag == 2) {
        textKey = self.f_type.text;
    }else{
        textKey = self.m_type.text;
    }
    // 1.Custom propery（自定义属性）
    NSDictionary *propertyDict = @{
                                   ZJPickerViewPropertyCanceBtnTitleKey : @"取消",
                                   ZJPickerViewPropertySureBtnTitleKey  : @"确定",
                                   ZJPickerViewPropertyTipLabelTextKey  : (textKey&&textKey.length)?textKey:@"选择款款方式", // 提示内容
                                   ZJPickerViewPropertyCanceBtnTitleColorKey : UIColorFromRGB(0xA9A9A9),
                                   ZJPickerViewPropertySureBtnTitleColorKey : UIColorFromRGB(0x232323),
                                   ZJPickerViewPropertyTipLabelTextColorKey :
                                       UIColorFromRGB(0x131D2D),
                                   ZJPickerViewPropertyLineViewBackgroundColorKey : UIColorFromRGB(0xdedede),
                                   ZJPickerViewPropertyCanceBtnTitleFontKey : [UIFont systemFontOfSize:15.0f],
                                   ZJPickerViewPropertySureBtnTitleFontKey : [UIFont systemFontOfSize:15.0f],
                                   ZJPickerViewPropertyTipLabelTextFontKey : [UIFont systemFontOfSize:15.0f],
                                   ZJPickerViewPropertyPickerViewHeightKey : @260.0f,
                                   ZJPickerViewPropertyOneComponentRowHeightKey : @40.0f,
                                   ZJPickerViewPropertySelectRowTitleAttrKey : @{NSForegroundColorAttributeName : UIColorFromRGB(0x131D2D), NSFontAttributeName : [UIFont systemFontOfSize:20.0f]},
                                   ZJPickerViewPropertyUnSelectRowTitleAttrKey : @{NSForegroundColorAttributeName : UIColorFromRGB(0xA9A9A9), NSFontAttributeName : [UIFont systemFontOfSize:20.0f]},
                                   ZJPickerViewPropertySelectRowLineBackgroundColorKey : UIColorFromRGB(0xdedede),
                                   ZJPickerViewPropertyIsTouchBackgroundHideKey : @YES,
                                   ZJPickerViewPropertyIsShowSelectContentKey : @YES,
                                   ZJPickerViewPropertyIsScrollToSelectedRowKey: @YES,
                                   ZJPickerViewPropertyIsAnimationShowKey : @YES};
    
    // 2.Show（显示）
    hx_weakify(self);
    [ZJPickerView zj_showWithDataList:@[@"等额本息",@"等额本金"] propertyDict:propertyDict completion:^(NSString *selectContent) {
        hx_strongify(weakSelf);
        // show select content|
        NSArray *results = [selectContent componentsSeparatedByString:@"|"];

        NSArray *years = [results.firstObject componentsSeparatedByString:@","];

        NSArray *rows = [results.lastObject componentsSeparatedByString:@","];
        
        if (sender.tag == 1) {
            strongSelf.b_type.text = years.firstObject;
            strongSelf.b_typeNum = [rows.firstObject integerValue]+1;
        }else if (sender.tag == 2) {
            strongSelf.f_type.text = years.firstObject;
            strongSelf.f_typeNum = [rows.firstObject integerValue]+1;
        }else{
            strongSelf.m_type.text = years.firstObject;
            strongSelf.m_typeNum = [rows.firstObject integerValue]+1;
        }
    }];
}

- (IBAction)loanDetailClicked:(UIButton *)sender {
    
    if (self.lastBtn.tag == 1) {
        if (![self.b_total hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入房源总价"];
            return;
        }
        if (![self.b_scale hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入贷款比例"];
            return;
        }
        if ([self.b_scale.text floatValue] > 10.0) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"贷款比例不能大于10"];
            return;
        }
        if (![self.b_rate hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入贷款利率"];
            return;
        }
    }else if (self.lastBtn.tag == 2) {
        if (![self.f_total hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入房源总价"];
            return;
        }
        if (![self.f_scale hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入贷款比例"];
            return;
        }
        if ([self.f_scale.text floatValue] > 10.0) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"贷款比例不能大于10"];
            return;
        }
        if (![self.f_rate hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入贷款利率"];
            return;
        }
    }else{
        if (![self.mb_total hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入商业贷款金额"];
            return;
        }
        if (![self.mb_rate hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入商业贷款利率"];
            return;
        }
        if (![self.mf_total hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入公积金贷款金额"];
            return;
        }
        if (![self.mf_rate hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入公积金贷款利率"];
            return;
        }
    }
    
    RCLoanDetailVC *dvc = [RCLoanDetailVC new];
    if (self.lastBtn.tag == 1) {
        dvc.loanType = 1;
        dvc.b_total = self.b_total.text;
        dvc.b_scale = self.b_scale.text;
        dvc.b_year = self.b_year.text;
        dvc.b_yearNum = self.b_yearNum;//还款年限
        dvc.b_rate = self.b_rate.text;
        dvc.b_type = self.b_type.text;
        dvc.b_typeNum = self.b_typeNum;//还款方式
    }else if (self.lastBtn.tag == 2) {
        dvc.loanType = 2;
        dvc.f_total = self.f_total.text;
        dvc.f_scale = self.f_scale.text;
        dvc.f_year = self.f_year.text;
        dvc.f_yearNum = self.f_yearNum;//还款年限
        dvc.f_rate = self.f_rate.text;
        dvc.f_type = self.f_type.text;
        dvc.f_typeNum = self.f_typeNum;//还款方式
    }else{
        dvc.loanType = 3;
        dvc.mb_total = self.mb_total.text;
        dvc.mb_year = self.mb_year.text;
        dvc.mb_yearNum = self.mb_yearNum;//还款年限
        dvc.mb_rate = self.mb_rate.text;
        dvc.mf_total = self.mf_total.text;
        dvc.mf_year = self.mf_year.text;
        dvc.mf_yearNum = self.mf_yearNum;//还款年限
        dvc.mf_rate = self.mf_rate.text;
        dvc.m_type = self.m_type.text;
        dvc.m_typeNum = self.m_typeNum;//还款方式
    }
    if (self.proName && self.proName.length) {
        dvc.proName = self.proName;
        dvc.hxName = self.hxName;
        dvc.buldArea = self.buldArea;
        dvc.roomArea = self.roomArea;
        dvc.hxUuid = self.hxUuid;
    }
    [self.navigationController pushViewController:dvc animated:YES];
}
#pragma mark -- UITextField代理 校验数字规则
//参数一：range，要被替换的字符串的range，如果是新输入的，就没有字符串被替换，range.length = 0
//参数二：替换的字符串，即键盘即将输入或者即将粘贴到textField的string
//返回值为BOOL类型，YES表示允许替换，NO表示不允许
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    //新输入的
    if (string.length == 0) {
        return YES;
    }

   //第一个参数，被替换字符串的range
   //第二个参数，即将键入或者粘贴的string
   //返回的是改变过后的新str，即textfield的新的文本内容
    NSString *checkStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
   if (checkStr.length > 0) {
       if ([checkStr doubleValue] == 0) {
         //判断首位不能为零
           return NO;
       }
   }
    
    if (textField == self.b_scale || textField == self.b_rate || textField == self.f_scale || textField == self.f_rate || textField == self.mf_rate || textField == self.mb_rate) {
        //正则表达式（只支持两位小数）
        NSString *regex = @"^\\-?([1-9]\\d*|0)(\\.\\d{0,2})?$";
        //判断新的文本内容是否符合要求
        return [self isValid:checkStr withRegex:regex];
    }else{
        // 限制只能输入数字
        NSCharacterSet *charSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
        
        NSString *filteredStr = [[checkStr componentsSeparatedByCharactersInSet:charSet] componentsJoinedByString:@""];
        if ([checkStr isEqualToString:filteredStr]) {
            return YES;
        }
        return NO;
    }
}

//检测改变过的文本是否匹配正则表达式，如果匹配表示可以键入，否则不能键入
- (BOOL) isValid:(NSString*)checkStr withRegex:(NSString*)regex
{
    NSPredicate *predicte = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicte evaluateWithObject:checkStr];
}
@end
