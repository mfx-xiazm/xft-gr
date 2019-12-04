//
//  RCProfileCollectChildVC.m
//  XFT
//
//  Created by 夏增明 on 2019/8/29.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCProfileCollectChildVC.h"
#import "RCNewsCell.h"
#import "RCHouseCell.h"
#import "RCProfileCollectCell.h"
#import "RCHouseDetailVC.h"
#import "RCHouseStyleVC.h"
#import "RCNewsDetailVC.h"
#import "RCMyCollectHouse.h"
#import "RCMyCollectStyle.h"
#import "RCMyCollectNews.h"

static NSString *const NewsCell = @"NewsCell";
static NSString *const HouseCell = @"HouseCell";
static NSString *const ProfileCollectCell = @"ProfileCollectCell";

@interface RCProfileCollectChildVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 页码 */
@property (nonatomic,assign) NSInteger pagenum;
/* 列表 */
@property(nonatomic,strong) NSMutableArray *collects;
@end

@implementation RCProfileCollectChildVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"我的收藏"];
    [self setUpTableView];
    [self setUpEmptyView];
    [self setUpRefresh];
    [self startShimmer];
    [self getCollectDataRequest:YES];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.view.hxn_width = HX_SCREEN_WIDTH;
}
-(NSMutableArray *)collects
{
    if (_collects == nil) {
        _collects = [NSMutableArray array];
    }
    return _collects;
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
    self.tableView.estimatedRowHeight = 100;//预估高度
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 设置背景色为clear
    self.tableView.backgroundColor = [UIColor clearColor];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCNewsCell class]) bundle:nil] forCellReuseIdentifier:NewsCell];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCHouseCell class]) bundle:nil] forCellReuseIdentifier:HouseCell];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCProfileCollectCell class]) bundle:nil] forCellReuseIdentifier:ProfileCollectCell];
    
}
/** 添加刷新控件 */
-(void)setUpRefresh
{
    hx_weakify(self);
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf.tableView.mj_footer resetNoMoreData];
        [strongSelf getCollectDataRequest:YES];
    }];
    //追加尾部刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf getCollectDataRequest:NO];
    }];
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
/** 资讯列表请求 */
-(void)getCollectDataRequest:(BOOL)isRefresh
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"type"] = @(self.collectType);
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
    [HXNetworkTool POST:HXRC_M_URL action:@"sys/sys/collection/queryByTypeMyCollection" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if ([responseObject[@"code"] integerValue] == 0) {
            if (isRefresh) {
                [strongSelf.tableView.mj_header endRefreshing];
                strongSelf.pagenum = 1;
                [strongSelf.collects removeAllObjects];
                if (strongSelf.collectType == 1) {
                    for (NSDictionary *dict in responseObject[@"data"][@"records"]) {
                        [strongSelf.collects addObject:[RCMyCollectHouse yy_modelWithDictionary:dict[@"proCollectPro"]]];
                    }
                }else if (strongSelf.collectType == 2) {
                    for (NSDictionary *dict in responseObject[@"data"][@"records"]) {
                        [strongSelf.collects addObject:[RCMyCollectStyle yy_modelWithDictionary:dict[@"proCollectHuxing"]]];
                    }
                }else{
                    for (NSDictionary *dict in responseObject[@"data"][@"records"]) {
                        [strongSelf.collects addObject:[RCMyCollectNews yy_modelWithDictionary:dict[@"responseProInformationCollection"]]];
                    }
                }
            }else{
                [strongSelf.tableView.mj_footer endRefreshing];
                strongSelf.pagenum ++;
                if ([responseObject[@"data"][@"records"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"data"][@"records"]).count){
                    if (strongSelf.collectType == 1) {
                        for (NSDictionary *dict in responseObject[@"data"][@"records"]) {
                            [strongSelf.collects addObject:[RCMyCollectHouse yy_modelWithDictionary:dict[@"proCollectPro"]]];
                        }
                    }else if (strongSelf.collectType == 2) {
                        for (NSDictionary *dict in responseObject[@"data"][@"records"]) {
                            [strongSelf.collects addObject:[RCMyCollectStyle yy_modelWithDictionary:dict[@"proCollectHuxing"]]];
                        }
                    }else{
                        for (NSDictionary *dict in responseObject[@"data"][@"records"]) {
                            [strongSelf.collects addObject:[RCMyCollectNews yy_modelWithDictionary:dict[@"responseProInformationCollection"]]];
                        }
                    }
                }else{// 提示没有更多数据
                    [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.tableView reloadData];
                if (strongSelf.collects.count || strongSelf.collects.count) {
                    [strongSelf.tableView ly_hideEmptyView];
                }else{
                    [strongSelf.tableView ly_showEmptyView];
                }
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
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.collects.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.collectType == 1) {
        RCHouseCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseCell forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        RCMyCollectHouse *collect = self.collects[indexPath.row];
        cell.collect = collect;
        return cell;
    }else if (self.collectType == 2) {
        RCProfileCollectCell *cell = [tableView dequeueReusableCellWithIdentifier:ProfileCollectCell forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        RCMyCollectStyle *style = self.collects[indexPath.row];
        cell.style = style;
        return cell;
    }else{
        RCNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:NewsCell forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        RCMyCollectNews *news = self.collects[indexPath.row];
        cell.collectNews = news;
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    if (self.collectType == 1) {
        return 165.f;
    }else if (self.collectType == 2) {
        return 130.f;
    }else{
        return 130.f;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.collectType == 1) {
        RCHouseDetailVC *dvc = [RCHouseDetailVC new];
        RCMyCollectHouse *collect = self.collects[indexPath.row];
        dvc.uuid = collect.uuid;
        [self.navigationController pushViewController:dvc animated:YES];
    }else if (self.collectType == 2) {
        RCHouseStyleVC *svc = [RCHouseStyleVC new];
        RCMyCollectStyle *style = self.collects[indexPath.row];
        svc.uuid = style.uuid;
        svc.housePhone = style.salesTel;
        [self.navigationController pushViewController:svc animated:YES];
    }else{
        RCNewsDetailVC *dvc = [RCNewsDetailVC new];
        RCMyCollectNews *news = self.collects[indexPath.row];
        dvc.uuid = news.uuid;
        [self.navigationController pushViewController:dvc animated:YES];
    }
}

@end
