//
//  RCPushClientEditVC.h
//  XFT
//
//  Created by 夏增明 on 2019/9/7.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class RCReportTarget;
typedef void(^editDoneCall)(void);
@interface RCPushClientEditVC : HXBaseViewController
/* 是否展示物业类型 0不展示物业，展示顾问 1展示物业，不展示顾问 */
@property(nonatomic,copy) NSString *buldTypeIsShows;
/* 项目id */
@property(nonatomic,copy) NSString *proUuid;
/* 项目物业类型 */
@property(nonatomic,copy) NSString *buldType;
/* 可以用这个来判断是否是楼盘详情的推荐push */
@property(nonatomic,assign) BOOL isDetailPush;
/* 编辑客户 */
@property(nonatomic,strong) RCReportTarget *reportTarget;
/* 客户编辑完成 */
@property(nonatomic,copy) editDoneCall editDoneCall;
@end

NS_ASSUME_NONNULL_END
