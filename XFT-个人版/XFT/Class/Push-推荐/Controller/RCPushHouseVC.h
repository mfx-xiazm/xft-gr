//
//  RCPushHouseVC.h
//  XFT
//
//  Created by 夏增明 on 2019/8/28.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^wishHouseCall)(NSArray *houses);
@interface RCPushHouseVC : HXBaseViewController
/* 是否批量推荐 批量推荐只能选择1个房源 单独推荐最多选择3个房源*/
@property(nonatomic,assign) BOOL isBatchReport;
/* 选择的意向楼盘回调*/
@property(nonatomic,copy) wishHouseCall wishHouseCall;
/* 传递进来上一次选择的楼盘 */
@property(nonatomic,strong) NSArray *lastHouses;
@end

NS_ASSUME_NONNULL_END
