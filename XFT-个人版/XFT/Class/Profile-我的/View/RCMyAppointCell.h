//
//  RCMyAppointCell.h
//  XFT
//
//  Created by 夏增明 on 2019/9/7.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^doneAppointCall)(void);
@interface RCMyAppointCell : UITableViewCell
/* 去完成 */
@property(nonatomic,copy) doneAppointCall doneAppointCall;
@end

NS_ASSUME_NONNULL_END
