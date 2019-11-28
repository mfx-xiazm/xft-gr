//
//  RCChangeInfoVC.h
//  XFT
//
//  Created by 夏增明 on 2019/8/28.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^changeNickCall)(void);
@interface RCChangeInfoVC : HXBaseViewController
/* 回调 */
@property(nonatomic,copy) changeNickCall changeNickCall;
@end

NS_ASSUME_NONNULL_END
