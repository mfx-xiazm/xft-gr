//
//  RCMyBrokerVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/7.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCMyBrokerVC.h"
#import "RCMyBrokerCell.h"
#import "RCBrokerClientVC.h"
#import "RCMyBroker.h"
#import "zhAlertView.h"
#import <zhPopupController.h>

static NSString *const MyBrokerCell = @"MyBrokerCell";

@interface RCMyBrokerVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 页码 */
@property (nonatomic,assign) NSInteger pagenum;
/* 列表 */
@property(nonatomic,strong) NSMutableArray *brokers;
@end

@implementation RCMyBrokerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"我的经纪人"];
    [self setUpTableView];
    [self setUpEmptyView];
    [self setUpRefresh];
    [self startShimmer];
    [self getBrokerDataRequest:YES];
}
-(NSMutableArray *)brokers
{
    if (_brokers == nil) {
        _brokers = [NSMutableArray array];
    }
    return _brokers;
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
    self.tableView.estimatedRowHeight = 0;//预估高度
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCMyBrokerCell class]) bundle:nil] forCellReuseIdentifier:MyBrokerCell];
}
/** 添加刷新控件 */
-(void)setUpRefresh
{
    hx_weakify(self);
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf.tableView.mj_footer resetNoMoreData];
        [strongSelf getBrokerDataRequest:YES];
    }];
    //追加尾部刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf getBrokerDataRequest:NO];
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
/** 资讯经纪人请求 */
-(void)getBrokerDataRequest:(BOOL)isRefresh
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
    [HXNetworkTool POST:HXRC_M_URL action:@"sys/sys/agent/selectByAccUuidXcx" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if ([responseObject[@"code"] integerValue] == 0) {
            if (isRefresh) {
                [strongSelf.tableView.mj_header endRefreshing];
                strongSelf.pagenum = 1;
                [strongSelf.brokers removeAllObjects];
                NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCMyBroker class] json:responseObject[@"data"]];
                [strongSelf.brokers addObjectsFromArray:arrt];
            }else{
                [strongSelf.tableView.mj_footer endRefreshing];
                strongSelf.pagenum ++;
                if ([responseObject[@"data"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"data"]).count){
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCMyBroker class] json:responseObject[@"data"]];
                    [strongSelf.brokers addObjectsFromArray:arrt];
                }else{// 提示没有更多数据
                    [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.tableView reloadData];
                if (strongSelf.brokers.count || strongSelf.brokers.count) {
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
    return self.brokers.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCMyBrokerCell *cell = [tableView dequeueReusableCellWithIdentifier:MyBrokerCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    RCMyBroker *broker = self.brokers[indexPath.row];
    cell.broker = broker;
    hx_weakify(self);
    cell.brokerPhoneCall = ^{
        hx_strongify(weakSelf);
        zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"提示" message:broker.accPhone constantWidth:HX_SCREEN_WIDTH - 50*2];
        zhAlertButton *cancelButton = [zhAlertButton buttonWithTitle:@"取消" handler:^(zhAlertButton * _Nonnull button) {
            [strongSelf.zh_popupController dismiss];
        }];
        zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"拨打" handler:^(zhAlertButton * _Nonnull button) {
            [strongSelf.zh_popupController dismiss];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",broker.accPhone]]];
        }];
        cancelButton.lineColor = UIColorFromRGB(0xDDDDDD);
        [cancelButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        okButton.lineColor = UIColorFromRGB(0xDDDDDD);
        [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
        [alert adjoinWithLeftAction:cancelButton rightAction:okButton];
        strongSelf.zh_popupController = [[zhPopupController alloc] init];
        [strongSelf.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 135.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCBrokerClientVC *cvc = [RCBrokerClientVC new];
    RCMyBroker *broker = self.brokers[indexPath.row];
    cvc.uuid = broker.uuid;
    cvc.accName = broker.name;
    [self.navigationController pushViewController:cvc animated:YES];
}


@end
