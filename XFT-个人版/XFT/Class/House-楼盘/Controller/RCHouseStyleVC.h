//
//  RCHouseStyleVC.h
//  XFT
//
//  Created by 夏增明 on 2019/8/30.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@interface RCHouseStyleVC : HXBaseViewController
/* 楼盘uuid */
@property(nonatomic,copy) NSString *uuid;
/* 是否展示物业类型 0不展示物业，展示顾问 1展示物业，不展示顾问 */
@property(nonatomic,copy) NSString *buldTypeIsShows;
/* 项目物业类型 */
@property(nonatomic,copy) NSString *buldType;
/* 楼盘电话 */
@property(nonatomic,copy) NSString *housePhone;
@end

NS_ASSUME_NONNULL_END
