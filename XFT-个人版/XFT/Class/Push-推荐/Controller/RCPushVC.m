//
//  RCPushVC.m
//  XFT
//
//  Created by 夏增明 on 2019/8/26.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCPushVC.h"
#import "RCPushHouseVC.h"
#import "HXPlaceholderTextView.h"
#import "RCAddPhoneCell.h"
#import "WSDatePickerView.h"
#import <ZLCollectionViewHorzontalLayout.h>
#import "RCHouseTagsCell.h"
#import "RCAddedClientCell.h"
#import "RCReportResultVC.h"
#import "RCHouseAdviserVC.h"
#import "RCPushClientEditVC.h"
#import "RCReportTarget.h"
#import "zhAlertView.h"
#import <zhPopupController.h>
#import "ZJPickerView.h"
#import "RCHouseList.h"
#import "RCHouseAdviser.h"
#import "UITextField+GYExpand.h"

static NSString *const AddPhoneCell = @"AddPhoneCell";
static NSString *const HouseTagsCell = @"HouseTagsCell";
static NSString *const AddedClientCell = @"AddedClientCell";

@interface RCPushVC ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,ZLCollectionViewBaseFlowLayoutDelegate,UITextFieldDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *houseViewHeight;
/* 已添加的推荐客户视图 */
@property (weak, nonatomic) IBOutlet UITableView *clientTableView;
/* 已添加的推荐客户视图高度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *clientTableViewHeight;
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
/* 继续添加客户按钮 */
@property (weak, nonatomic) IBOutlet UIButton *againAddBtn;
/* 确认完成推荐按钮 */
@property (weak, nonatomic) IBOutlet UIButton *sureReportBtn;
/* 选择的楼盘 */
@property(nonatomic,strong) NSMutableArray *houses;
/* 已经填写好信息的推荐客户 */
@property(nonatomic,strong) NSMutableArray *clients;
/* 记录当前正在操作的推荐客户 */
@property(nonatomic,strong) RCReportTarget *currentReportTarget;
/* 选中的顾问 */
@property(nonatomic,strong) RCHouseAdviser *selectcAdviser;
@end

