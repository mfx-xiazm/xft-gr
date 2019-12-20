//
//  RCMyClientVC.m
//  XFT
//
//  Created by 夏增明 on 2019/8/29.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCMyClientVC.h"
#import "RCMyClientCell.h"
#import "RCMyClientStateCell.h"
#import "RCClientNoteVC.h"
#import "RCClientCount.h"
#import "RCMyClient.h"
#import "zhAlertView.h"
#import <zhPopupController.h>
#import "RCGoHouseVC.h"
#import "RCPushVC.h"

static NSString *const MyClientCell = @"MyClientCell";
static NSString *const MyClientStateCell = @"MyClientStateCell";

@interface RCMyClientVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;
/* 页码 */
@property (nonatomic,assign) NSInteger pagenum;
/* 列表 */
@property(nonatomic,strong) NSMutableArray *clients;
/* 客户数量 */
@property(nonatomic,strong) RCClientCount *clientCount;
@end

@implementation RCMyClientVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"我的客户"];
    [self setUpTableView];
    [self setUpEmptyView];
    [self setUpRefresh];
    [self startShimmer];
    [self getClientDataRequest];
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
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.rightTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.rightTableView.estimatedRowHeight = 100;//预估高度
    self.rightTableView.rowHeight = UITableViewAutomaticDimension;
    self.rightTableView.estimatedSectionHeaderHeight = 0;
    self.rightTableView.estimatedSectionFooterHeight = 0;
    
    self.rightTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.rightTableView.dataSource = self;
    self.rightTableView.delegate = self;
    
    self.rightTableView.showsVerticalScrollIndicator = NO;
    
    self.rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.rightTableView.backgroundColor = HXGlobalBg;
    // 注册cell
    [self.rightTableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCMyClientCell class]) bundle:nil] forCellReuseIdentifier:MyClientCell];
    
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.leftTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.leftTableView.estimatedRowHeight = 100;//预估高度
    self.leftTableView.rowHeight = UITableViewAutomaticDimension;
    self.leftTableView.estimatedSectionHeaderHeight = 0;
    self.leftTableView.estimatedSectionFooterHeight = 0;
    
    self.leftTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.leftTableView.dataSource = self;
    self.leftTableView.delegate = self;
    
    self.leftTableView.showsVerticalScrollIndicator = NO;
    
    self.leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.leftTableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCMyClientStateCell class]) bundle:nil] forCellReuseIdentifier:MyClientStateCell];
}
-(void)setUpEmptyView
{
    LYEmptyView *emptyView = [LYEmptyView emptyViewWithImageStr:@"pic_none_search" titleStr:nil detailStr:@"暂无客户"];
    emptyView.contentViewOffset = -(self.HXNavBarHeight);
    emptyView.subViewMargin = 30.f;
    emptyView.detailLabTextColor = UIColorFromRGB(0x131D2D);
    emptyView.detailLabFont = [UIFont fontWithName:@"PingFangSC-Semibold" size: 16];
    emptyView.autoShowEmptyView = NO;
    self.rightTableView.ly_emptyView = emptyView;
}
/** 添加刷新控件 */
-(void)setUpRefresh
{
    hx_weakify(self);
    self.rightTableView.mj_header.automaticallyChangeAlpha = YES;
    self.rightTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf.rightTableView.mj_footer resetNoMoreData];
        [strongSelf getClientDataRequest];
    }];
    //追加尾部刷新
    self.rightTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf getClientListDataRequest:NO compledCall:^{
            [strongSelf.rightTableView reloadData];
        }];
    }];
}
#pragma mark -- 接口请求
-(void)getClientDataRequest
{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    // 执行循序1
    hx_weakify(self);
    dispatch_group_async(group, queue, ^{
        hx_strongify(weakSelf);
        [HXNetworkTool POST:HXRC_M_URL action:@"cus/cus/cusInfo/getAgentCount" parameters:@{} success:^(id responseObject) {
            if ([responseObject[@"code"] integerValue] == 0) {
                strongSelf.clientCount = [RCClientCount yy_modelWithDictionary:responseObject[@"data"]];
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
        [strongSelf getClientListDataRequest:YES compledCall:^{
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
            [strongSelf stopShimmer];
            [strongSelf.leftTableView reloadData];
            [strongSelf.rightTableView reloadData];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [strongSelf.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:strongSelf.leftSelectIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
            });
            if (strongSelf.clients.count) {
                [strongSelf.rightTableView ly_hideEmptyView];
            }else{
                [strongSelf.rightTableView ly_showEmptyView];
            }
        });
    });
}
-(void)getClientListDataRequest:(BOOL)isRefresh compledCall:(void(^)(void))compledCall
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    if (self.leftSelectIndex == 0) {
        data[@"cusType"] = @"9";//用户状态1到访 2认筹 3认购 4签约 5退房 6失效 7报备 8已发展 9重要客户
    }else if (self.leftSelectIndex == 1) {
        data[@"cusType"] = @"8";//用户状态1到访 2认筹 3认购 4签约 5退房 6失效 7报备 8已发展 9重要客户
    }else if (self.leftSelectIndex == 2) {
        data[@"cusType"] = @"7";//用户状态1到访 2认筹 3认购 4签约 5退房 6失效 7报备 8已发展 9重要客户
    }else if (self.leftSelectIndex == 3) {
        data[@"cusType"] = @"1";//用户状态1到访 2认筹 3认购 4签约 5退房 6失效 7报备 8已发展 9重要客户
    }else if (self.leftSelectIndex == 4) {
        data[@"cusType"] = @"2";//用户状态1到访 2认筹 3认购 4签约 5退房 6失效 7报备 8已发展 9重要客户
    }else if (self.leftSelectIndex == 5) {
        data[@"cusType"] = @"3";//用户状态1到访 2认筹 3认购 4签约 5退房 6失效 7报备 8已发展 9重要客户
    }else if (self.leftSelectIndex == 6) {
        data[@"cusType"] = @"4";//用户状态1到访 2认筹 3认购 4签约 5退房 6失效 7报备 8已发展 9重要客户
    }else if (self.leftSelectIndex == 7) {
        data[@"cusType"] = @"5";//用户状态1到访 2认筹 3认购 4签约 5退房 6失效 7报备 8已发展 9重要客户
    }else {
        data[@"cusType"] = @"6";//用户状态1到访 2认筹 3认购 4签约 5退房 6失效 7报备 8已发展 9重要客户
    }
    NSMutableDictionary *page = [NSMutableDictionary dictionary];
    if (isRefresh) {
        page[@"current"] = @(1);//第几页
        [self.rightTableView.mj_footer resetNoMoreData];
    }else{
        NSInteger pagenum = self.pagenum+1;
        page[@"current"] = @(pagenum);//第几页
    }
    page[@"size"] = @"10";
    parameters[@"data"] = data;
    parameters[@"page"] = page;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"cus/cus/cusInfo/getAgentTypeInfo" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if ([responseObject[@"code"] integerValue] == 0) {
           if (isRefresh) {
               [strongSelf.rightTableView.mj_header endRefreshing];
               strongSelf.pagenum = 1;
               [strongSelf.clients removeAllObjects];
               NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCMyClient class] json:responseObject[@"data"][@"records"]];
               [strongSelf.clients addObjectsFromArray:arrt];
                   
           }else{
               [strongSelf.rightTableView.mj_footer endRefreshing];
               strongSelf.pagenum ++;
               if ([responseObject[@"data"][@"records"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"data"][@"records"]).count){
                   NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCMyClient class] json:responseObject[@"data"][@"records"]];
                   [strongSelf.clients addObjectsFromArray:arrt];
               }else{// 提示没有更多数据
                   [strongSelf.rightTableView.mj_footer endRefreshingWithNoMoreData];
               }
           }
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
        if (compledCall) {
            compledCall();
        }
    } failure:^(NSError *error) {
        if (compledCall) {
            compledCall();
        }
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)setImportantClientRequest:(NSString *)focusUuid completedCall:(void(^)(void))completedCall
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"accType"] = @"1";//当前账号的类型 1：经纪人 2：顾问 3:专员
    data[@"focusUuid"] = focusUuid;// 被关注人uuid
    parameters[@"data"] = data;
    
    [HXNetworkTool POST:HXRC_M_URL action:@"sys/sys/records/focusRecords" parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
           if (completedCall) {
               completedCall();
           }
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
    if (tableView == self.leftTableView) {
        return self.clientCount ?9:0;
    }else{
        return self.clients.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.leftTableView) {
        RCMyClientStateCell *cell = [tableView dequeueReusableCellWithIdentifier:MyClientStateCell forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        switch (indexPath.row) {
            case 0:{
                cell.clientState.text = @"重要客户";
                cell.clientNum.text = self.clientCount.importReport;
            }
                break;
            case 1:{
                cell.clientState.text = @"已发展";
                cell.clientNum.text = self.clientCount.developReport;
            }
                break;
            case 2:{
                cell.clientState.text = @"已报备";
                cell.clientNum.text = self.clientCount.hasReport;
            }
                break;
            case 3:{
                cell.clientState.text = @"已到访";
                cell.clientNum.text = self.clientCount.hasVisited;
            }
                break;
            case 4:{
                cell.clientState.text = @"已认筹";
                cell.clientNum.text = self.clientCount.hasRecognition;
            }
                break;
            case 5:{
                cell.clientState.text = @"已认购";
                cell.clientNum.text = self.clientCount.hasBuy;
            }
                break;
            case 6:{
                cell.clientState.text = @"已签约";
                cell.clientNum.text = self.clientCount.hasSign;
            }
                break;
            case 7:{
                cell.clientState.text = @"已退房";
                cell.clientNum.text = self.clientCount.hasCheckOut;
            }
                break;
            case 8:{
                cell.clientState.text = @"已失效";
                cell.clientNum.text = self.clientCount.hasInvalid;
            }
                break;
                
            default:
                break;
        }
        return cell;
    }else{
        RCMyClientCell *cell = [tableView dequeueReusableCellWithIdentifier:MyClientCell forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.state.hidden = YES;
        RCMyClient *client = self.clients[indexPath.row];
        cell.client = client;
        hx_weakify(self);
        cell.clientHandleCall = ^(NSInteger index) {
            hx_strongify(weakSelf);
            if (index == 1) {
                RCGoHouseVC *hvc = [RCGoHouseVC new];
                hvc.cusUuid = client.uuid;
                [strongSelf.navigationController pushViewController:hvc animated:YES];
            }else if (index == 2) {
                RCPushVC *pvc = [RCPushVC new];
                pvc.proUuid = client.proUuid;
                pvc.reName = client.name;
                pvc.rePhone = client.phone;
                [strongSelf.navigationController pushViewController:pvc animated:YES];
            }else if (index == 3) {
                [strongSelf setImportantClientRequest:client.uuid completedCall:^{
                    if ([client.isLove isEqualToString:@"0"]) {
                        client.isLove = @"1";
                        weakSelf.clientCount.importReport = [NSString stringWithFormat:@"%ld",[weakSelf.clientCount.importReport integerValue]+1];
                    }else{
                        client.isLove = @"0";
                        weakSelf.clientCount.importReport = [NSString stringWithFormat:@"%ld",[weakSelf.clientCount.importReport integerValue]-1];
                    }
                    [weakSelf.leftTableView reloadData];
                    [weakSelf.rightTableView reloadData];
                }];
            }else{
                zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"提示" message:client.phone constantWidth:HX_SCREEN_WIDTH - 50*2];
                zhAlertButton *cancelButton = [zhAlertButton buttonWithTitle:@"取消" handler:^(zhAlertButton * _Nonnull button) {
                    [strongSelf.zh_popupController dismiss];
                }];
                zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"拨打" handler:^(zhAlertButton * _Nonnull button) {
                    [strongSelf.zh_popupController dismiss];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",client.phone]]];
                }];
                cancelButton.lineColor = UIColorFromRGB(0xDDDDDD);
                [cancelButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
                okButton.lineColor = UIColorFromRGB(0xDDDDDD);
                [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
                [alert adjoinWithLeftAction:cancelButton rightAction:okButton];
                strongSelf.zh_popupController = [[zhPopupController alloc] init];
                [strongSelf.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
            }
        };
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    if (tableView == self.leftTableView) {
        return 75.f;
    }else{
        RCMyClient *client = self.clients[indexPath.row];
        if ([client.cusState isEqualToString:@"9"]) {
            return 145.f;
        }else{
            return 180.f;
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.leftTableView) {
        self.leftSelectIndex = indexPath.row;
        hx_weakify(self);
        [self getClientListDataRequest:YES compledCall:^{
            hx_strongify(weakSelf);
            [strongSelf.rightTableView reloadData];
        }];
    }else{
        RCClientNoteVC *dvc = [RCClientNoteVC  new];
        RCMyClient *client = self.clients[indexPath.row];
        dvc.cusUuid = client.uuid;
        [self.navigationController pushViewController:dvc animated:YES];
    }
}


@end
