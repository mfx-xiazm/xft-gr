//
//  RCStaffHeader.h
//  XFT
//
//  Created by 夏增明 on 2019/8/29.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RCMineNum;
typedef void(^staffHeaderBtnCall)(NSInteger index);
@interface RCStaffHeader : UIView
/* 头视图点击 */
@property(nonatomic,copy) staffHeaderBtnCall staffHeaderBtnCall;
/* 各个数量 */
@property(nonatomic,strong) RCMineNum *mineNum;
@end

NS_ASSUME_NONNULL_END
