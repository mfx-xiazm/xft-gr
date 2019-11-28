//
//  RCHouseLoan.h
//  XFT
//
//  Created by 夏增明 on 2019/11/27.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCHouseLoan : NSObject
@property (nonatomic, strong) NSString * uuid;
@property (nonatomic, strong) NSString * hxUuid;
@property (nonatomic, strong) NSString * accUuid;
@property (nonatomic, strong) NSString * totalPrice;
@property (nonatomic, strong) NSString * loanType;
@property (nonatomic, strong) NSString * businLoanAmount;
@property (nonatomic, strong) NSString * businProportion;
@property (nonatomic, strong) NSString * businRepayYears;
@property (nonatomic, strong) NSString * businInterestRate;
@property (nonatomic, strong) NSString * fundLoanAmount;
@property (nonatomic, strong) NSString * fundProportion;
@property (nonatomic, strong) NSString * fundRepayYears;
@property (nonatomic, strong) NSString * fundInterestRate;
@property (nonatomic, strong) NSString * repayWay;
@property (nonatomic, strong) NSString * createTime;
@property (nonatomic, strong) NSString * editTime;
@property (nonatomic, strong) NSString * state;
@property (nonatomic, strong) NSString * hxName;
@property (nonatomic, strong) NSString * proName;
@property (nonatomic, strong) NSString * buldArea;
@property (nonatomic, strong) NSString * hxType;
@property (nonatomic, strong) NSString * responseApartment;
@property (nonatomic, strong) NSString * roomArea;


@end

NS_ASSUME_NONNULL_END
