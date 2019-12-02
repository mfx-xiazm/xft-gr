//
//  RCHouseVC.m
//  XFT
//
//  Created by 夏增明 on 2019/8/26.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCHouseVC.h"
#import "RCHouseHeader.h"
#import "RCSearchHouseVC.h"
#import "RCSearchCityVC.h"
#import "RCNoticeVC.h"
#import "RCMapToHouseVC.h"
#import "RCPageMainTable.h"
#import "RCHouseChildVC.h"
#import "RCHouseCategoryView.h"
#import "HXNavigationController.h"
#import "RCLoginVC.h"
#import "zhAlertView.h"
#import <zhPopupController.h>
#import "RCHouseBanner.h"
#import "RCHouseNotice.h"
#import "RCHouceCate.h"

@interface RCHouseVC ()<UITableViewDelegate,UITableViewDataSource>
/** tableView */
@property (weak, nonatomic) IBOutlet RCPageMainTable *tableView;
/* 登录按钮 */
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
/* 头视图 */
@property(nonatomic,strong) RCHouseHeader *header;
/* 筛选 */
@property(nonatomic,strong) RCHouseCategoryView *categoryView;
/** 子控制器承载scr */
@property (nonatomic,strong) UIScrollView *scrollView;
/** 子控制器数组 */
@property (nonatomic,strong) NSArray *childVCs;
/** 是否可以滑动 */
@property(nonatomic,assign)BOOL isCanScroll;
/* 定位按钮 */
@property(nonatomic,strong) SPButton *locationBtn;
/* 轮播图 */
@property(nonatomic,strong) NSArray *banners;
/* 公告 */
@property(nonatomic,strong) NSArray *notices;
/* 房源分类 */
@property(nonatomic,strong) NSArray *cates;
/* 选择的城市名称 */
@property(nonatomic,copy) NSString *chooseCity;
@end

