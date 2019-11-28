//
//  RCHouseAdviserVC.h
//  XFT
//
//  Created by 夏增明 on 2019/9/7.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class RCHouseAdviser;
typedef void(^chooseAdviserCall)(RCHouseAdviser *_Nullable adviser);
@interface RCHouseAdviserVC : HXBaseViewController
/* 项目UUid */
@property(nonatomic,copy) NSString *prouuid;
/* 顾问 */
@property(nonatomic,strong) RCHouseAdviser *lastAdvier;
/* 回调 */
@property(nonatomic,copy) chooseAdviserCall chooseAdviserCall;
@end

NS_ASSUME_NONNULL_END