@implementation RCPushVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"推荐"];
    /**单个楼盘：物业和顾问单选，物业show字段为0不显示，单个楼盘才能继续添加。
    多个楼盘：物业和顾问不显示，不能继续添加，继续添加按钮为灰色或点击给出提示。*/
    self.name.delegate = self;
    self.phone.delegate = self;
    self.remark.delegate = self;
    
    self.remark = [[HXPlaceholderTextView alloc] initWithFrame:self.remarkView.bounds];
    self.remark.placeholder = @"请输入客户购房的补充说明(选填)";
    [self.remarkView addSubview:self.remark];
    
    hx_weakify(self);
    [self.phone lengthLimit:^{
        hx_strongify(weakSelf);
        if ([strongSelf.phone.text hasPrefix:@"1"]){//如果以”1“开头就限制11位
            if (strongSelf.phone.text.length > 11) {
                strongSelf.phone.text = [strongSelf.phone.text substringToIndex:11];
            }
        }
    }];
    
    // 1 业主经纪人 2 员工经纪人 3普通经济人
    if ([MSUserManager sharedInstance].curUserInfo.uType == 1) {
        self.reporterAccRole.text = @"业主经纪人";
    }else if ([MSUserManager sharedInstance].curUserInfo.uType == 2) {
        self.reporterAccRole.text = @"员工经纪人";
    }else{
        self.reporterAccRole.text = @"个人经纪人";
    }
    
    [self setUpTableView];
    [self setUpCollectionView];
    
    if (self.proUuid && self.proUuid.length) {
        self.name.text = self.reName;
        self.phone.text = self.rePhone;
        // 创建当前第一个操作的客户
        RCReportTarget *reportTarget = [RCReportTarget new];
        reportTarget.cusName = self.reName;
        reportTarget.cusPhone = self.rePhone;
        self.currentReportTarget = reportTarget;
        
        [self startShimmer];
        [self getHouseDetailRequest];
    }else{
        // 创建当前第一个操作的客户
        RCReportTarget *reportTarget = [RCReportTarget new];
        self.currentReportTarget = reportTarget;
    }
    
    [self.sureReportBtn BindingBtnJudgeBlock:^BOOL{
        hx_strongify(weakSelf);
        // 判断报备对象信息是否完整
        if (!strongSelf.houses || !strongSelf.houses.count) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请选择楼盘"];
            return NO;
        }
        BOOL isOK = YES;
        if (strongSelf.currentReportTarget.morePhones && strongSelf.currentReportTarget.morePhones.count){
            for (RCReportPhone *phone in strongSelf.currentReportTarget.morePhones) {
                if (!phone.cusPhone.length) {
                    isOK = NO;
                    break;
                }
            }
        }
        if (strongSelf.houses.count > 1) {
            if (!isOK || !strongSelf.currentReportTarget.cusName.length || !strongSelf.currentReportTarget.cusPhone.length) {
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"客户必填信息不完整"];
                return NO;
            }
        }else{
            RCHouseList *house = strongSelf.houses.firstObject;
            if ([house.buldTypeIsShows isEqualToString:@"1"]) {//展示物业。不展示顾问
                if (!isOK || !strongSelf.currentReportTarget.cusName.length || !strongSelf.currentReportTarget.cusPhone.length || !strongSelf.currentReportTarget.wuyeType.length) {
                    [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"客户必填信息不完整"];
                    return NO;
                }
            }else{//不展示物业，展示顾问，但是顾问是选填
                if (!isOK || !strongSelf.currentReportTarget.cusName.length || !strongSelf.currentReportTarget.cusPhone.length) {
                    [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"客户必填信息不完整"];
                    return NO;
                }
            }
        }
        return YES;
    } ActionBlock:^(UIButton * _Nullable button) {
        hx_strongify(weakSelf);
        [strongSelf pushDoneClicked:button];
    }];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.remark.frame = self.remarkView.bounds;
}
-(NSMutableArray *)houses
{
    if (_houses == nil) {
        _houses = [NSMutableArray array];
    }
    return _houses;
}
-(NSMutableArray *)clients
{
    if (_clients == nil) {
        _clients = [NSMutableArray array];
    }
    return _clients;
}
-(void)setUpTableView
{
    self.clientTableView.estimatedRowHeight = 0;
    self.clientTableView.estimatedSectionHeaderHeight = 0;
    self.clientTableView.estimatedSectionFooterHeight = 0;
    self.clientTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.clientTableView.dataSource = self;
    self.clientTableView.delegate = self;
    self.clientTableView.showsVerticalScrollIndicator = NO;
    self.clientTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.clientTableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCAddedClientCell class]) bundle:nil] forCellReuseIdentifier:AddedClientCell];
    
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
-(void)setUpCollectionView
{
    ZLCollectionViewHorzontalLayout *flowLayout = [[ZLCollectionViewHorzontalLayout alloc] init];
    flowLayout.delegate = self;
    flowLayout.canDrag = NO;
    self.collectionView.collectionViewLayout = flowLayout;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([RCHouseTagsCell class]) bundle:nil] forCellWithReuseIdentifier:HouseTagsCell];
}
#pragma mark -- UITextField代理
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.name) {
        self.currentReportTarget.cusName = [textField hasText]?textField.text:@"";
    }else {
        self.currentReportTarget.cusPhone = [textField hasText]?textField.text:@"";
    }
}
#pragma mark -- UITextView代理
-(void)textViewDidEndEditing:(UITextView *)textView
{
    self.currentReportTarget.remark = [textView hasText]?textView.text:@"";
}
#pragma mark -- 点击事件
- (IBAction)chooseHouseClicked:(UIButton *)sender {
    if (self.clients && self.clients.count) {// 如果数组中已经有待报备的对象，就是批量
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"已存在客户，不可更换楼盘"];
        return;
    }
    RCPushHouseVC *hvc = [RCPushHouseVC new];
     
    if (self.clients && self.clients.count) {// 如果数组中已经有待报备的对象，就是批量
        hvc.isBatchReport = YES;
    }else{
        hvc.isBatchReport = NO;
    }
    
    if (self.houses && self.houses.count) {
        hvc.lastHouses = self.houses;
    }
    hx_weakify(self);
    hvc.wishHouseCall = ^(NSArray * _Nonnull houses) {
        hx_strongify(weakSelf);
        strongSelf.houses = [NSMutableArray arrayWithArray:houses];
        if (strongSelf.houses.count) {
            strongSelf.houseViewHeight.constant = 50.f+60.f;
        }else{
            strongSelf.houseViewHeight.constant = 50.f;
        }
        if (strongSelf.houses.count > 1) {//批量报备不显示物业类型和置业顾问
            strongSelf.wuYeView.hidden = YES;
            strongSelf.wuYeViewHeight.constant = 0.f;
            
            strongSelf.saleManView.hidden = YES;
            strongSelf.saleManViewHeight.constant = 0.f;
        }else{
            RCHouseList *house = strongSelf.houses.firstObject;
            if ([house.buldTypeIsShows isEqualToString:@"0"]) {//不展示物业，展示顾问
                strongSelf.wuYeView.hidden = YES;
                strongSelf.wuYeViewHeight.constant = 0.f;
                strongSelf.saleManView.hidden = NO;
                strongSelf.saleManViewHeight.constant = 50.f;
            }else{//展示物业，不展示顾问
                strongSelf.wuYeView.hidden = NO;
                strongSelf.wuYeViewHeight.constant = 50.f;
                strongSelf.saleManView.hidden = YES;
                strongSelf.saleManViewHeight.constant = 0.f;
            }
        }
        // 清空物业和置业顾问
        strongSelf.wuYeType.text = @"";
        strongSelf.currentReportTarget.wuyeType = @"";
        strongSelf.saleMan.text = @"";
        strongSelf.currentReportTarget.sealMan = @"";
        strongSelf.selectcAdviser = nil;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [strongSelf.collectionView reloadData];
        });
    };
    [self.navigationController pushViewController:hvc animated:YES];
}
- (IBAction)addPhoneClicked:(UIButton *)sender {
    if (self.currentReportTarget.morePhones && self.currentReportTarget.morePhones.count==2) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"1个客户最多3个电话"];
        return;
    }
    RCReportPhone *phone = [RCReportPhone new];
    if (!self.currentReportTarget.morePhones) {
        self.currentReportTarget.morePhones = [NSMutableArray array];
    }
    [self.currentReportTarget.morePhones addObject:phone];
    self.morePhoneViewHeight.constant = 50.f*self.currentReportTarget.morePhones.count;
    [self.morePhoneView reloadData];
}
- (IBAction)chooseWuYeClicked:(UIButton *)sender {
    if (!self.houses.count) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请先选择楼盘"];
        return;
    }
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
    RCHouseList *house = self.houses.firstObject;

    hx_weakify(self);
    [ZJPickerView zj_showWithDataList:[house.buldType componentsSeparatedByString:@","] propertyDict:propertyDict completion:^(NSString *selectContent) {
        hx_strongify(weakSelf);
        // show select content|
        NSArray *results = [selectContent componentsSeparatedByString:@"|"];

        NSArray *wuye = [results.firstObject componentsSeparatedByString:@","];

        //NSArray *rows = [results.lastObject componentsSeparatedByString:@","];
        
        strongSelf.wuYeType.text = wuye.firstObject;
        strongSelf.currentReportTarget.wuyeType = strongSelf.wuYeType.text;
    }];
}
- (IBAction)chooseZhiYeClicked:(UIButton *)sender {
    if (!self.houses.count) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请先选择楼盘"];
        return;
    }
    RCHouseAdviserVC *avc = [RCHouseAdviserVC new];
    RCHouseList *house = self.houses.firstObject;
    avc.prouuid = house.uuid;
    if (self.selectcAdviser) {
        avc.lastAdvier = self.selectcAdviser;
    }
    hx_weakify(self);
    avc.chooseAdviserCall = ^(RCHouseAdviser * _Nullable adviser) {
        hx_strongify(weakSelf);
        if (adviser) {
            strongSelf.selectcAdviser = adviser;
            strongSelf.saleMan.text = adviser.accName;
            strongSelf.currentReportTarget.sealMan = adviser.accName;
        }else{
            strongSelf.selectcAdviser= nil;
            strongSelf.saleMan.text = @"";
            strongSelf.currentReportTarget.sealMan = @"";
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
        weakSelf.currentReportTarget.appointDate = dateString;
    }];
    datepicker.minLimitDate = [NSDate date];
    datepicker.dateLabelColor = HXControlBg;//年-月-日 颜色
    datepicker.datePickerColor = [UIColor blackColor];//滚轮日期颜色
    datepicker.doneButtonColor = HXControlBg;//确定按钮的颜色
    [datepicker show];
}
- (IBAction)pushAgainClicked:(UIButton *)sender {
    if (!self.houses.count) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请先选择楼盘"];
        return;
    }
    // 要判断是否可以批量推荐
    if (self.houses.count > 1) {//多个楼盘不可以批量推荐
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"多个楼盘不可批量推荐"];
        return;
    }

    // 判断推荐对象信息是否完整
    if (self.clients && self.clients.count == 4) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"1次最多推荐5个客户"];
        return;
    }
    
    BOOL isOK = YES;
    if (self.currentReportTarget.morePhones && self.currentReportTarget.morePhones.count) {
        for (RCReportPhone *phone in self.currentReportTarget.morePhones) {
            if (!phone.cusPhone.length) {
                isOK = NO;
                break;
            }
        }
    }
    
    RCHouseList *house = self.houses.firstObject;
    if ([house.buldTypeIsShows isEqualToString:@"1"]) {//展示物业。不展示顾问
        if (!isOK || !self.currentReportTarget.cusName.length || !self.currentReportTarget.cusPhone.length || !self.currentReportTarget.wuyeType.length) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"客户必填信息不完整"];
            return;
        }
    }else{//不展示物业，展示顾问，但是顾问是选填
        if (!isOK || !self.currentReportTarget.cusName.length || !self.currentReportTarget.cusPhone.length) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"客户必填信息不完整"];
            return;
        }
    }
    
    // 如果必填信息完整就加入报备数组，并清空页面数据，创建新的报备对象
    [self.clients addObject:self.currentReportTarget];
    self.clientTableViewHeight.constant = 55.f*self.clients.count;
    [self.clientTableView reloadData];
    
    RCReportTarget *reportTarget = [RCReportTarget new];
    self.currentReportTarget = reportTarget;
    
    self.name.text = @"";
    self.phone.text = @"";
    self.wuYeType.text = @"";
    self.saleMan.text = @"";
    self.appointDate.text = @"";
    self.remark.text = @"";

    self.morePhoneViewHeight.constant = 50.f*self.currentReportTarget.morePhones.count;
    [self.morePhoneView reloadData];
}