@implementation RCHouseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"幸福通"];
    self.loginBtn.hidden = [MSUserManager sharedInstance].isLogined?YES:NO;
    self.isCanScroll = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MainTableScroll:) name:@"MainTableScroll" object:nil];
    [self setUpNavBar];
    //[self queryAppVersion];
    [self startShimmer];
    [self getCityRequest];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.header.frame = CGRectMake(0, -(10.f+170.f+50.f), HX_SCREEN_WIDTH, 10.f+170.f+50.f);
    self.categoryView.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 60.f);
}
-(RCHouseHeader *)header
{
    if (_header == nil) {
        _header = [RCHouseHeader loadXibView];
        _header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 10.f+170.f+50.f);
        hx_weakify(self);
        _header.houseHeaderBtnClicked = ^(NSInteger type, NSInteger index) {
            if (type == 0) {
                RCNoticeVC *nvc = [RCNoticeVC new];
                nvc.navTitle = @"公告";
                [weakSelf.navigationController pushViewController:nvc animated:YES];
            }else{
                /*展现方式 0:不跳转 1:新闻咨询 2:报名活动 3房源详情 4:外链H5 5:城市公告 6:视频播放*/
            }
        };
    }
    return _header;
}
-(RCHouseCategoryView *)categoryView
{
    if (_categoryView == nil) {
        _categoryView = [RCHouseCategoryView loadXibView];
        _categoryView.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 60.f);
        hx_weakify(self);
        _categoryView.mapToHouseCall = ^{
            RCMapToHouseVC *hvc = [RCMapToHouseVC new];
            hvc.cityName = weakSelf.locationBtn.currentTitle;
            [weakSelf.navigationController pushViewController:hvc animated:YES];
        };
    }
    return _categoryView;
}
-(NSArray *)childVCs
{
    if (_childVCs == nil) {
        NSMutableArray *vcs = [NSMutableArray array];
        for (int i=0;i<self.cates.count;i++) {
            RCHouceCate *cate = self.cates[i];
            RCHouseChildVC *cvc0 = [RCHouseChildVC new];
            cvc0.proType = cate.dictCode;
            cvc0.mainTable = self.tableView;
            [self addChildViewController:cvc0];
            [vcs addObject:cvc0];
        }
        _childVCs = vcs;
    }
    return _childVCs;
}
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(0, 60.f, HX_SCREEN_WIDTH, HX_SCREEN_HEIGHT-self.HXNavBarHeight-self.HXTabBarHeight - 60.f);
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(HX_SCREEN_WIDTH*self.childVCs.count, 0);
        // 加第一个视图
        UIViewController *targetViewController = self.childVCs.firstObject;
        targetViewController.view.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, _scrollView.hxn_height);
        [_scrollView addSubview:targetViewController.view];
    }
    return  _scrollView;
}
-(void)setChooseCity:(NSString *)chooseCity
{
    if (![_chooseCity isEqualToString:chooseCity]) {
        _chooseCity = chooseCity;
        [self getCityRequest];
    }
}
#pragma mark -- 视图相关
-(void)setUpNavBar
{
    SPButton *item = [[SPButton alloc] initWithImagePosition:SPButtonImagePositionLeft];
    item.hxn_size = CGSizeMake(70, 30);
    item.imageTitleSpace = 5.f;
    item.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    [item setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [item setImage:HXGetImage(@"icon_home_place") forState:UIControlStateNormal];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:HXUserCityName]) {
        [item setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:HXUserCityName] forState:UIControlStateNormal];
    }else{
        [item setTitle:@"武汉" forState:UIControlStateNormal];
    }
    [item addTarget:self action:@selector(cityClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.locationBtn = item;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:item];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(searchClicked) nomalImage:HXGetImage(@"icon_top_search") higeLightedImage:HXGetImage(@"icon_top_search") imageEdgeInsets:UIEdgeInsetsZero];
}
/**
 初始化tableView
 */
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
    
    self.tableView.contentInset = UIEdgeInsetsMake(10.f+170.f+50.f,0, 0, 0);

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 设置背景色为clear
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.tableView.tableFooterView = [UIView new];
    //    hx_weakify(self);
    //    __weak __typeof(BBPageMainTable *) weakTable = _mainTable;
    //    _mainTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    //        hx_strongify(weakSelf);
    //        BBExcellentShopChildVC *cv = strongSelf.childVCs[strongSelf.pageMenu.selectedItemIndex];
    //        [cv refreshData:weakTable];
    //    }];
    //    _mainTable.mj_header.ignoredScrollViewContentInsetTop = (self.type != 2)?(HX_SCREEN_WIDTH*2/5.0 + (HX_SCREEN_WIDTH*4/5.0)*2 +10):(HX_SCREEN_WIDTH*2/5.0 + 10);
    //    _mainTable.mj_header.automaticallyChangeAlpha = YES;
    
    [self.tableView addSubview:self.header];
}
#pragma mark -- 主视图滑动通知处理
-(void)MainTableScroll:(NSNotification *)user{
    self.isCanScroll = YES;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.tableView) {
        CGFloat tabOffsetY = [self.tableView rectForSection:0].origin.y;
        CGFloat offsetY = scrollView.contentOffset.y;
        if (offsetY>=tabOffsetY) {
            self.isCanScroll = NO;
            scrollView.contentOffset = CGPointMake(0, 0);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"childScrollCan" object:nil];
        }else{
            if (!self.isCanScroll) {
                [scrollView setContentOffset:CGPointZero];
            }
        }
    }
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark -- 点击事件
- (IBAction)loginClicked:(UIButton *)sender {
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
-(void)cityClicked
{
    RCSearchCityVC *hvc = [RCSearchCityVC new];
    hx_weakify(self);
    hvc.changeCityCall = ^(NSString * _Nonnull city) {
        hx_strongify(weakSelf);
        strongSelf.chooseCity = city;
        [strongSelf.locationBtn setTitle:city forState:UIControlStateNormal];
    };
    [self.navigationController pushViewController:hvc animated:YES];
}
-(void)searchClicked
{
    RCSearchHouseVC *hvc = [RCSearchHouseVC new];
    [self.navigationController pushViewController:hvc animated:YES];
}
#pragma mark -- 版本升级
-(void)queryAppVersion
{
    hx_weakify(self);
    [self queryAppVersionRequest:^(NSDictionary *version) {
        hx_strongify(weakSelf);
        //                currentVersion  最新版本号
        //                downlondUrl 下载地址
        //                isForce    是否强制更新 0不强制 1强制
        //                upremark 更新内容
        zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"更新版本" message:[NSString stringWithFormat:@"%@",version[@"upremark"]] constantWidth:HX_SCREEN_WIDTH - 50*2];
        zhAlertButton *cancelButton = [zhAlertButton buttonWithTitle:@"取消" handler:^(zhAlertButton * _Nonnull button) {
            [strongSelf.zh_popupController dismiss];
        }];
        zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"下载" handler:^(zhAlertButton * _Nonnull button) {
            [strongSelf.zh_popupController dismiss];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",version[@"downlondUrl"]]]];
        }];
        cancelButton.lineColor = UIColorFromRGB(0xDDDDDD);
        [cancelButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        okButton.lineColor = UIColorFromRGB(0xDDDDDD);
        [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
        
        strongSelf.zh_popupController = [[zhPopupController alloc] init];
        if ([version[@"isForce"] integerValue] == 0) {
            strongSelf.zh_popupController.dismissOnMaskTouched = YES;
            [alert adjoinWithLeftAction:cancelButton rightAction:okButton];
        }else{
            strongSelf.zh_popupController.dismissOnMaskTouched = NO;
            [alert addAction:okButton];
        }
        [strongSelf.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
    }];
}
-(void)queryAppVersionRequest:(void(^)(NSDictionary *version))completedCall
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"applicationMarket"] = @"";
    NSString *key = @"CFBundleShortVersionString";
    // 当前软件的版本号（从Info.plist中获得）
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    data[@"currentVersion"] = currentVersion;
    
    parameters[@"data"] = data;
    
    [HXNetworkTool POST:HXRC_M_URL action:@"sys/sys/appversion/queryAppVersion" parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
                if (((NSDictionary *)responseObject[@"data"]).allKeys.count) {
                    if (![(NSString *)responseObject[@"data"][@"upVesion"] isEqualToString:currentVersion]) {
                        if (completedCall) {
                            completedCall(responseObject[@"data"]);
                        }
                    }
                }else{
                    [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
                }
            }
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
#pragma mark -- 接口请求
/** 城市模糊查询列表 */
-(void)getCityRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    if (self.chooseCity && self.chooseCity.length) {
        data[@"name"] = self.chooseCity;
    }else if ([[NSUserDefaults standardUserDefaults] objectForKey:HXUserCityName]) {
        data[@"name"] = [[NSUserDefaults standardUserDefaults] objectForKey:HXUserCityName];
    }else{
        data[@"name"] = @"武汉";
    }
    parameters[@"data"] = data;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"sys/sys/city/cityCodeByNameLike" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if ([responseObject[@"code"] integerValue] == 0) {
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"][@"cityCode"] forKey:HXCityCode];
//            [[NSUserDefaults standardUserDefaults] setObject:@"500100" forKey:HXCityCode];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [strongSelf getHouseDataRequest];
        }else{
            [strongSelf stopShimmer];
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
/** 轮播图列表查询 筛选条件查询*/
-(void)getHouseDataRequest
{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    // 执行循序1
    hx_weakify(self);
    dispatch_group_async(group, queue, ^{
        hx_strongify(weakSelf);
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        NSMutableDictionary *data = [NSMutableDictionary dictionary];
        data[@"cityId"] = [[NSUserDefaults standardUserDefaults] objectForKey:HXCityCode];
        NSMutableDictionary *page = [NSMutableDictionary dictionary];
        page[@"current"] = @"1";
        page[@"size"] = @"10";
        parameters[@"data"] = data;
        parameters[@"page"] = page;

        [HXNetworkTool POST:HXRC_M_URL action:@"marketing/marketing/xcxBanner/bannerList" parameters:parameters success:^(id responseObject) {
            if ([responseObject[@"code"] integerValue] == 0) {
                strongSelf.banners = [NSArray yy_modelArrayWithClass:[RCHouseBanner class] json:responseObject[@"data"]];
            }else{
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
            }
            dispatch_semaphore_signal(semaphore);

        } failure:^(NSError *error) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
            dispatch_semaphore_signal(semaphore);

        }];
    });
    // 执行循序2
    dispatch_group_async(group, queue, ^{
        hx_strongify(weakSelf);
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        NSMutableDictionary *data = [NSMutableDictionary dictionary];
        data[@"cityId"] = [[NSUserDefaults standardUserDefaults] objectForKey:HXCityCode];
        data[@"num"] = @"1";
        NSMutableDictionary *page = [NSMutableDictionary dictionary];
        page[@"current"] = @"1";
        page[@"size"] = @"1";
        parameters[@"data"] = data;
        parameters[@"page"] = page;
        
        [HXNetworkTool POST:HXRC_M_URL action:@"pro/pro/notice/noticeList" parameters:parameters success:^(id responseObject) {
            if ([responseObject[@"code"] integerValue] == 0) {
                strongSelf.notices = [NSArray yy_modelArrayWithClass:[RCHouseNotice class] json:responseObject[@"data"]];
            }else{
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
            }
            dispatch_semaphore_signal(semaphore);
        } failure:^(NSError *error) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
            dispatch_semaphore_signal(semaphore);
        }];
    });
    // 执行循序3
    dispatch_group_async(group, queue, ^{
        hx_strongify(weakSelf);
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        NSMutableDictionary *data = [NSMutableDictionary dictionary];
        data[@"parentDictCode"] = @"4";
        parameters[@"data"] = data;
        
        [HXNetworkTool POST:HXRC_M_URL action:@"sys/sys/dict/dictList" parameters:parameters success:^(id responseObject) {
            if ([responseObject[@"code"] integerValue] == 0) {
                strongSelf.cates = [NSArray yy_modelArrayWithClass:[RCHouceCate class] json:responseObject[@"data"]];
            }else{
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
            }
            dispatch_semaphore_signal(semaphore);
        } failure:^(NSError *error) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
            dispatch_semaphore_signal(semaphore);
        }];
    });

    dispatch_group_notify(group, queue, ^{
        // 执行循序4
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        // 执行顺序6
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        // 执行顺序8
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

        // 执行顺序10
        dispatch_async(dispatch_get_main_queue(), ^{
            // 刷新界面
            hx_strongify(weakSelf);
            [strongSelf stopShimmer];
            [strongSelf handleHouseData];
        });
    });
}
-(void)handleHouseData
{
    self.tableView.hidden = NO;
    
    self.header.banners = self.banners;
    self.header.notices = self.notices;
    
    self.categoryView.scrollView = self.scrollView;
    self.categoryView.childVCs = self.childVCs;
    self.categoryView.cates = self.cates;
    
    [self setUpTableView];
        
    [self.tableView reloadData];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeCityToRefresh" object:nil];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return self.view.hxn_height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // 添加pageView
    [cell.contentView addSubview:self.scrollView];
    self.categoryView.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 60.f);
    [cell.contentView addSubview:self.categoryView];
    
    return cell;
}

@end
