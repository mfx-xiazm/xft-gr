//
//  RCProfileHeader.h
//  XFT
//
//  Created by 夏增明 on 2019/8/28.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RCMineNum;
typedef void(^profileHeaderClicked)(void);
@interface RCProfileHeader : UIView
/* 点击 */
@property(nonatomic,copy) profileHeaderClicked profileHeaderClicked;
/* 个人数量信息 */
@property(nonatomic,strong) RCMineNum *mineNum;
@end

NS_ASSUME_NONNULL_END
