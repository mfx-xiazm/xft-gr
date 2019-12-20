//
//  RCBrokerClientVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/7.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCBrokerClientVC.h"
#import "RCBrokerClientCell.h"
#import "RCMyClientStateCell.h"
#import "RCMyClient.h"

static NSString *const BrokerClientCell = @"BrokerClientCell";
static NSString *const MyClientStateCell = @"MyClientStateCell";

@interface RCBrokerClientVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
/* 页码 */
@property (nonatomic,assign) NSInteger pagenum;
/* 列表 */
@property(nonatomic,strong) NSMutableArray *clients;
/* 左侧的客户数量 */
@property(nonatomic,strong) NSMutableDictionary *clietNumInfo;
/* 左边分组选中的索引 */
@property(nonatomic,assign) NSInteger selectIndex;
@end

@implementation RCBrokerClientVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:[NSString stringWithFormat:@"%@的客户",self.accName]];
    self.selectIndex = 0;

    [self setUpTableView];
    [self setUpRefresh];
    [self setUpEmptyView];
    [self getClientDataRequest:YES];
}
-(NSMutableArray *)clients
{
    if (_clients == nil) {
        _clients = [NSMutableArray array];
    }
    return _clients;
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
    self.tableView.backgroundColor = HXGlobalBg;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCBrokerClientCell class]) bundle:nil] forCellReuseIdentifier:BrokerClientCell];
    
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.leftTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.leftTableView.estimatedRowHeight = 0;//预估高度
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
/** 添加刷新控件 */
-(void)setUpRefresh
{
    hx_weakify(self);
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf.tableView.mj_footer resetNoMoreData];
        [strongSelf getClientDataRequest:YES];
    }];
    //追加尾部刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf getClientDataRequest:NO];
    }];
}
-(void)setUpEmptyView
{
    LYEmptyView *emptyView = [LYEmptyView emptyViewWithImageStr:@"pic_none_search" titleStr:nil detailStr:@"暂无客户"];
    emptyView.contentViewOffset = -(self.HXNavBarHeight);
    emptyView.subViewMargin = 30.f;
    emptyView.detailLabTextColor = UIColorFromRGB(0x131D2D);
    emptyView.detailLabFont = [UIFont fontWithName:@"PingFangSC-Semibold" size: 16];
    emptyView.autoShowEmptyView = NO;
    self.tableView.ly_emptyView = emptyView;
}
/** 客户列表请求 */
-(void)getClientDataRequest:(BOOL)isRefresh
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"accuuid"] = self.uuid;
    switch (self.selectIndex) {
        case 0:{
            data[@"type"] = @"";//客户类型(空串:全部,0:报备成功,2:到访,4:认筹,5:认购,6:签约,7:退房,100:失效)
        }
            break;
        case 1:{
            data[@"type"] = @"0";//客户类型(空串:全部,0:报备成功,2:到访,4:认筹,5:认购,6:签约,7:退房,100:失效)
        }
            break;
        case 2:{
            data[@"type"] = @"2";//客户类型(空串:全部,0:报备成功,2:到访,4:认筹,5:认购,6:签约,7:退房,100:失效)
        }
            break;
        case 3:{
            data[@"type"] = @"4";//客户类型(空串:全部,0:报备成功,2:到访,4:认筹,5:认购,6:签约,7:退房,100:失效)
        }
            break;
        case 4:{
            data[@"type"] = @"5";//客户类型(空串:全部,0:报备成功,2:到访,4:认筹,5:认购,6:签约,7:退房,100:失效)
        }
            break;
        case 5:{
            data[@"type"] = @"6";//客户类型(空串:全部,0:报备成功,2:到访,4:认筹,5:认购,6:签约,7:退房,100:失效)
        }
            break;
        case 6:{
            data[@"type"] = @"7";//客户类型(空串:全部,0:报备成功,2:到访,4:认筹,5:认购,6:签约,7:退房,100:失效)
        }
            break;
        case 7:{
            data[@"type"] = @"100";//客户类型(空串:全部,0:报备成功,2:到访,4:认筹,5:认购,6:签约,7:退房,100:失效)
        }
            break;
            
        default:
            break;
    }
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
    [HXNetworkTool POST:HXRC_M_URL action:@"anchang/anchang/baobei/XcxBaobeiListByUuid" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if ([responseObject[@"code"] integerValue] == 0) {
            if (isRefresh) {
                [strongSelf.tableView.mj_header endRefreshing];
                strongSelf.pagenum = 1;
                [strongSelf.clients removeAllObjects];
                NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCMyClient class] json:responseObject[@"data"][@"page"][@"records"]];
                [strongSelf.clients addObjectsFromArray:arrt];
                
                strongSelf.clietNumInfo = [NSMutableDictionary dictionary];
                strongSelf.clietNumInfo[@"totalNum"] = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"allcus"]];
                strongSelf.clietNumInfo[@"cusBaoBeiReportNum"] = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"reported"]];
                strongSelf.clietNumInfo[@"cusBaoBeiVisitNum"] = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"haveVisited"]];
                strongSelf.clietNumInfo[@"cusBaoBeiRecognitionNum"] = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"recruit"]];
                strongSelf.clietNumInfo[@"cusBaoBeiSubscribeNum"] = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"subscribed"]];
                strongSelf.clietNumInfo[@"cusBaoBeiSignNum"] = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"signed"]];
                strongSelf.clietNumInfo[@"cusBaoBeiAbolishNum"] = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"checkOut"]];
                strongSelf.clietNumInfo[@"cusBaoBeiInvalidNum"] = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"expired"]];
                    
            }else{
                [strongSelf.tableView.mj_footer endRefreshing];
                strongSelf.pagenum ++;
                if ([responseObject[@"data"][@"page"][@"records"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"data"][@"page"][@"records"]).count){
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCMyClient class] json:responseObject[@"data"][@"page"][@"records"]];
                    [strongSelf.clients addObjectsFromArray:arrt];
                }else{// 提示没有更多数据
                    [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.leftTableView reloadData];
                [strongSelf.tableView reloadData];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [strongSelf.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:strongSelf.selectIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
                });
                if (strongSelf.clients.count || strongSelf.clients.count) {
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
    if (tableView == self.leftTableView) {
        return self.clietNumInfo?8:0;
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
                cell.clientState.text = @"全部客户";
                cell.clientNum.text = [NSString stringWithFormat:@"%@",self.clietNumInfo[@"totalNum"]];
            }
                break;
            case 1:{
                cell.clientState.text = @"已报备";
                cell.clientNum.text = [NSString stringWithFormat:@"%@",self.clietNumInfo[@"cusBaoBeiReportNum"]];
            }
                break;
            case 2:{
                cell.clientState.text = @"已到访";
                cell.clientNum.text = [NSString stringWithFormat:@"%@",self.clietNumInfo[@"cusBaoBeiVisitNum"]];
            }
                break;
            case 3:{
                cell.clientState.text = @"已认筹";
                cell.clientNum.text = [NSString stringWithFormat:@"%@",self.clietNumInfo[@"cusBaoBeiRecognitionNum"]];
            }
                break;
            case 4:{
                cell.clientState.text = @"已认购";
                cell.clientNum.text = [NSString stringWithFormat:@"%@",self.clietNumInfo[@"cusBaoBeiSubscribeNum"]];
            }
                break;
            case 5:{
                cell.clientState.text = @"已签约";
                cell.clientNum.text = [NSString stringWithFormat:@"%@",self.clietNumInfo[@"cusBaoBeiSignNum"]];
            }
                break;
            case 6:{
                cell.clientState.text = @"已退房";
                cell.clientNum.text = [NSString stringWithFormat:@"%@",self.clietNumInfo[@"cusBaoBeiAbolishNum"]];
            }
                break;
            case 7:{
                cell.clientState.text = @"已失效";
                cell.clientNum.text = [NSString stringWithFormat:@"%@",self.clietNumInfo[@"cusBaoBeiInvalidNum"]];
            }
                break;
                
            default:
                break;
        }
        return cell;
    }else{
        RCBrokerClientCell *cell = [tableView dequeueReusableCellWithIdentifier:BrokerClientCell forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.state.hidden = YES;
        RCMyClient *client = self.clients[indexPath.row];
        cell.client = client;
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
        // 0:报备,2:到访,4:认筹,5:认购,6:签约,7:退房,100:失效
        if ([client.cusState isEqualToString:@"0"]) {
            return 110.f;
        }else{
            return 125.f;
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.leftTableView) {
        self.selectIndex = indexPath.row;
        [self getClientDataRequest:YES];
    }
}


@end
