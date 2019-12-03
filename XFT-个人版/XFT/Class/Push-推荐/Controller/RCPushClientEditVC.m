//
//  RCPushClientEditVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/7.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCPushClientEditVC.h"
#import "RCAddPhoneCell.h"
#import "WSDatePickerView.h"
#import "HXPlaceholderTextView.h"
#import "RCHouseAdviserVC.h"
#import "RCHouseAdviser.h"
#import "RCReportTarget.h"
#import "ZJPickerView.h"
#import "zhAlertView.h"
#import <zhPopupController.h>
#import "RCReportResultVC.h"

static NSString *const AddPhoneCell = @"AddPhoneCell";

@interface RCPushClientEditVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate>
/* 名字 */
@property (weak, nonatomic) IBOutlet UITextField *name;
/* 电话 */
@property (weak, nonatomic) IBOutlet UITextField *phone;
/* 更多电话视图高度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *morePhoneViewHeight;
/* 更多电话视图 */
@property (weak, nonatomic) IBOutlet UITableView *morePhoneView;
/* 物业类型 */
@property (weak, nonatomic) IBOutlet UITextField *wuYeType;
/* 物业类型视图 */
@property (weak, nonatomic) IBOutlet UIView *wuYeView;
/* 物业类型视图高度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wuYeViewHeight;
/* 置业顾问 */
@property (weak, nonatomic) IBOutlet UITextField *saleMan;
/* 置业顾问视图 */
@property (weak, nonatomic) IBOutlet UIView *saleManView;
/* 置业顾问视图高度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *saleManViewHeight;
/* 预约看房日期 */
@property (weak, nonatomic) IBOutlet UITextField *appointDate;
/* 报备人身份 */
@property (weak, nonatomic) IBOutlet UITextField *reporterAccRole;
/* 客户备注 */
@property (weak, nonatomic) IBOutlet UIView *remarkView;
@property (strong, nonatomic) HXPlaceholderTextView *remark;
/* 选中的顾问 */
@property(nonatomic,strong) RCHouseAdviser *selectcAdviser;
@end

