//
//  RCHouseNewsVC.h
//  XFT
//
//  Created by 夏增明 on 2019/8/29.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCHouseNewsVC : HXBaseViewController
/* 是否是资讯搜索 */
@property(nonatomic,assign) BOOL isSearchNews;
/* 关键词 */
@property(nonatomic,copy) NSString *keyword;
/* 楼盘uuid */
@property(nonatomic,copy) NSString *uuid;
@end

NS_ASSUME_NONNULL_END
