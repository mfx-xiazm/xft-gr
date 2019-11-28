//
//  RCNoticeVC.m
//  XFT
//
//  Created by 夏增明 on 2019/8/28.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCNoticeVC.h"
#import "RCNoticeCell.h"
#import "RCNoticeDetialVC.h"
#import "RCHouseNotice.h"
#import "RCInnerMsg.h"

static NSString *const NoticeCell = @"NoticeCell";

@interface RCNoticeVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 页码 */
@property (nonatomic,assign) NSInteger pagenum;
/* 资讯列表 */
@property(nonatomic,strong) NSMutableArray *notices;
@end

@implementation RCNoticeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HXGlobalBg;
    [self.navigationItem setTitle:self.navTitle];
    [self setUpTableView];
    [self setUpRefresh];
    [self getNoticeListDataRequest:YES];
}
-(NSMutableArray *)notices
{
    if (_notices == nil) {
        _notices = [NSMutableArray array];
    }
    return _notices;
}
#pragma mark -- 视图相关
-(void)setUpEmptyView
{
    LYEmptyView *emptyView = [LYEmptyView emptyViewWithImageStr:@"no_report" titleStr:nil detailStr:@"暂无内容"];
    emptyView.contentViewOffset = -(self.HXNavBarHeight);
    emptyView.subViewMargin = 30.f;
    emptyView.detailLabTextColor = UIColorFromRGB(0x131D2D);
    emptyView.detailLabFont = [UIFont fontWithName:@"PingFangSC-Semibold" size: 16];
    self.tableView.ly_emptyView = emptyView;
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCNoticeCell class]) bundle:nil] forCellReuseIdentifier:NoticeCell];
}
/** 添加刷新控件 */
-(void)setUpRefresh
{
    hx_weakify(self);
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf.tableView.mj_footer resetNoMoreData];
        [strongSelf getNoticeListDataRequest:YES];
    }];
    //追加尾部刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf getNoticeListDataRequest:NO];
    }];
}
#pragma mark -- 接口请求
/** 公告列表请求 */
-(void)getNoticeListDataRequest:(BOOL)isRefresh
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    if (self.isInnerMsg) {
        data[@"accUuid"] = [MSUserManager sharedInstance].curUserInfo.userinfo.uuid;
    }else{
        data[@"cityId"] = [[NSUserDefaults standardUserDefaults] objectForKey:HXCityCode];
        data[@"num"] = @"10";
    }
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
    [HXNetworkTool POST:HXRC_M_URL action:self.isInnerMsg?@"sys/sys/notice/queryBaseNoticeByPage":@"pro/pro/notice/noticeList" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if ([responseObject[@"code"] integerValue] == 0) {
            if (isRefresh) {
                [strongSelf.tableView.mj_header endRefreshing];
                strongSelf.pagenum = 1;
                [strongSelf.notices removeAllObjects];
                if (strongSelf.isInnerMsg) {
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCInnerMsg class] json:responseObject[@"data"][@"records"]];
                    [strongSelf.notices addObjectsFromArray:arrt];
                }else{
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCHouseNotice class] json:responseObject[@"data"]];
                    [strongSelf.notices addObjectsFromArray:arrt];
                }
            }else{
                [strongSelf.tableView.mj_footer endRefreshing];
                strongSelf.pagenum ++;
                if (strongSelf.isInnerMsg) {
                    if ([responseObject[@"data"][@"records"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"data"][@"records"]).count){
                        NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCInnerMsg class] json:responseObject[@"data"][@"records"]];
                        [strongSelf.notices addObjectsFromArray:arrt];
                    }else{// 提示没有更多数据
                        [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                    }
                }else{
                    if ([responseObject[@"data"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"data"]).count){
                        NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCHouseNotice class] json:responseObject[@"data"]];
                        [strongSelf.notices addObjectsFromArray:arrt];
                    }else{// 提示没有更多数据
                        [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.tableView reloadData];
            });
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
    return self.notices.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:NoticeCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.isInnerMsg) {
        RCInnerMsg *innerMsg = self.notices[indexPath.row];
        cell.innerMsg = innerMsg;
    }else{
        RCHouseNotice *notice = self.notices[indexPath.row];
        cell.notice = notice;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isInnerMsg) {
        
    }else{
        RCNoticeDetialVC *wvc = [RCNoticeDetialVC new];
        RCHouseNotice *notice = self.notices[indexPath.row];
        wvc.uuid = notice.uuid;
        [self.navigationController pushViewController:wvc animated:YES];
    }
}

@end