@implementation RCPushClientEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"客户推荐"];
    
    self.remark = [[HXPlaceholderTextView alloc] initWithFrame:self.remarkView.bounds];
    self.remark.placeholder = @"请输入客户购房的补充说明(选填)";
    [self.remarkView addSubview:self.remark];
    
    self.name.delegate = self;
    self.phone.delegate = self;
    self.remark.delegate = self;
    [self setUpTableView];
    
    if ([self.buldTypeIsShows isEqualToString:@"0"]) {//不展示物业，展示顾问
        self.wuYeView.hidden = YES;
        self.wuYeViewHeight.constant = 0.f;
        self.saleManView.hidden = NO;
        self.saleManViewHeight.constant = 50.f;
    }else{//展示物业，不展示顾问
        self.wuYeView.hidden = NO;
        self.wuYeViewHeight.constant = 50.f;
        self.saleManView.hidden = YES;
        self.saleManViewHeight.constant = 0.f;
    }
    if (self.isDetailPush) {//从楼盘详情来
        self.reportTarget = [[RCReportTarget alloc] init];
    }else{
        self.name.text = self.reportTarget.cusName;
        self.phone.text = self.reportTarget.cusPhone;
        
        self.morePhoneViewHeight.constant = 50.f*self.reportTarget.morePhones.count;
        [self.morePhoneView reloadData];
        
        self.wuYeType.text = self.reportTarget.wuyeType;
        self.saleMan.text = self.reportTarget.sealMan;
        self.appointDate.text = self.reportTarget.appointDate;
        self.remark.text = self.reportTarget.remark;
    }
    
    // 1 业主经纪人 2 员工经纪人 3普通经济人
    if ([MSUserManager sharedInstance].curUserInfo.uType == 1) {
        self.reporterAccRole.text = @"业主经纪人";
    }else if ([MSUserManager sharedInstance].curUserInfo.uType == 2) {
        self.reporterAccRole.text = @"员工经纪人";
    }else{
        self.reporterAccRole.text = @"普通经纪人";
    }
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.remark.frame = self.remarkView.bounds;
}
-(void)setUpTableView
{
    self.morePhoneView.estimatedRowHeight = 0;
    self.morePhoneView.estimatedSectionHeaderHeight = 0;
    self.morePhoneView.estimatedSectionFooterHeight = 0;
    self.morePhoneView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.morePhoneView.scrollEnabled = NO;
    self.morePhoneView.dataSource = self;
    self.morePhoneView.delegate = self;
    self.morePhoneView.showsVerticalScrollIndicator = NO;
    self.morePhoneView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.morePhoneView registerNib:[UINib nibWithNibName:NSStringFromClass([RCAddPhoneCell class]) bundle:nil] forCellReuseIdentifier:AddPhoneCell];
}
#pragma mark -- UITextField代理
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.name) {
        self.reportTarget.cusName = [textField hasText]?textField.text:@"";
    }else {
        self.reportTarget.cusPhone = [textField hasText]?textField.text:@"";
    }
}
#pragma mark -- UITextView代理
-(void)textViewDidEndEditing:(UITextView *)textView
{
    self.reportTarget.remark = [textView hasText]?textView.text:@"";
}
#pragma mark -- 点击事件
- (IBAction)addPhoneClicked:(UIButton *)sender {
    if (self.reportTarget.morePhones && self.reportTarget.morePhones.count==2) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"1个客户最多3个电话"];
        return;
    }
    RCReportPhone *phone = [RCReportPhone new];
    if (!self.reportTarget.morePhones) {
        self.reportTarget.morePhones = [NSMutableArray array];
    }
    [self.reportTarget.morePhones addObject:phone];
    self.morePhoneViewHeight.constant = 50.f*self.reportTarget.morePhones.count;
    [self.morePhoneView reloadData];
}
- (IBAction)chooseWuYeClicked:(UIButton *)sender {
    // 1.Custom propery（自定义属性）
    NSDictionary *propertyDict = @{
                                   ZJPickerViewPropertyCanceBtnTitleKey : @"取消",
                                   ZJPickerViewPropertySureBtnTitleKey  : @"确定",
                                   ZJPickerViewPropertyTipLabelTextKey  : [self.wuYeType hasText]?self.wuYeType.text:@"选择物业类型", // 提示内容
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
    [ZJPickerView zj_showWithDataList:[self.buldType componentsSeparatedByString:@","] propertyDict:propertyDict completion:^(NSString *selectContent) {
        hx_strongify(weakSelf);
        // show select content|
        NSArray *results = [selectContent componentsSeparatedByString:@"|"];

        NSArray *wuye = [results.firstObject componentsSeparatedByString:@","];

        //NSArray *rows = [results.lastObject componentsSeparatedByString:@","];
        
        strongSelf.wuYeType.text = wuye.firstObject;
        strongSelf.reportTarget.wuyeType = strongSelf.wuYeType.text;
    }];
}
- (IBAction)chooseZhiYeClicked:(UIButton *)sender {
    RCHouseAdviserVC *avc = [RCHouseAdviserVC new];
    avc.prouuid = self.proUuid;
    if (self.selectcAdviser) {
        avc.lastAdvier = self.selectcAdviser;
    }
    hx_weakify(self);
    avc.chooseAdviserCall = ^(RCHouseAdviser * _Nullable adviser) {
        hx_strongify(weakSelf);
        if (adviser) {
            strongSelf.selectcAdviser = adviser;
            strongSelf.saleMan.text = adviser.accName;
            strongSelf.reportTarget.sealMan = adviser.accName;
        }else{
            strongSelf.selectcAdviser= nil;
            strongSelf.saleMan.text = @"";
            strongSelf.reportTarget.sealMan = @"";
        }
    };
    [self.navigationController pushViewController:avc animated:YES];
}
- (IBAction)chooseVisitDateClicked:(UIButton *)sender {
    //年-月-日
    hx_weakify(self);
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay CompleteBlock:^(NSDate *selectDate) {
        
        NSString *dateString = [selectDate stringWithFormat:@"yyyy-MM-dd"];
        weakSelf.appointDate.text = dateString;
        weakSelf.reportTarget.appointDate = dateString;
    }];
    datepicker.minLimitDate = [NSDate date];
    datepicker.dateLabelColor = HXControlBg;//年-月-日 颜色
    datepicker.datePickerColor = [UIColor blackColor];//滚轮日期颜色
    datepicker.doneButtonColor = HXControlBg;//确定按钮的颜色
    [datepicker show];
}
- (IBAction)sureReportRequet:(UIButton *)sender {
    BOOL isOK = YES;
    if (self.reportTarget.morePhones && self.reportTarget.morePhones.count) {
        for (RCReportPhone *phone in self.reportTarget.morePhones) {
            if (!phone.cusPhone.length) {
                isOK = NO;
                break;
            }
        }
    }
    if ([self.buldTypeIsShows isEqualToString:@"1"]) {//展示物业。不展示顾问
        if (!isOK || !self.reportTarget.cusName.length || !self.reportTarget.cusPhone.length || !self.reportTarget.wuyeType.length) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"客户必填信息不完整"];
            return;
        }
    }else{//不展示物业，展示顾问，但是顾问是选填
        if (!isOK || !self.reportTarget.cusName.length || !self.reportTarget.cusPhone.length) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"客户必填信息不完整"];
            return;
        }
    }
    if (self.isDetailPush) {
        hx_weakify(self);
        zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"提示" message:@"确认要完成推荐客户？" constantWidth:HX_SCREEN_WIDTH - 50*2];
        zhAlertButton *cancelButton = [zhAlertButton buttonWithTitle:@"取消" handler:^(zhAlertButton * _Nonnull button) {
            hx_strongify(weakSelf);
            [strongSelf.zh_popupController dismiss];
        }];
        zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"确认" handler:^(zhAlertButton * _Nonnull button) {
            hx_strongify(weakSelf);
            [strongSelf.zh_popupController dismiss];
            [strongSelf submitReportDataRequest:sender];
        }];
        cancelButton.lineColor = UIColorFromRGB(0xDDDDDD);
        [cancelButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        okButton.lineColor = UIColorFromRGB(0xDDDDDD);
        [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
        [alert adjoinWithLeftAction:cancelButton rightAction:okButton];
        self.zh_popupController = [[zhPopupController alloc] init];
        [self.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
    }else{
        if (self.editDoneCall) {
            self.editDoneCall();
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark -- 业务逻辑
-(void)submitReportDataRequest:(UIButton *)sender
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    
    data[@"proIds"] = @[self.proUuid];//项目列表 必填
    
    NSMutableArray *phones = [NSMutableArray array];
    [phones addObject:self.reportTarget.cusPhone];
    if (self.reportTarget.morePhones && self.reportTarget.morePhones.count) {
        for (RCReportPhone *phone in self.reportTarget.morePhones) {
            [phones addObject:phone.cusPhone];
        }
    }
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    // 1 业主经纪人 2 员工经纪人 3普通经济人
    NSString *twoQudaoName = nil;
    NSString *twoQudaoCode = nil;
    if ([MSUserManager sharedInstance].curUserInfo.uType == 1) {
        twoQudaoName = @"老业主";
        twoQudaoCode = @"K-0026";
    }else if ([MSUserManager sharedInstance].curUserInfo.uType == 2) {
        twoQudaoName = @"员工推荐";
        twoQudaoCode = @"K-0025";
    }else{
        twoQudaoName = @"普通经纪人";
        twoQudaoCode = @"K-0027";
    }
    
    data[@"cusInfo"] = @[@{@"name":self.reportTarget.cusName,//客户姓名
                           @"phone":phones,//客户手机号
                           @"remark":(self.reportTarget.remark && self.reportTarget.remark.length) ?self.reportTarget.remark:@"",//客户备注
                           @"seeTime":(self.reportTarget.appointDate && self.reportTarget.appointDate.length)?@([[fmt dateFromString:self.reportTarget.appointDate] timeIntervalSince1970]):@"",//预约看房时间
                           @"houseType":[self.buldTypeIsShows isEqualToString:@"1"]?self.reportTarget.wuyeType:@"",//房屋类型
                           @"twoQudaoName":twoQudaoName,//拓展方式名称或报备人所属渠道名称
                           @"twoQudaoCode":twoQudaoCode,//拓展方式id或报备人所属渠道id
                           @"teamUuid":self.selectcAdviser?self.selectcAdviser.teamUuid:@"", //归属团队
                           @"groupUuid":self.selectcAdviser?self.selectcAdviser.groupUuid:@"",//归属小组
                           @"salesAccUuid":self.selectcAdviser?self.selectcAdviser.uuid:@"" //归属顾问id
    }];//客户信息 必填
     
    data[@"accUuid"] = [MSUserManager sharedInstance].curUserInfo.userinfo.uuid;//报备人id 必填
    data[@"userRole"] = [MSUserManager sharedInstance].curUserInfo.userinfo.accRole;//报备人角色 必填
    data[@"accName"] = [MSUserManager sharedInstance].curUserInfo.userinfo.name;//报备人名称
    data[@"accType"] = @"2";//报备人类型 1 顾问 2 经纪人 3 自渠专员 4 展厅专员  5 统一报备人 6 门店管理员
    
    parameters[@"data"] = data;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"cus/cus/cusbaobeilist/addReportCust" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if ([responseObject[@"code"] integerValue] == 0) {
            RCReportResultVC *rvc = [RCReportResultVC new];
            rvc.results = responseObject[@"data"];
            [strongSelf.navigationController pushViewController:rvc animated:YES];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.reportTarget.morePhones.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCAddPhoneCell *cell = [tableView dequeueReusableCellWithIdentifier:AddPhoneCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    RCReportPhone *phone = self.reportTarget.morePhones[indexPath.row];
    cell.phone = phone;
    hx_weakify(self);
    cell.cutBtnCall = ^{
        hx_strongify(weakSelf);
        [strongSelf.reportTarget.morePhones removeObjectAtIndex:indexPath.row];
        strongSelf.morePhoneViewHeight.constant = 50.f*strongSelf.reportTarget.morePhones.count;
        [tableView reloadData];
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 50.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