- (void)pushDoneClicked:(UIButton *)sender {
    hx_weakify(self);
    zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"提示" message:@"确认要完成推荐客户？" constantWidth:HX_SCREEN_WIDTH - 50*2];
    zhAlertButton *cancelButton = [zhAlertButton buttonWithTitle:@"取消" handler:^(zhAlertButton * _Nonnull button) {
        hx_strongify(weakSelf);
        [strongSelf.zh_popupController dismiss];
        [sender stopLoading:@"确认完成推荐" image:nil textColor:nil backgroundColor:nil];
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
}
#pragma mark -- 业务逻辑
-(void)getHouseDetailRequest
{
    // 楼盘详情
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"uuid"] = self.proUuid;
    parameters[@"data"] = data;

    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"pro/pro/proBaseInfo/proInfo" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if ([responseObject[@"code"] integerValue] == 0) {
            RCHouseList *house = [RCHouseList yy_modelWithDictionary:responseObject[@"data"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.houses = [NSMutableArray arrayWithArray:@[house]];
                
                strongSelf.houseViewHeight.constant = 50.f+60.f;
              
                if ([house.buldTypeIsShows isEqualToString:@"0"]) {//不展示物业，展示顾问
                    strongSelf.wuYeView.hidden = YES;
                    strongSelf.wuYeViewHeight.constant = 0.f;
                    strongSelf.saleManView.hidden = NO;
                    strongSelf.saleManViewHeight.constant = 50.f;
                }else{//展示物业，不展示顾问
                    strongSelf.wuYeView.hidden = NO;
                    strongSelf.wuYeViewHeight.constant = 50.f;
                    strongSelf.saleManView.hidden = YES;
                    strongSelf.saleManViewHeight.constant = 0.f;
                }
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [strongSelf.collectionView reloadData];
                });
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)submitReportDataRequest:(UIButton *)sender
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    
    NSMutableArray *proIds = [NSMutableArray array];
    for (RCHouseList *house in self.houses) {//每个报备对象的楼盘信息都一样，所以可以直接去当前的报备对象
        [proIds addObject:house.uuid];
    }
    data[@"proIds"] = proIds;//项目列表 必填

    // 临时报备对象数组
    NSMutableArray *tempTargets = [NSMutableArray arrayWithArray:self.clients];
    // 将当前页面展示的这个需要报备的对象加入临时数组
    [tempTargets addObject:self.currentReportTarget];

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
    
    NSMutableArray *cusInfo = [NSMutableArray array];
    for (RCReportTarget *target in tempTargets) {
        NSMutableArray *phones = [NSMutableArray array];
        [phones addObject:target.cusPhone];
        if (target.morePhones && target.morePhones.count) {
            for (RCReportPhone *phone in target.morePhones) {
                [phones addObject:phone.cusPhone];
            }
        }
        [cusInfo addObject:@{@"name":target.cusName,//客户姓名
                             @"phone":phones,//客户手机号
                             @"remark":(target.remark && target.remark.length) ?target.remark:@"",//客户备注
                             @"seeTime":(target.appointDate && target.appointDate.length)?@([[fmt dateFromString:target.appointDate] timeIntervalSince1970]):@"",//预约看房时间
                             @"houseType":(target.wuyeType && target.wuyeType.length) ?target.wuyeType:@"",//房屋类型
                             @"twoQudaoName":twoQudaoName,//拓展方式名称或报备人所属渠道名称
                             @"twoQudaoCode":twoQudaoCode,//拓展方式id或报备人所属渠道id
                             @"teamUuid":self.selectcAdviser?self.selectcAdviser.teamUuid:@"", //归属团队
                             @"groupUuid":self.selectcAdviser?self.selectcAdviser.groupUuid:@"",//归属小组
                             @"salesAccUuid":self.selectcAdviser?self.selectcAdviser.accUuid:@"" //归属顾问id
                             }];
    }
    data[@"cusInfo"] = cusInfo;//客户信息 必填
    data[@"accUuid"] = [MSUserManager sharedInstance].curUserInfo.userinfo.uuid;//报备人id 必填
    data[@"userRole"] = [MSUserManager sharedInstance].curUserInfo.userinfo.accRole;//报备人角色 必填
    data[@"accName"] = [MSUserManager sharedInstance].curUserInfo.userinfo.name;//报备人名称
    data[@"accType"] = @"2";//报备人类型 1 顾问 2 经纪人 3 自渠专员 4 展厅专员  5 统一报备人 6 门店管理员
    parameters[@"data"] = data;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"cus/cus/cusbaobeilist/addReportCust" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [sender stopLoading:@"确认完成推荐" image:nil textColor:nil backgroundColor:nil];
        if ([responseObject[@"code"] integerValue] == 0) {
            [strongSelf clearReportData];
            RCReportResultVC *rvc = [RCReportResultVC new];
            rvc.results = responseObject[@"data"];
            [strongSelf.navigationController pushViewController:rvc animated:YES];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
        [sender stopLoading:@"确认完成推荐" image:nil textColor:nil backgroundColor:nil];
    }];
}
-(void)clearReportData
{
    [self.houses removeAllObjects];//清空选择楼盘
    self.houseViewHeight.constant = 50.f;
    hx_weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.collectionView reloadData];
    });
    
    RCReportTarget *reportTarget = [RCReportTarget new];
    self.currentReportTarget = reportTarget;
    
    self.name.text = @"";
    self.phone.text = @"";
    self.wuYeType.text = @"";
    self.saleMan.text = @"";
    self.appointDate.text = @"";
    self.remark.text = @"";

    self.morePhoneViewHeight.constant = 50.f*self.currentReportTarget.morePhones.count;
    [self.morePhoneView reloadData];
}
#pragma mark -- UICollectionView 数据源和代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.houses.count;
}
- (ZLLayoutType)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section {
    return ColumnLayout;
}
//如果是ClosedLayout样式的section，必须实现该代理，指定列数
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout*)collectionViewLayout columnCountOfSection:(NSInteger)section {
    return 1;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RCHouseTagsCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:HouseTagsCell forIndexPath:indexPath];
    RCHouseList *house = self.houses[indexPath.item];
    cell.name.text = house.name;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.clients && self.clients.count) {// 如果数组中已经有待报备的对象，就是批量
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"已存在客户，不可更换楼盘"];
    }else{
        [self.houses removeObjectAtIndex:indexPath.item];
        
        if (!self.houses.count) {
            self.houseViewHeight.constant = 50.f;
        }else{
            self.houseViewHeight.constant = 50.f + 60.f;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [collectionView reloadData];
        });
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    RCHouseList *house = self.houses[indexPath.item];

    return CGSizeMake([house.name boundingRectWithSize:CGSizeMake(1000000, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:14]} context:nil].size.width + 50, 30);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10.f;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return  UIEdgeInsetsMake(15, 15, 15, 15);
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (tableView == self.clientTableView)?self.clients.count:self.currentReportTarget.morePhones.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.clientTableView) {
        RCAddedClientCell *cell = [tableView dequeueReusableCellWithIdentifier:AddedClientCell forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        RCReportTarget *client = self.clients[indexPath.row];
        cell.client = client;
        hx_weakify(self);
        cell.cutBtnCall = ^{
            hx_strongify(weakSelf);
            [strongSelf.clients removeObjectAtIndex:indexPath.row];
            strongSelf.clientTableViewHeight.constant = 55.f*strongSelf.clients.count;
            [tableView reloadData];
        };
        return cell;
    }else{
        RCAddPhoneCell *cell = [tableView dequeueReusableCellWithIdentifier:AddPhoneCell forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        RCReportPhone *phone = self.currentReportTarget.morePhones[indexPath.row];
        cell.phone = phone;
        hx_weakify(self);
        cell.cutBtnCall = ^{
            hx_strongify(weakSelf);
            [strongSelf.currentReportTarget.morePhones removeObjectAtIndex:indexPath.row];
            strongSelf.morePhoneViewHeight.constant = 50.f*strongSelf.currentReportTarget.morePhones.count;
            [tableView reloadData];
        };
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return (tableView == self.clientTableView)?55.f:50.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.clientTableView) {
        RCHouseList *house = self.houses.firstObject;
        RCPushClientEditVC *evc = [RCPushClientEditVC new];
        RCReportTarget *client = self.clients[indexPath.row];
        evc.buldTypeIsShows = house.buldTypeIsShows;
        evc.proUuid = house.uuid;
        evc.buldType = house.buldType;
        evc.reportTarget = client;
        evc.editDoneCall = ^{
            [tableView reloadData];
        };
        [self.navigationController pushViewController:evc animated:YES];
    }
}


@end
