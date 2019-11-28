//
//  RCLoanDetailHeader.h
//  XFT
//
//  Created by 夏增明 on 2019/8/30.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RCCalculateResultModel;
@interface RCLoanDetailHeader : UIView
@property (weak, nonatomic) IBOutlet UIView *normalView;
@property (weak, nonatomic) IBOutlet UIView *houseView;
/* 计算结果 */
@property(nonatomic,strong) RCCalculateResultModel *resultModel;
@property(nonatomic,strong) RCCalculateResultModel *houseResultModel;

/* 楼盘信息 */
@property(nonatomic,copy) NSString *proName;
@property(nonatomic,copy) NSString *hxName;
@property(nonatomic,copy) NSString *buldArea;
@property(nonatomic,copy) NSString *roomArea;
/* 贷款金额 */
@property(nonatomic,copy) NSString *loanMoney;
/* 房屋总价 */
@property(nonatomic,copy) NSString *houseTotal;
@end

NS_ASSUME_NONNULL_END
