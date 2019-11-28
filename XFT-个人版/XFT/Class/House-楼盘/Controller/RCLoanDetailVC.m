//
//  RCLoanDetailVC.m
//  XFT
//
//  Created by 夏增明 on 2019/8/30.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCLoanDetailVC.h"
#import "RCLoanDetailHeader.h"
#import "RCLoanDetailTitleView.h"
#import "RCLoanDetailCell.h"
#import "RCMortgageCalculator.h"

static NSString *const LoanDetailCell = @"LoanDetailCell";
@interface RCLoanDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 头视图 */
@property(nonatomic,strong) RCLoanDetailHeader *header;
/* 计算结果 */
@property(nonatomic,strong) RCCalculateResultModel *resultModel;
@end

@implementation RCLoanDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"算价清单"];
    self.view.backgroundColor = UIColorFromRGB(0xE3F4FF);
    [self setUpTableView];
    [self jiSuanQingDan];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
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
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 15, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 设置背景色为clear
    self.tableView.backgroundColor = [UIColor clearColor];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCLoanDetailCell class]) bundle:nil] forCellReuseIdentifier:LoanDetailCell];
}
-(void)jiSuanQingDan
{
    // 总金额、贷款方式、年利率
    if (self.loanType == 1) {
        self.resultModel = [RCMortgageCalculator calculateMortgageInfoWithYearRate:[self.b_rate floatValue] yearCount:self.b_yearNum totalMoney:[self.b_total integerValue]*([self.b_scale floatValue]/10) mortgageType:MortgageType_ShangDai calculateMethod:(self.b_typeNum == 1)?CalculationMethod_BenXi:CalculationMethod_BenJin];
    }else if (self.loanType == 2) {
        self.resultModel = [RCMortgageCalculator calculateMortgageInfoWithYearRate:[self.f_rate floatValue] yearCount:self.f_yearNum totalMoney:[self.f_total integerValue]*([self.f_scale floatValue]/10) mortgageType:MortgageType_GJJDai calculateMethod:(self.f_typeNum == 1)?CalculationMethod_BenXi:CalculationMethod_BenJin];
    }else{
        RCCalculateResultModel *sdResult = [RCMortgageCalculator calculateMortgageInfoWithYearRate:[self.mb_rate floatValue] yearCount:self.mb_yearNum totalMoney:[self.mb_total integerValue] mortgageType:MortgageType_ShangDai calculateMethod:(self.m_typeNum == 1)?CalculationMethod_BenXi:CalculationMethod_BenJin];
        RCCalculateResultModel *gjResult = [RCMortgageCalculator calculateMortgageInfoWithYearRate:[self.mf_rate floatValue] yearCount:self.mf_yearNum totalMoney:[self.mf_total integerValue] mortgageType:MortgageType_GJJDai calculateMethod:(self.m_typeNum == 1)?CalculationMethod_BenXi:CalculationMethod_BenJin];
        self.resultModel = [[RCCalculateResultModel alloc] init];
        /// 贷款类型
        self.resultModel.mortgageType = MortgageType_ZuHe;
        /// 计算方式
        self.resultModel.calculationMethod = (self.m_typeNum == 1)?CalculationMethod_BenXi:CalculationMethod_BenJin;
        
        // 贷款年限（1~30）
        self.resultModel.year = self.mb_yearNum > self.mf_yearNum? self.mb_yearNum: self.mf_yearNum;
        // 商贷利率
        self.resultModel.shangDaiRate = [self.mb_rate floatValue];
        self.resultModel.shangDaiRateString = [NSString stringWithFormat:@"%0.2f%@", [self.mb_rate floatValue], @"%"];
        // 商贷金额(单位：万元)
        self.resultModel.shangDaiMoney = [self.mb_total integerValue];
        self.resultModel.shangDaiMoneyString = [NSString stringWithFormat:@"%lu", (unsigned long)[self.mb_total integerValue]];
        // 公积金贷利率
        self.resultModel.gjjDaiRate = [self.mf_rate floatValue];
        self.resultModel.gjjDaiRateString = [NSString stringWithFormat:@"%0.2f%@", [self.mf_rate floatValue], @"%"];
        // 公积金贷金额(单位：万元)
        self.resultModel.gjjDaiMoney = [self.mf_total integerValue];
        self.resultModel.gjjDaiMoneyString = [NSString stringWithFormat:@"%lu", (unsigned long)[self.mf_total integerValue]];

        // 总利息
        self.resultModel.totalLixi = sdResult.totalLixi + gjResult.totalLixi;
        self.resultModel.totalLixiString = [NSString stringWithFormat:@"%0.2f", sdResult.totalLixi + gjResult.totalLixi];

        // 总还款金额，单位：元（总利息+贷款金额）
        self.resultModel.totalMoney = sdResult.totalMoney + gjResult.totalMoney;
        self.resultModel.totalMoneyString = [NSString stringWithFormat:@"%0.2f", sdResult.totalMoney + gjResult.totalMoney];
        
        // 每月的还款结果集合
        NSInteger backNum = self.mb_yearNum > self.mf_yearNum? self.mb_yearNum*12: self.mf_yearNum*12;
        NSMutableArray *resultMonth = [NSMutableArray array];
        for (int i=0; i<backNum; i++) {
            RCCalculateResultMonthModel *rMonth = [[RCCalculateResultMonthModel alloc] init];
            rMonth.nper = i+1;
            rMonth.nperString = [NSString stringWithFormat:@"第%d期", i+1];
            if (i <= (self.mb_yearNum*12 - 1)) {//商贷
                RCCalculateResultMonthModel *sdMonth = sdResult.monthResultArray[i];

                rMonth.needPay += sdMonth.needPay;//月供（每月需支付金额:本息）
                rMonth.benjin += sdMonth.benjin;//本金
                rMonth.lixi += sdMonth.lixi;//利息
                rMonth.surplusPay += sdMonth.surplusPay;//剩余还款
                rMonth.sdNeedPay = sdMonth.needPay;//月供（每月需支付金额:本息）
            }else{
                rMonth.needPay += 0;//月供（每月需支付金额:本息）
                rMonth.benjin += 0;//本金
                rMonth.lixi += 0;//利息
                rMonth.surplusPay += 0;//剩余还款
                rMonth.sdNeedPay = 0;//月供（每月需支付金额:本息）
            }
            if (i <= (self.mf_yearNum*12 - 1)) {//基金贷
                RCCalculateResultMonthModel *gjMonth = gjResult.monthResultArray[i];
               
                rMonth.needPay += gjMonth.needPay;//月供（每月需支付金额:本息）
                rMonth.benjin += gjMonth.benjin;//本金
                rMonth.lixi += gjMonth.lixi;//利息
                rMonth.surplusPay += gjMonth.surplusPay;//剩余还款
                rMonth.gjjNeedPay = gjMonth.needPay;//月供（每月需支付金额:本息）
            }else{
                rMonth.needPay += 0;//月供（每月需支付金额:本息）
                rMonth.benjin += 0;//本金
                rMonth.lixi += 0;//利息
                rMonth.surplusPay += 0;//剩余还款
                rMonth.gjjNeedPay = 0;//月供（每月需支付金额:本息）
            }
            rMonth.needPayString = [NSString stringWithFormat:@"%0.2f", rMonth.needPay];

            [resultMonth addObject:rMonth];
        }
        self.resultModel.monthResultArray = [NSArray arrayWithArray:resultMonth];
        
    }
    [self.tableView reloadData];
}
- (IBAction)saveLoanRequest:(UIButton *)sender {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    if (self.loanType == 1) {
        data[@"businInterestRate"] = self.b_rate;//商业贷款利率
        data[@"businLoanAmount"] = [NSString stringWithFormat:@"%.f",[self.b_total integerValue] * [self.b_scale floatValue]/10];//商业贷款金额
        data[@"businProportion"] = self.b_scale;//商业贷款比例
        data[@"businRepayYears"] = @(self.b_yearNum);//商业贷款年限
        data[@"fundInterestRate"] = @"";//公积金贷款利率
        data[@"fundLoanAmount"] = @"";//公积金贷款金额
        data[@"fundProportion"] = @"";//公积金贷款比例
        data[@"fundRepayYears"] = @"";//公积金还款年限
        data[@"hxUuid"] = (self.hxUuid && self.hxUuid.length)?self.hxUuid:@"";//户型uuid
        data[@"loanType"] = @"1";//贷款类型(1:商业,2:基金,3:混合)
        data[@"repayWay"] = @(self.b_typeNum);//还款方式(1:等额本息,2:等额本金)
        data[@"totalPrice"] = self.b_total;//房源总价

    }else if (self.loanType == 2){
        data[@"businInterestRate"] = @"";//商业贷款利率
        data[@"businLoanAmount"] = @"";//商业贷款金额
        data[@"businProportion"] = @"";//商业贷款比例
        data[@"businRepayYears"] = @"";//商业贷款年限
        data[@"fundInterestRate"] = self.f_rate;//公积金贷款利率
        data[@"fundLoanAmount"] = [NSString stringWithFormat:@"%.f",[self.f_total integerValue] * [self.f_scale floatValue]/10];//公积金贷款金额
        data[@"fundProportion"] = self.f_scale;//公积金贷款比例
        data[@"fundRepayYears"] = @(self.f_yearNum);//公积金还款年限
        data[@"hxUuid"] = (self.hxUuid && self.hxUuid.length)?self.hxUuid:@"";//户型uuid
        data[@"loanType"] = @"2";//贷款类型(1:商业,2:基金,3:混合)
        data[@"repayWay"] = @(self.f_typeNum);//还款方式(1:等额本息,2:等额本金)
        data[@"totalPrice"] = self.f_total;//房源总价
    }else{
        data[@"businInterestRate"] = self.mb_rate;//商业贷款利率
        data[@"businLoanAmount"] = self.mb_total;//商业贷款金额
        data[@"businProportion"] = @"";//商业贷款比例
        data[@"businRepayYears"] = @(self.mb_yearNum);//商业贷款年限
        data[@"fundInterestRate"] = self.mf_rate;//公积金贷款利率
        data[@"fundLoanAmount"] = self.mf_total;//公积金贷款金额
        data[@"fundProportion"] = @"";//公积金贷款比例
        data[@"fundRepayYears"] = @(self.mf_yearNum);//公积金还款年限
        data[@"hxUuid"] = (self.hxUuid && self.hxUuid.length)?self.hxUuid:@"";//户型uuid
        data[@"loanType"] = @"3";//贷款类型(1:商业,2:基金,3:混合)
        data[@"repayWay"] = @(self.m_typeNum);//还款方式(1:等额本息,2:等额本金)
        data[@"totalPrice"] = @([self.mb_total integerValue] + [self.mf_total integerValue]);//房源总价
    }
    parameters[@"data"] = data;

    [HXNetworkTool POST:HXRC_M_URL action:@"sys/sys/calculate/addBaseCalculate" parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
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
    return self.resultModel.monthResultArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCLoanDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:LoanDetailCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.loanType == 3) {//组合贷
        cell.singleLoanView.hidden = YES;
        cell.mixLoanView.hidden = NO;
        RCCalculateResultMonthModel *zmonth = self.resultModel.monthResultArray[indexPath.row];
        cell.zmonth = zmonth;
    }else{
        cell.singleLoanView.hidden = NO;
        cell.mixLoanView.hidden = YES;
        RCCalculateResultMonthModel *month = self.resultModel.monthResultArray[indexPath.row];
        cell.month = month;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 30.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.hxUuid && self.hxUuid.length) {
        return 30.f + 300.f;
    }else{
        return 30.f + 200.f;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [UIView new];
    RCLoanDetailHeader *top = [RCLoanDetailHeader loadXibView];
    RCLoanDetailTitleView *tv = [RCLoanDetailTitleView loadXibView];
    
    if (self.loanType == 3) {//组合贷
        tv.singleView.hidden = YES;
        tv.mixView.hidden = NO;
    }else{
        tv.singleView.hidden = NO;
        tv.mixView.hidden = YES;
    }

    if (self.hxUuid && self.hxUuid.length) {
        header.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 30.f+300.f);
        top.houseView.hidden = NO;
        top.normalView.hidden = YES;
        top.proName = self.proName;
        top.hxName = self.hxName;
        top.buldArea = self.buldArea;
        top.roomArea = self.roomArea;
        if (self.loanType == 1) {
            top.loanMoney = [NSString stringWithFormat:@"%.f",[self.b_total integerValue] * [self.b_scale floatValue]/10];//贷款金额
            top.houseTotal = [NSString stringWithFormat:@"%ld",[self.b_total integerValue]];
        }else if (self.loanType == 2) {
            top.loanMoney = [NSString stringWithFormat:@"%.f",[self.f_total integerValue] * [self.f_scale floatValue]/10];//贷款金额
            top.houseTotal = [NSString stringWithFormat:@"%ld",[self.f_total integerValue]];
        }else{
            top.loanMoney = [NSString stringWithFormat:@"%ld",[self.mb_total integerValue] + [self.mf_total integerValue]];//贷款金额
        }
        top.frame = CGRectMake(0,0,HX_SCREEN_WIDTH, 300.f);
        tv.frame = CGRectMake(0,300.f,HX_SCREEN_WIDTH, 30.f);
        top.houseResultModel = self.resultModel;
    }else{
        header.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 30.f+200.f);
        top.houseView.hidden = YES;
        top.normalView.hidden = NO;
        top.frame = CGRectMake(0,0,HX_SCREEN_WIDTH, 200.f);
        tv.frame = CGRectMake(0,200.f,HX_SCREEN_WIDTH, 30.f);
        top.resultModel = self.resultModel;
    }
    [header addSubview:top];
    [header addSubview:tv];

    return header;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}


@end
