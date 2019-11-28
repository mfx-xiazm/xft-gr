//
//  RCLoanListCell.h
//  XFT
//
//  Created by 夏增明 on 2019/11/27.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RCHouseLoan;
@interface RCLoanListCell : UITableViewCell
/* 贷款 */
@property(nonatomic,strong) RCHouseLoan *loan;
@end

NS_ASSUME_NONNULL_END
