//
//  RCAddPhoneCell.h
//  XFT
//
//  Created by 夏增明 on 2019/8/28.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class RCReportPhone;
typedef void(^cutBtnCall)(void);
@interface RCAddPhoneCell : UITableViewCell
/* 删除 */
@property(nonatomic,copy) cutBtnCall cutBtnCall;
/* 电话 */
@property(nonatomic,strong) RCReportPhone *phone;
@end

NS_ASSUME_NONNULL_END
