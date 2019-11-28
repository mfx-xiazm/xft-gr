//
//  RCMyAppointVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/7.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCMyAppointVC.h"
#import "RCMyAppointCell.h"
#import "RCVisitCommentVC.h"
#import "RCMyAppoint.h"
#import "RCMyAppointFooter.h"
#import "RCHouseDetailVC.h"

static NSString *const MyAppointCell = @"MyAppointCell";

@interface RCMyAppointVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 页码 */
@property (nonatomic,assign) NSInteger pagenum;
/* 列表 */
@property(nonatomic,strong) NSMutableArray *appoints;
@end

@implementation RCMyAppointVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"我的预约"];
    [self setUpTableView];
    [self setUpEmptyView];
    [self setUpRefresh];
    [self startShimmer];
    [self getAppointDataRequest:YES];
}
-(NSMutableArray *)appoints
{
    if (_appoints == nil) {
        _appoints = [NSMutableArray array];
    }
    return _appoints;
}
#pragma mark -- 视图相关
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCMyAppointCell class]) bundle:nil] forCellReuseIdentifier:MyAppointCell];
}
/** 添加刷新控件 */
-(void)setUpRefresh
{
    hx_weakify(self);
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf.tableView.mj_footer resetNoMoreData];
        [strongSelf getAppointDataRequest:YES];
    }];
    //追加尾部刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf getAppointDataRequest:NO];
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
/** 预约列表请求 */
-(void)getAppointDataRequest:(BOOL)isRefresh
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *page = [NSMutableDictionary dictionary];
    if (isRefresh) {
        page[@"current"] = @(1);//第几页
    }else{
        NSInteger pagenum = self.pagenum+1;
        page[@"current"] = @(pagenum);//第几页
    }
    page[@"size"] = @"10";
    parameters[@"data"] = @{};
    parameters[@"page"] = page;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"cus/cus/probaseinfo/getProBaseInfo" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if ([responseObject[@"code"] integerValue] == 0) {
            if (isRefresh) {
                [strongSelf.tableView.mj_header endRefreshing];
                strongSelf.pagenum = 1;
                [strongSelf.appoints removeAllObjects];
                NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCMyAppoint class] json:responseObject[@"data"][@"records"]];
                [strongSelf.appoints addObjectsFromArray:arrt];
            }else{
                [strongSelf.tableView.mj_footer endRefreshing];
                strongSelf.pagenum ++;
                if ([responseObject[@"data"][@"records"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"data"][@"records"]).count){
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCMyAppoint class] json:responseObject[@"data"][@"records"]];
                    [strongSelf.appoints addObjectsFromArray:arrt];
                }else{// 提示没有更多数据
                    [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.tableView reloadData];
                if (strongSelf.appoints.count || strongSelf.appoints.count) {
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.appoints.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCMyAppointCell *cell = [tableView dequeueReusableCellWithIdentifier:MyAppointCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    RCMyAppoint *appoint = self.appoints[indexPath.section];
    cell.appoint = appoint;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 190.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    RCMyAppoint *appoint = self.appoints[section];
    if ([appoint.state isEqualToString:@"2"] && [appoint.questionnaire isEqualToString:@"2"]) {
        return 105.f;
    }else{
        return CGFLOAT_MIN;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    RCMyAppoint *appoint = self.appoints[section];
    if ([appoint.state isEqualToString:@"2"] && [appoint.questionnaire isEqualToString:@"2"]) {
        RCMyAppointFooter *footer = [RCMyAppointFooter loadXibView];
        footer.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 105.f);
        hx_weakify(self);
        footer.doneAppointCall = ^{
            RCVisitCommentVC *cmc = [RCVisitCommentVC new];
            cmc.proUuid = appoint.productUuid;
            cmc.submitCall = ^{
                appoint.questionnaire = @"1";
                [tableView reloadData];
            };
            [weakSelf.navigationController pushViewController:cmc animated:YES];
        };
        return footer;
    }else{
        return nil;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCMyAppoint *appoint = self.appoints[indexPath.section];
    RCHouseDetailVC *dvc = [RCHouseDetailVC new];
    dvc.uuid = appoint.productUuid;
    [self.navigationController pushViewController:dvc animated:YES];
}



@end
