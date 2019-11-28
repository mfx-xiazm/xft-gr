//
//  RCMineNum.h
//  XFT
//
//  Created by 夏增明 on 2019/11/25.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCMineNum : NSObject
@property (nonatomic, strong) NSString * fansNUM;//粉丝数(注册客户)
@property (nonatomic, strong) NSString * reportedNUM;//预约到访数(注册客户)
@property (nonatomic, strong) NSString * activeNUM;//报名活动数(注册客户)
@property (nonatomic, strong) NSString * seeNUM;//预约到访数
@property (nonatomic, strong) NSString * collNUM;//收藏数
@property (nonatomic, strong) NSString * finishStatus;//判断是否有未完成回访表 1.有 2没有
@property (nonatomic, strong) NSString * mortgageNUM;//房贷计算数
@property (nonatomic, strong) NSString * developedNUM;//我的客户–已发展数
@property (nonatomic, strong) NSString * haveVisitedNUM;//我的客户–已到访数
@property (nonatomic, strong) NSString * subscribedNUM;//我的客户–已认购数
@property (nonatomic, strong) NSString * develBrokerNUM;//经纪人–发展经纪人数
@property (nonatomic, strong) NSString * brokerDevelCusNUM;//经纪人–经纪人发展客户数
@property (nonatomic, strong) NSString * totalCommNUM;//总佣金
@property (nonatomic, strong) NSString * commPaid;//已发放佣金

@end

NS_ASSUME_NONNULL_END
