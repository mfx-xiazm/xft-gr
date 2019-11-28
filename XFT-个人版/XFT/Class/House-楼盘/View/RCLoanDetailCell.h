//
//  RCLoanDetailCell.h
//  XFT
//
//  Created by 夏增明 on 2019/8/30.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RCCalculateResultMonthModel;
@interface RCLoanDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *singleLoanView;
@property (weak, nonatomic) IBOutlet UIView *mixLoanView;

/* 期数 */
@property(nonatomic,strong) RCCalculateResultMonthModel *month;

/* 期数 */
@property(nonatomic,strong) RCCalculateResultMonthModel *zmonth;
@end

NS_ASSUME_NONNULL_END
