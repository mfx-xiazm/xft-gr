//
//  RCLoanListVC.m
//  XFT
//
//  Created by 夏增明 on 2019/11/27.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCLoanListVC.h"
#import "RCLoanListCell.h"
#import "RCLoanDetailVC.h"
#import "RCHouseLoan.h"

static NSString *const LoanListCell = @"LoanListCell";
@interface RCLoanListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 页码 */
@property (nonatomic,assign) NSInteger pagenum;
/* 列表 */
@property(nonatomic,strong) NSMutableArray *loans;

@end

@implementation RCLoanListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"算价清单"];
    [self setUpTableView];
    [self setUpEmptyView];
    [self setUpRefresh];
    [self startShimmer];
    [self getLoanDataRequest:YES];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}
-(NSMutableArray *)loans
{
    if (_loans == nil) {
        _loans = [NSMutableArray array];
    }
    return _loans;
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCLoanListCell class]) bundle:nil] forCellReuseIdentifier:LoanListCell];
}
/** 添加刷新控件 */
-(void)setUpRefresh
{
    hx_weakify(self);
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf.tableView.mj_footer resetNoMoreData];
        [strongSelf getLoanDataRequest:YES];
    }];
    //追加尾部刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf getLoanDataRequest:NO];
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
#pragma mark -- 接口请求
/** 资讯列表请求 */
-(void)getLoanDataRequest:(BOOL)isRefresh
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
    [HXNetworkTool POST:HXRC_M_URL action:@"sys/sys/calculate/findListByLogin" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if ([responseObject[@"code"] integerValue] == 0) {
            if (isRefresh) {
                [strongSelf.tableView.mj_header endRefreshing];
                strongSelf.pagenum = 1;
                [strongSelf.loans removeAllObjects];
                NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCHouseLoan class] json:responseObject[@"data"][@"records"]];
                [strongSelf.loans addObjectsFromArray:arrt];
            }else{
                [strongSelf.tableView.mj_footer endRefreshing];
                strongSelf.pagenum ++;
                if ([responseObject[@"data"][@"records"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"data"][@"records"]).count){
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCHouseLoan class] json:responseObject[@"data"][@"records"]];
                    [strongSelf.loans addObjectsFromArray:arrt];
                }else{// 提示没有更多数据
                    [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.tableView reloadData];
                if (strongSelf.loans.count || strongSelf.loans.count) {
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
-(void)delLoanRequest:(NSString *)loanUUid compledCall:(void(^)(void))compledCall
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"uuid"] = loanUUid;
    parameters[@"data"] = data;
    
    [HXNetworkTool POST:HXRC_M_URL action:@"sys/sys/calculate/delCalculate" parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
           [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
            compledCall();
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
    return self.loans.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCLoanListCell *cell = [tableView dequeueReusableCellWithIdentifier:LoanListCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    RCHouseLoan *loan = self.loans[indexPath.row];
    cell.loan = loan;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    RCHouseLoan *loan = self.loans[indexPath.row];
    if (loan.hxUuid && loan.hxUuid.length) {
        return 125.f;
    }else{
        return 75.f;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCLoanDetailVC *dvc = [RCLoanDetailVC new];
    RCHouseLoan *loan = self.loans[indexPath.row];
    if ([loan.loanType isEqualToString:@"1"]) {
        dvc.loanType = 1;
        dvc.b_total = loan.totalPrice;
        dvc.b_scale = loan.businProportion;
        dvc.b_year = [NSString stringWithFormat:@"%@年",loan.businRepayYears];
        dvc.b_yearNum = [loan.businRepayYears integerValue];//还款年限
        dvc.b_rate = loan.businInterestRate;
        dvc.b_type = [loan.repayWay isEqualToString:@"1"]?@"等额本息":@"等额本金";
        dvc.b_typeNum = [loan.repayWay integerValue];//还款方式
    }else if ([loan.loanType isEqualToString:@"2"]) {
        dvc.loanType = 2;
        dvc.f_total = loan.totalPrice;
        dvc.f_scale = loan.fundProportion;
        dvc.f_year = [NSString stringWithFormat:@"%@年",loan.fundRepayYears];
        dvc.f_yearNum = [loan.fundRepayYears integerValue];//还款年限
        dvc.f_rate = loan.fundInterestRate;
        dvc.f_type = [loan.repayWay isEqualToString:@"1"]?@"等额本息":@"等额本金";
        dvc.f_typeNum = [loan.repayWay integerValue];//还款方式
    }else{
        dvc.loanType = 3;
        dvc.mb_total = loan.businLoanAmount;
        dvc.mb_year = [NSString stringWithFormat:@"%@年",loan.businRepayYears];
        dvc.mb_yearNum = [loan.businRepayYears integerValue];//还款年限
        dvc.mb_rate = loan.businInterestRate;
        dvc.mf_total = loan.fundLoanAmount;
        dvc.mf_year = [NSString stringWithFormat:@"%@年",loan.fundRepayYears];
        dvc.mf_yearNum = [loan.fundRepayYears integerValue];//还款年限
        dvc.mf_rate = loan.fundInterestRate;
        dvc.m_type = [loan.repayWay isEqualToString:@"1"]?@"等额本息":@"等额本金";
        dvc.m_typeNum = [loan.repayWay integerValue];//还款方式
    }
    if (loan.hxUuid && loan.hxUuid.length) {
        dvc.proName = loan.proName;
        dvc.hxName = loan.hxName;
        dvc.buldArea = loan.buldArea;
        dvc.roomArea = loan.roomArea;
        dvc.hxUuid = loan.hxUuid;
    }
    [self.navigationController pushViewController:dvc animated:YES];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// 定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
// 进入编辑模式，按下出现的编辑按钮后,进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        RCHouseLoan *loan = self.loans[indexPath.row];
        hx_weakify(self);
        [self delLoanRequest:loan.uuid compledCall:^{
            hx_strongify(weakSelf);
            [strongSelf.loans removeObject:loan];
            [tableView reloadData];
        }];
    }
}
 
// 修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}
@end
