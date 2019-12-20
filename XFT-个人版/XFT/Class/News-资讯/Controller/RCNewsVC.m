//
//  RCNewsVC.m
//  XFT
//
//  Created by 夏增明 on 2019/8/26.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCNewsVC.h"
#import "RCNewsHeader.h"
#import "RCNewsCell.h"
#import "RCNewsDetailVC.h"
#import "RCHouseBanner.h"
#import "RCNews.h"

static NSString *const NewsCell = @"NewsCell";
@interface RCNewsVC ()<UITableViewDelegate,UITableViewDataSource>
/** 主视图 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 头视图 */
@property(nonatomic,strong) RCNewsHeader *header;
/* 轮播图 */
@property(nonatomic,strong) NSArray *banners;
/* 页码 */
@property (nonatomic,assign) NSInteger pagenum;
/* 资讯列表 */
@property(nonatomic,strong) NSMutableArray *newsList;
/* 记录上一个城市id */
@property(nonatomic,copy) NSString *cityID;
@end

@implementation RCNewsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableView];
    [self setUpRefresh];
    [self setUpEmptyView];
    [self startShimmer];
    hx_weakify(self);
    [self getNewsListDataRequest:YES completeCall:^{
        hx_strongify(weakSelf);
        [strongSelf.tableView reloadData];
        if (strongSelf.newsList.count) {
            [strongSelf.tableView ly_hideEmptyView];
        }else{
            [strongSelf.tableView ly_showEmptyView];
        }
    }];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.cityID = [[NSUserDefaults standardUserDefaults] objectForKey:HXCityCode];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 10.f+170.f);
}
-(void)setCityID:(NSString *)cityID
{
    if (!_cityID) {
        _cityID = cityID;
    }
    if (![_cityID isEqualToString:cityID]) {
        _cityID = cityID;
        hx_weakify(self);
        [self getNewsListDataRequest:YES completeCall:^{
            hx_strongify(weakSelf);
            [strongSelf.tableView reloadData];
            if (strongSelf.newsList.count) {
                [strongSelf.tableView ly_hideEmptyView];
            }else{
                [strongSelf.tableView ly_showEmptyView];
            }
        }];
    }
}
-(NSMutableArray *)newsList
{
    if (_newsList == nil) {
        _newsList = [NSMutableArray array];
    }
    return _newsList;
}
-(RCNewsHeader *)header
{
    if (_header == nil) {
        _header = [RCNewsHeader loadXibView];
        _header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 10.f+170.f);
        _header.newsBannerClicked = ^(NSInteger index) {
            
        };
    }
    return _header;
}
#pragma mark -- 视图
-(void)setUpTableView
{
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.contentInset = UIEdgeInsetsMake(0,0, 0, 0);
    _tableView.tableFooterView = [UIView new];
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCNewsCell class]) bundle:nil] forCellReuseIdentifier:NewsCell];
//    self.tableView.tableHeaderView = self.header;
}
-(void)setUpEmptyView
{
    LYEmptyView *emptyView = [LYEmptyView emptyViewWithImageStr:@"pic_none_search" titleStr:nil detailStr:@"暂无内容"];
    emptyView.contentViewOffset = -(self.HXNavBarHeight);
    emptyView.subViewMargin = 30.f;
    emptyView.detailLabTextColor = UIColorFromRGB(0x131D2D);
    emptyView.detailLabFont = [UIFont fontWithName:@"PingFangSC-Semibold" size: 16];
    emptyView.autoShowEmptyView = NO;
    self.tableView.ly_emptyView = emptyView;
}
/** 添加刷新控件 */
-(void)setUpRefresh
{
    hx_weakify(self);
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf.tableView.mj_footer resetNoMoreData];
        [strongSelf getNewsListDataRequest:YES completeCall:^{
            [strongSelf.tableView reloadData];
            if (strongSelf.newsList.count) {
                [strongSelf.tableView ly_hideEmptyView];
            }else{
                [strongSelf.tableView ly_showEmptyView];
            }
        }];
    }];
    //追加尾部刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf getNewsListDataRequest:NO completeCall:^{
            [strongSelf.tableView reloadData];
            if (strongSelf.newsList.count) {
                [strongSelf.tableView ly_hideEmptyView];
            }else{
                [strongSelf.tableView ly_showEmptyView];
            }
        }];
    }];
}
#pragma mark -- 接口请求
///** 轮播图列表查询 筛选条件查询*/
//-(void)getNewsDataRequest
//{
//    dispatch_group_t group = dispatch_group_create();
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
//    // 执行循序1
//    hx_weakify(self);
//    dispatch_group_async(group, queue, ^{
//        hx_strongify(weakSelf);
//        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//        NSMutableDictionary *data = [NSMutableDictionary dictionary];
//        data[@"cityId"] = [[NSUserDefaults standardUserDefaults] objectForKey:HXCityCode];
//        NSMutableDictionary *page = [NSMutableDictionary dictionary];
//        page[@"current"] = @"1";
//        page[@"size"] = @"10";
//        parameters[@"data"] = data;
//        parameters[@"page"] = page;
//
//        [HXNetworkTool POST:HXRC_M_URL action:@"marketing/marketing/xcxBanner/bannerList" parameters:parameters success:^(id responseObject) {
//            if ([responseObject[@"code"] integerValue] == 0) {
//                strongSelf.banners = [NSArray yy_modelArrayWithClass:[RCHouseBanner class] json:responseObject[@"data"]];
//            }else{
//                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
//            }
//            dispatch_semaphore_signal(semaphore);
//
//        } failure:^(NSError *error) {
//            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
//            dispatch_semaphore_signal(semaphore);
//
//        }];
//    });
//    // 执行循序2
//    dispatch_group_async(group, queue, ^{
//        hx_strongify(weakSelf);
//        [strongSelf getNewsListDataRequest:YES completeCall:^{
//            dispatch_semaphore_signal(semaphore);
//        }];
//    });
//    dispatch_group_notify(group, queue, ^{
//        // 执行循序4
//        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//        // 执行顺序6
//        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//
//        // 执行顺序10
//        dispatch_async(dispatch_get_main_queue(), ^{
//            // 刷新界面
//            hx_strongify(weakSelf);
//            [strongSelf stopShimmer];
//            strongSelf.header.banners = strongSelf.banners;
//            [strongSelf.tableView reloadData];
//        });
//    });
//}
/** 资讯列表请求 */
-(void)getNewsListDataRequest:(BOOL)isRefresh completeCall:(void(^)(void))completeCall
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"cityId"] = [[NSUserDefaults standardUserDefaults] objectForKey:HXCityCode];
    NSMutableDictionary *page = [NSMutableDictionary dictionary];
    if (isRefresh) {
        page[@"current"] = @(1);//第几页
    }else{
        NSInteger pagenum = self.pagenum+1;
        page[@"current"] = @(pagenum);//第几页
    }
    page[@"size"] = @"10";
    parameters[@"data"] = data;
    parameters[@"page"] = page;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"pro/pro/information/infList" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if ([responseObject[@"code"] integerValue] == 0) {
            if (isRefresh) {
                [strongSelf.tableView.mj_header endRefreshing];
                strongSelf.pagenum = 1;
                [strongSelf.newsList removeAllObjects];
                NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCNews class] json:responseObject[@"data"]];
                [strongSelf.newsList addObjectsFromArray:arrt];
            }else{
                [strongSelf.tableView.mj_footer endRefreshing];
                strongSelf.pagenum ++;
                if ([responseObject[@"data"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"data"]).count){
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCNews class] json:responseObject[@"data"]];
                    [strongSelf.newsList addObjectsFromArray:arrt];
                }else{// 提示没有更多数据
                    [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
            if (completeCall) {
                completeCall();
            }
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.newsList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:NewsCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    RCNews *news = self.newsList[indexPath.row];
    cell.news = news;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 130.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCNewsDetailVC *dvc = [RCNewsDetailVC new];
    RCNews *news = self.newsList[indexPath.row];
    dvc.uuid = news.uuid;
    dvc.lookSuccessCall = ^{
        news.clickNum = [NSString stringWithFormat:@"%zd",[news.clickNum integerValue]+1];
        [tableView reloadData];
    };
    [self.navigationController pushViewController:dvc animated:YES];
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 60.f;
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 0.1f;
//}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UILabel *label = [[UILabel alloc] init];
//    label.backgroundColor = [UIColor whiteColor];
//    label.font = [UIFont systemFontOfSize:20 weight:UIFontWeightMedium];
//    label.text = @"   新闻资讯";
//
//    return label;
//}
@end
