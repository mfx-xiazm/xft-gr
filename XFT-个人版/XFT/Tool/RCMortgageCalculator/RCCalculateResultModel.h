//
//  RCCalculateResultModel.h
//  XFT
//
//  Created by 夏增明 on 2019/11/26.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

/* 贷款类型 */
typedef NS_ENUM(NSInteger, MortgageType) {
    MortgageType_ShangDai = 0, // 商贷
    MortgageType_GJJDai, // 公积金贷
    MortgageType_ZuHe // 组合贷
};

/* 计算方式 */
typedef NS_ENUM(NSInteger, CalculationMethod) {
    CalculationMethod_BenXi = 0, // 等额本息
    CalculationMethod_BenJin // 等额本金
};

NS_ASSUME_NONNULL_BEGIN

@class RCCalculateResultMonthModel;
@interface RCCalculateResultModel : NSObject
/// 贷款类型
@property (nonatomic, assign) MortgageType mortgageType;
/// 计算方式
@property (nonatomic, assign) CalculationMethod calculationMethod;

// 每月的还款结果集合
@property (nonatomic, copy) NSArray <RCCalculateResultMonthModel *>*monthResultArray;
// 贷款年限（1~30）
@property (nonatomic, assign) NSUInteger year;
// 商贷利率
@property (nonatomic, assign) CGFloat shangDaiRate;
@property (nonatomic, copy) NSString *shangDaiRateString;
// 商贷金额(单位：万元)
@property (nonatomic, assign) NSUInteger shangDaiMoney;
@property (nonatomic, copy) NSString *shangDaiMoneyString;
// 公积金贷利率
@property (nonatomic, assign) CGFloat gjjDaiRate;
@property (nonatomic, copy) NSString *gjjDaiRateString;
// 公积金贷金额(单位：万元)
@property (nonatomic, assign) NSInteger gjjDaiMoney;
@property (nonatomic, copy) NSString *gjjDaiMoneyString;
// 总利息
@property (nonatomic, assign) CGFloat totalLixi;
@property (nonatomic, copy) NSString *totalLixiString; // 利息
// 总还款金额，单位：元（总利息+贷款金额）
@property (nonatomic, assign) CGFloat totalMoney;
@property (nonatomic, copy) NSString *totalMoneyString;
@end


@interface RCCalculateResultMonthModel : NSObject

/* 用于显示 */
@property (nonatomic, copy) NSString *nperString; // 期数（第一期、第二期，按月分的）
@property (nonatomic, copy) NSString *needPayString; // 月供（每月需支付金额）
@property (nonatomic, copy) NSString *benjinString; // 本金
@property (nonatomic, copy) NSString *lixiString; // 利息
@property (nonatomic, copy) NSString *surplusPayString; // 剩余还款

/* 用于计算 */
@property (nonatomic, assign) NSUInteger nper; // 期数
@property (nonatomic, assign) CGFloat needPay; // 月供（每月需支付金额:本息）,组合贷时代表商贷月供和公积金月供之和
@property (nonatomic, assign) CGFloat benjin; // 本金
@property (nonatomic, assign) CGFloat lixi; // 利息
@property (nonatomic, assign) CGFloat surplusPay; // 剩余还款

/* 组合贷的时候商贷月供 */
@property (nonatomic, assign) CGFloat sdNeedPay; // 组合商贷月供（每月需支付金额:本息）
/* 组合贷的时候公积金月供 */
@property (nonatomic, assign) CGFloat gjjNeedPay; // 组合公积金月供（每月需支付金额:本息）

@end

NS_ASSUME_NONNULL_END
