//
//  RCPushVC.h
//  XFT
//
//  Created by 夏增明 on 2019/8/26.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCPushVC : HXBaseViewController
/* 失效客户重新推荐 楼盘id */
@property(nonatomic,copy) NSString *proUuid;
/* 失效客户重新推荐 客户名字 */
@property(nonatomic,copy) NSString *reName;
/* 失效客户重新推荐 客户电话 */
@property(nonatomic,copy) NSString *rePhone;
@end

NS_ASSUME_NONNULL_END
