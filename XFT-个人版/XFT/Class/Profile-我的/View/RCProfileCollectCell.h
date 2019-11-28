//
//  RCProfileCollectCell.h
//  XFT
//
//  Created by 夏增明 on 2019/8/29.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RCMyCollectStyle;
@interface RCProfileCollectCell : UITableViewCell
/* 收藏户型 */
@property(nonatomic,strong) RCMyCollectStyle *style;
@end

NS_ASSUME_NONNULL_END
