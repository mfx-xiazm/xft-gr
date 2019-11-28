//
//  RCAddedClientCell.h
//  XFT
//
//  Created by 夏增明 on 2019/9/7.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class RCReportTarget;
typedef void(^cutBtnCall)(void);
@interface RCAddedClientCell : UITableViewCell
/* 删除 */
@property(nonatomic,copy) cutBtnCall cutBtnCall;
/* 客户 */
@property(nonatomic,strong) RCReportTarget *client;
@end

NS_ASSUME_NONNULL_END
