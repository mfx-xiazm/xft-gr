//
//  RCHouseStyleVC.m
//  XFT
//
//  Created by 夏增明 on 2019/8/30.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCHouseStyleVC.h"
#import "RCHouseStyleHeader.h"
#import "RCHouseStyleDetailCell.h"
#import "RCShareView.h"
#import <zhPopupController.h>
#import "zhAlertView.h"
#import "RCHouseAppointVC.h"
#import "RCHouseLoanVC.h"
#import "RCHouseInfo.h"
#import "RCLoginVC.h"
#import "HXNavigationController.h"
#import "RCPushClientEditVC.h"
#import <UMShare/UMShare.h>

static NSString *const HouseStyleDetailCell = @"HouseStyleDetailCell";

@interface RCHouseStyleVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 详情操作 */
@property (weak, nonatomic) IBOutlet SPButton *collectBtn;
/* 头视图 */
@property(nonatomic,strong) RCHouseStyleHeader *header;
/* 户型详情 */
@property(nonatomic,strong) RCHouseInfo *houseInfo;

@property (weak, nonatomic) IBOutlet UIButton *appointOrReportBtn;

@end

@implementation RCHouseStyleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"户型详情"];
    [self setUpTableView];
    [self startShimmer];
    [self getHouseStyleDetailRequest];
    if ([MSUserManager sharedInstance].isLogined) {
        if ([MSUserManager sharedInstance].curUserInfo.uType == 0 || [MSUserManager sharedInstance].curUserInfo.uType == 4) {
            [self.appointOrReportBtn setTitle:@"预约看房" forState:UIControlStateNormal];
        }else{
            [self.appointOrReportBtn setTitle:@"报备客户" forState:UIControlStateNormal];
        }
       //[self getCollectStateRequest];//查询收藏状态
    }
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 130);
}
-(RCHouseStyleHeader *)header
{
    if (_header == nil) {
        _header = [RCHouseStyleHeader loadXibView];
        _header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 130);
        hx_weakify(self);
        _header.loanDetailCall = ^{
            RCHouseLoanVC *lvc = [RCHouseLoanVC new];
            [weakSelf.navigationController pushViewController:lvc animated:YES];
        };
    }
    return _header;
}
-(void)setUpTableView
{
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.estimatedRowHeight = 0;//预估高度
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCHouseStyleDetailCell class]) bundle:nil] forCellReuseIdentifier:HouseStyleDetailCell];
    
    self.tableView.tableHeaderView = self.header;
}
#pragma mark -- 点击事件
-(IBAction)shareClicked:(UIButton *)sender
{
    if (![[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatSession]) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"未安装微信客户端"];
    }else{
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        UMShareMiniProgramObject *shareObject = [UMShareMiniProgramObject shareObjectWithTitle:self.houseInfo.name descr:self.houseInfo.name thumImage:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"WechatIMG806" ofType:@"png"]]];
        NSString *path = [NSString stringWithFormat:@"pages/hoursTypeDetail/hoursTypeDetail?loginid=%@&actType=0&uid=%@&phoneNum=%@",[MSUserManager sharedInstance].curUserInfo.userinfo.uuid,self.uuid,self.housePhone];
        /* 低版本微信网页链接 */
        shareObject.webpageUrl = path;
        /* 小程序username */
        shareObject.userName = @"gh_d2e3f78eca81";
        /* 小程序页面的路径 */
        shareObject.path = path;
        /* 小程序新版本的预览图 128k */
        shareObject.hdImageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"WechatIMG806" ofType:@"png"]];//[NSData dataWithContentsOfURL:[NSURL URLWithString:self.shareInfo[@"thumbData"]]]
        
        /* 分享小程序的版本（正式，开发，体验）*/
        NSInteger miniprogramType = 0;//正式版:0，测试版:1，体验版:2
        if (miniprogramType == 0) {
            shareObject.miniProgramType = UShareWXMiniProgramTypeRelease;
        }else if (miniprogramType == 1) {
            shareObject.miniProgramType = UShareWXMiniProgramTypeTest;
        }else{
            shareObject.miniProgramType = UShareWXMiniProgramTypePreview;
        }
        messageObject.shareObject = shareObject;
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatSession messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
            if (error) {
                UMSocialLogInfo(@"************Share fail with error %@*********",error);
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
            }else{
                if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                    UMSocialShareResponse *resp = data;
                    [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:resp.message];
                    //分享结果消息
                    UMSocialLogInfo(@"response message is %@",resp.message);
                    //第三方原始返回的数据
                    UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                }else{
                    UMSocialLogInfo(@"response data is %@",data);
                }
            }
        }];
    }
}
-(IBAction)collectClicked:(UIButton *)sender
{
    if ([MSUserManager sharedInstance].isLogined) {
        [self setCollectRequest];
    }else{
        RCLoginVC *lvc = [RCLoginVC new];
        lvc.isInnerLogin = YES;
        HXNavigationController *nav = [[HXNavigationController alloc] initWithRootViewController:lvc];
        if (@available(iOS 13.0, *)) {
            nav.modalPresentationStyle = UIModalPresentationFullScreen;
            /*当该属性为 false 时，用户下拉可以 dismiss 控制器，为 true 时，下拉不可以 dismiss控制器*/
            nav.modalInPresentation = YES;
        }
        [self presentViewController:nav animated:YES completion:nil];
    }
}
- (IBAction)styleToolBtnClicked:(UIButton *)sender {
    if (sender.tag == 1) {
        hx_weakify(self);
        zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"提示" message:self.housePhone constantWidth:HX_SCREEN_WIDTH - 50*2];
        zhAlertButton *cancelButton = [zhAlertButton buttonWithTitle:@"取消" handler:^(zhAlertButton * _Nonnull button) {
            hx_strongify(weakSelf);
            [strongSelf.zh_popupController dismiss];
        }];
        zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"拨打" handler:^(zhAlertButton * _Nonnull button) {
            hx_strongify(weakSelf);
            [strongSelf.zh_popupController dismiss];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",strongSelf.housePhone]]];
        }];
        cancelButton.lineColor = UIColorFromRGB(0xDDDDDD);
        [cancelButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        okButton.lineColor = UIColorFromRGB(0xDDDDDD);
        [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
        [alert adjoinWithLeftAction:cancelButton rightAction:okButton];
        self.zh_popupController = [[zhPopupController alloc] init];
        [self.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
    }else{
        if ([MSUserManager sharedInstance].isLogined) {
            if ([MSUserManager sharedInstance].curUserInfo.uType == 0 || [MSUserManager sharedInstance].curUserInfo.uType == 4) {//预约客户
                RCHouseAppointVC *avc = [RCHouseAppointVC new];
                avc.productUuid = self.uuid;
                [self.navigationController pushViewController:avc animated:YES];
            }else{//报备客户
                RCPushClientEditVC *pvc = [RCPushClientEditVC new];
                /* 是否展示物业类型 0不展示物业，展示顾问 1展示物业，不展示顾问 */
                pvc.buldTypeIsShows = self.buldTypeIsShows;
                /* 项目名称 */
                pvc.proName = self.houseInfo.name;
                /* 项目id */
                pvc.proUuid = self.uuid;
                /* 项目物业类型 */
                pvc.buldType = self.buldType;
                /* 可以用这个来判断是否是楼盘详情的推荐push */
                pvc.isDetailPush = YES;
                [self.navigationController pushViewController:pvc animated:YES];
            }
        }else{
            RCLoginVC *lvc = [RCLoginVC new];
            lvc.isInnerLogin = YES;
            HXNavigationController *nav = [[HXNavigationController alloc] initWithRootViewController:lvc];
            if (@available(iOS 13.0, *)) {
                nav.modalPresentationStyle = UIModalPresentationFullScreen;
                /*当该属性为 false 时，用户下拉可以 dismiss 控制器，为 true 时，下拉不可以 dismiss控制器*/
                nav.modalInPresentation = YES;
            }
            [self presentViewController:nav animated:YES completion:nil];
        }
    }
}
#pragma mark -- 接口请求
-(void)getHouseStyleDetailRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"uuid"] = self.uuid;
    parameters[@"data"] = data;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"pro/pro/apartment/ByUuid" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if ([responseObject[@"code"] integerValue] == 0) {
            strongSelf.houseInfo = [RCHouseInfo yy_modelWithDictionary:responseObject[@"data"]];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            strongSelf.tableView.hidden = NO;
            strongSelf.header.houseInfo = strongSelf.houseInfo;
            [strongSelf.tableView reloadData];
        });
    } failure:^(NSError *error) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)getCollectStateRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"productUuid"] = self.uuid;
    data[@"type"] = @"2";//1:楼盘 2:户型 3:新闻资讯 4:营销活动
    parameters[@"data"] = data;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"sys/sys/collection/queryProduct" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if ([responseObject[@"code"] integerValue] == 0) {
            strongSelf.collectBtn.selected = [responseObject[@"data"][@"record"] boolValue]?YES:NO;
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)setCollectRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"productUuid"] = self.uuid;
    data[@"type"] = @"2";//1:楼盘 2:户型 3:新闻资讯 4:营销活动
    parameters[@"data"] = data;

    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"sys/sys/collection/productCollection" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if ([responseObject[@"code"] integerValue] == 0) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
            strongSelf.collectBtn.selected = !strongSelf.collectBtn.isSelected;
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
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCHouseStyleDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseStyleDetailCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.picUrl = self.houseInfo.housePic;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 260.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
