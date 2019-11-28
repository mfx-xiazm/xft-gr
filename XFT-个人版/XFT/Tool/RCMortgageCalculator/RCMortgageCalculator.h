//
//  RCMortgageCalculator.h
//  XFT
//
//  Created by 夏增明 on 2019/11/26.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCCalculateResultModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCMortgageCalculator : NSObject
/// 非组合贷 计算方法
/// @param rate 年利率
/// @param yearCount 贷款总年限
/// @param totalMoney 总金额 （单位：万元）
/// @param mortgageType 贷款类型 （商贷/公积金贷）
/// @param calculateMethod 计算方法（等额本金/等额本息）
+ (RCCalculateResultModel *)calculateMortgageInfoWithYearRate:(CGFloat)rate
                                                  yearCount:(NSUInteger)yearCount
                                                 totalMoney:(NSUInteger)totalMoney
                                               mortgageType:(MortgageType)mortgageType
                                            calculateMethod:(CalculationMethod)calculateMethod;



/// 组合贷款
/// @param gjjYearRate 公积金贷款年利率
/// @param shangYearRate 商贷款年利率
/// @param gjjMoney 公积金贷款金额 （单位：万元）
/// @param shangMoney 商贷款金额 （单位：万元）
/// @param yearCount 贷款总年数
/// @param mortgageType 贷款类型 （商贷/公积金贷）
/// @param calculateMethod 计算方法（等额本金/等额本息）
+ (RCCalculateResultModel *)zuheDaiCalculateWithGJJYearRate:(CGFloat)gjjYearRate
                                            shangYearRate:(CGFloat)shangYearRate
                                                 gjjMoney:(NSUInteger)gjjMoney
                                               shangMoney:(NSUInteger)shangMoney
                                                yearCount:(NSInteger)yearCount
                                             mortgageType:(MortgageType)mortgageType
                                          calculateMethod:(CalculationMethod)calculateMethod;
@end

NS_ASSUME_NONNULL_END
