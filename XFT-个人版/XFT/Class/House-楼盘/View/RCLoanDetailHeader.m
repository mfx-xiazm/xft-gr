//
//  RCLoanDetailHeader.m
//  XFT
//
//  Created by 夏增明 on 2019/8/30.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCLoanDetailHeader.h"
#import "RCCalculateResultModel.h"

@interface RCLoanDetailHeader ()
@property (weak, nonatomic) IBOutlet UILabel *firstName;
@property (weak, nonatomic) IBOutlet UILabel *firstMoney;
@property (weak, nonatomic) IBOutlet UILabel *loanTotal;
@property (weak, nonatomic) IBOutlet UILabel *lixiToatl;
@property (weak, nonatomic) IBOutlet UILabel *loanYear;

@property (weak, nonatomic) IBOutlet UILabel *huxingName;
@property (weak, nonatomic) IBOutlet UILabel *jianmian;
@property (weak, nonatomic) IBOutlet UILabel *taonei;
@property (weak, nonatomic) IBOutlet UILabel *total;
@property (weak, nonatomic) IBOutlet UILabel *loan;
@property (weak, nonatomic) IBOutlet UILabel *backYear;
@property (weak, nonatomic) IBOutlet UILabel *lixiTotal1;
@property (weak, nonatomic) IBOutlet UIView *totalView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *totalViewHeight;

@end
@implementation RCLoanDetailHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
}

-(void)setResultModel:(RCCalculateResultModel *)resultModel
{
    _resultModel = resultModel;
    
    if (_resultModel.calculationMethod == CalculationMethod_BenXi) {
        self.firstName.text = @"每月应还";
    }else{
        self.firstName.text = @"首月应还";
    }
    RCCalculateResultMonthModel *model = _resultModel.monthResultArray.firstObject;
    self.firstMoney.text = model.needPayString;
    
    if (_resultModel.mortgageType == MortgageType_ShangDai) {
        self.loanTotal.text = [NSString stringWithFormat:@"%ld万",_resultModel.shangDaiMoney];
        self.lixiToatl.text = [NSString stringWithFormat:@"%.1f万",(_resultModel.totalLixi)/10000];
        self.loanYear.text = [NSString stringWithFormat:@"%ld年",_resultModel.year];
    }else if (_resultModel.mortgageType == MortgageType_GJJDai) {
        self.loanTotal.text = [NSString stringWithFormat:@"%ld万",_resultModel.gjjDaiMoney];
        self.lixiToatl.text = [NSString stringWithFormat:@"%.1f万",(_resultModel.totalLixi)/10000];
        self.loanYear.text = [NSString stringWithFormat:@"%ld年",_resultModel.year];
    }else{
        self.loanTotal.text = [NSString stringWithFormat:@"%ld万",_resultModel.shangDaiMoney + _resultModel.gjjDaiMoney];
        self.lixiToatl.text = [NSString stringWithFormat:@"%.1f万",(_resultModel.totalLixi)/10000];
        self.loanYear.text = [NSString stringWithFormat:@"%ld年",_resultModel.year];
    }
}
-(void)setHouseResultModel:(RCCalculateResultModel *)houseResultModel
{
    _houseResultModel = houseResultModel;
    
    self.huxingName.text = [NSString stringWithFormat:@"%@%@",self.proName,self.hxName];
    self.jianmian.text = [NSString stringWithFormat:@"%@㎡",self.buldArea];
    self.taonei.text = [NSString stringWithFormat:@"%@㎡",self.roomArea];
    if (_houseResultModel.mortgageType == MortgageType_ShangDai) {
        self.total.text = [NSString stringWithFormat:@"%@万",self.houseTotal];
        self.loan.text = [NSString stringWithFormat:@"%@万",self.loanMoney];
        self.backYear.text = [NSString stringWithFormat:@"%ld年",_houseResultModel.year];
        self.lixiTotal1.text = [NSString stringWithFormat:@"%.f万",_houseResultModel.totalMoney/10000];
    }else if (_houseResultModel.mortgageType == MortgageType_GJJDai) {
        self.total.text = [NSString stringWithFormat:@"%@万",self.houseTotal];
        self.loan.text = [NSString stringWithFormat:@"%@万",self.loanMoney];
        self.backYear.text = [NSString stringWithFormat:@"%ld年",_houseResultModel.year];
        self.lixiTotal1.text = [NSString stringWithFormat:@"%.f万",_houseResultModel.totalMoney/10000];
    }else{
        self.totalView.hidden = YES;
        self.totalViewHeight.constant = 0.f;
        self.loan.text = [NSString stringWithFormat:@"%@万",self.loanMoney];
        self.backYear.text = [NSString stringWithFormat:@"%ld年",_houseResultModel.year];
        self.lixiTotal1.text = [NSString stringWithFormat:@"%.f万",_houseResultModel.totalMoney/10000];
    }
}
@end
