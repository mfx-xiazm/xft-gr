//
//  RCMyAppointCell.h
//  XFT
//
//  Created by 夏增明 on 2019/9/7.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RCMyAppoint;
@interface RCMyAppointCell : UITableViewCell
/* 预约 */
@property(nonatomic,strong) RCMyAppoint *appoint;
@end

NS_ASSUME_NONNULL_END
