//
//  RCHouseChildVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/6.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCHouseChildVC.h"
#import "RCHouseCell.h"
#import "RCHouseDetailVC.h"
#import "RCHouseFilterView.h"
#import "RCPageMainTable.h"
#import "RCHouseFilterData.h"
#import "RCHouseList.h"

static NSString *const HouseCell = @"HouseCell";

@interface RCHouseChildVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 筛选 */
@property(nonatomic,strong) RCHouseFilterView *filterView;
/** 是否滑动 */
@property(nonatomic,assign)BOOL isCanScroll;
/* 筛选数据 */
@property(nonatomic,strong) RCHouseFilterData *filterData;
/* 行政区域 */
@property(nonatomic,copy) NSString *countryUuid;
/* 物业类型 */
@property(nonatomic,copy) NSString *buldType;
/* 户型 */
@property(nonatomic,copy) NSString *hxType;
/* 建筑面积 */
@property(nonatomic,copy) NSString *areaType;
/* 页码 */
@property (nonatomic,assign) NSInteger pagenum;
/* 房源列表 */
@property(nonatomic,strong) NSMutableArray *houses;
@end

@implementation RCHouseChildVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(childScrollHandle:) name:@"childScrollCan" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(childScrollHandle:) name:@"MainTableScroll" object:nil];
    [self setUpTableView];
    [self setUpRefresh];
    [self getHouseDataRequest];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.view.hxn_width = HX_SCREEN_WIDTH;
}
-(void)setCountryUuid:(NSString *)countryUuid
{
    if (![_countryUuid isEqualToString:countryUuid]) {
        _countryUuid = countryUuid;
        hx_weakify(self);
        [self getHouseListDataRequest:YES scrollView:self.tableView completeCall:^{
            [weakSelf.tableView reloadData];
        }];
    }
}
-(void)setBuldType:(NSString *)buldType
{
    if (![_buldType isEqualToString:buldType]) {
        _buldType = buldType;
        hx_weakify(self);
        [self getHouseListDataRequest:YES scrollView:self.tableView completeCall:^{
            [weakSelf.tableView reloadData];
        }];
    }
}
-(void)setHxType:(NSString *)hxType
{
    if (![_hxType isEqualToString:hxType]) {
        _hxType = hxType;
        hx_weakify(self);
        [self getHouseListDataRequest:YES scrollView:self.tableView completeCall:^{
            [weakSelf.tableView reloadData];
        }];
    }
}
-(void)setAreaType:(NSString *)areaType
{
    if (![_areaType isEqualToString:areaType]) {
        _areaType = areaType;
        hx_weakify(self);
        [self getHouseListDataRequest:YES scrollView:self.tableView completeCall:^{
            [weakSelf.tableView reloadData];
        }];
    }
}
-(NSMutableArray *)houses
{
    if (_houses == nil) {
        _houses = [NSMutableArray array];
    }
    return _houses;
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCHouseCell class]) bundle:nil] forCellReuseIdentifier:HouseCell];
}
/** 添加刷新控件 */
-(void)setUpRefresh
{
    hx_weakify(self);
//    self.tableView.mj_header.automaticallyChangeAlpha = YES;
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        hx_strongify(weakSelf);
//        [strongSelf.tableView.mj_footer resetNoMoreData];
//        [strongSelf getNoticeListDataRequest:YES];
//    }];
    //追加尾部刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf getHouseListDataRequest:NO scrollView:strongSelf.tableView completeCall:^{
            [strongSelf.tableView reloadData];
        }];
    }];
}
-(void)refreshData:(UIScrollView *)table
{
    [self.tableView.mj_footer resetNoMoreData];
    hx_weakify(self);
    [self getHouseListDataRequest:YES scrollView:table completeCall:^{
        hx_strongify(weakSelf);
        [strongSelf.tableView reloadData];
    }];
}
#pragma mark -- 通知处理
-(void)childScrollHandle:(NSNotification *)user{
    if ([user.name isEqualToString:@"childScrollCan"]){
        self.isCanScroll = YES;
    }else if ([user.name isEqualToString:@"MainTableScroll"]){
        self.isCanScroll = NO;
        [self.tableView setContentOffset:CGPointZero];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (!self.isCanScroll) {
        [scrollView setContentOffset:CGPointZero];
    }
    if (scrollView.contentOffset.y<=0) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"MainTableScroll" object:nil];
    }
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark -- 接口查询
/** 列表查询 筛选条件查询*/
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
        data[@"cityUuid"] = [[NSUserDefaults standardUserDefaults] objectForKey:HXCityCode];
        parameters[@"data"] = data;
        
        [HXNetworkTool POST:HXRC_M_URL action:@"sys/sys/dict/dictalllist" parameters:parameters success:^(id responseObject) {
            if ([responseObject[@"code"] integerValue] == 0) {
                RCHouseFilterData *filterData = [RCHouseFilterData yy_modelWithDictionary:responseObject[@"data"]];
                NSMutableArray *areaType = [NSMutableArray arrayWithArray:filterData.areaType];
                RCHouseFilterArea *area = [[RCHouseFilterArea alloc] init];
                area.dictCode = @"";
                area.dictName = @"全部";
                [areaType insertObject:area atIndex:0];
                filterData.areaType = areaType;
                
                NSMutableArray *buldType = [NSMutableArray arrayWithArray:filterData.buldType];
                RCHouseFilterService *buld = [[RCHouseFilterService alloc] init];
                buld.dictCode = @"";
                buld.dictName = @"全部";
                [buldType insertObject:buld atIndex:0];
                filterData.buldType = buldType;
                
                NSMutableArray *countryList = [NSMutableArray arrayWithArray:filterData.countryList];
                RCHouseFilterDistrict *country = [[RCHouseFilterDistrict alloc] init];
                country.uuid = @"";
                country.name = @"全部";
                [countryList insertObject:country atIndex:0];
                filterData.countryList = countryList;
                
                NSMutableArray *hxType = [NSMutableArray arrayWithArray:filterData.hxType];
                RCHouseFilterStyle *hx = [[RCHouseFilterStyle alloc] init];
                hx.dictCode = @"";
                hx.dictName = @"全部";
                [hxType insertObject:hx atIndex:0];
                filterData.hxType = hxType;
               
                strongSelf.filterData = filterData;
            }else{
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
            }
            dispatch_semaphore_signal(semaphore);
        } failure:^(NSError *error) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
            dispatch_semaphore_signal(semaphore);
        }];
    });
    dispatch_group_async(group, queue, ^{
        hx_strongify(weakSelf);
        [strongSelf getHouseListDataRequest:YES scrollView:strongSelf.tableView completeCall:^{
            dispatch_semaphore_signal(semaphore);
        }];
    });

    dispatch_group_notify(group, queue, ^{
        // 执行循序4
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        // 执行顺序6
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

        // 执行顺序10
        dispatch_async(dispatch_get_main_queue(), ^{
            // 刷新界面
            hx_strongify(weakSelf);
            strongSelf.tableView.hidden = NO;
            [strongSelf.tableView reloadData];
        });
    });
}
/** 房源筛选列表 */
-(void)getHouseListDataRequest:(BOOL)isRefresh scrollView:(UIScrollView *)scrollView completeCall:(void(^)(void))completeCall
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"cityUuid"] = [[NSUserDefaults standardUserDefaults] objectForKey:HXCityCode];
    data[@"areaType"] = (self.areaType && self.areaType.length) ?self.areaType:@"";
    data[@"buldType"] = (self.buldType && self.buldType.length) ?self.buldType:@"";
    data[@"countryUuid"] = (self.countryUuid && self.countryUuid.length) ?self.countryUuid:@"";
    data[@"hxType"] = (self.hxType && self.hxType.length) ?self.hxType:@"";
    data[@"proType"] = self.proType;
  
    NSMutableDictionary *page = [NSMutableDictionary dictionary];
    if (isRefresh) {
        page[@"current"] = @(1);//第几页
        [self.tableView.mj_footer resetNoMoreData];
    }else{
        NSInteger pagenum = self.pagenum+1;
        page[@"current"] = @(pagenum);//第几页
    }
    page[@"size"] = @"10";
    parameters[@"data"] = data;
    parameters[@"page"] = page;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"pro/pro/proBaseInfo/proListByLike" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if ([responseObject[@"code"] integerValue] == 0) {
            if (isRefresh) {
                [scrollView.mj_header endRefreshing];
                strongSelf.pagenum = 1;
                [strongSelf.houses removeAllObjects];
                NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCHouseList class] json:responseObject[@"data"][@"records"]];
                [strongSelf.houses addObjectsFromArray:arrt];
            }else{
                [scrollView.mj_footer endRefreshing];
                strongSelf.pagenum ++;
                if ([responseObject[@"data"][@"records"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"data"][@"records"]).count){
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCHouseList class] json:responseObject[@"data"][@"records"]];
                    [strongSelf.houses addObjectsFromArray:arrt];
                }else{// 提示没有更多数据
                    [scrollView.mj_footer endRefreshingWithNoMoreData];
                }
            }
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
        if (completeCall) {
            completeCall();
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
        [scrollView.mj_header endRefreshing];
        [scrollView.mj_footer endRefreshing];
        if (completeCall) {
            completeCall();
        }
    }];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.houses.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCHouseCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    RCHouseList *house = self.houses[indexPath.row];
    cell.house = house;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.filterView) {
        self.filterView.target = self.parentViewController;
        self.filterView.tableView = self.mainTable;
        self.filterView.filterData = self.filterData;
        hx_weakify(self);
        self.filterView.HouseFilterCall = ^(NSInteger btnTag, NSInteger index) {
            if (btnTag == 1) {
                RCHouseFilterDistrict *dus = weakSelf.filterData.countryList[index];
                weakSelf.countryUuid = dus.uuid;
            }else if (btnTag == 2) {
                RCHouseFilterService *ser = weakSelf.filterData.buldType[index];
                weakSelf.buldType = ser.dictCode;
            }else if (btnTag == 3) {
                RCHouseFilterStyle *sty = weakSelf.filterData.hxType[index];
                weakSelf.hxType = sty.dictCode;
            }else{
                RCHouseFilterArea *area = weakSelf.filterData.areaType[index];
                weakSelf.areaType = area.dictCode;
            }
        };
        return self.filterView;
    }
    RCHouseFilterView *filterView = [RCHouseFilterView loadXibView];
    filterView.frame = CGRectMake(0, 60.f, HX_SCREEN_WIDTH, 44.f);
    filterView.target = self.parentViewController;//父控制器
    filterView.tableView = self.mainTable;
    filterView.filterData = self.filterData;
    self.filterView = filterView;
    return filterView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 165.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCHouseDetailVC *dvc = [RCHouseDetailVC new];
    RCHouseList *house = self.houses[indexPath.row];
    dvc.uuid = house.uuid;
    [self.navigationController pushViewController:dvc animated:YES];
}

@end
