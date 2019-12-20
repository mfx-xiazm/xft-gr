//
//  RCNewsDetailVC.h
//  XFT
//
//  Created by 夏增明 on 2019/8/28.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^lookSuccessCall)(void);
@interface RCNewsDetailVC : HXBaseViewController
/* 资讯id */
@property(nonatomic,copy) NSString *uuid;
/* 查看 */
@property(nonatomic,copy) lookSuccessCall lookSuccessCall;
@end

NS_ASSUME_NONNULL_END
