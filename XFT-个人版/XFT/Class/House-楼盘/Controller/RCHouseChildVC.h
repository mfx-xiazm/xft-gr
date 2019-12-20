//
//  RCHouseChildVC.h
//  XFT
//
//  Created by 夏增明 on 2019/9/6.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class  RCPageMainTable;
@interface RCHouseChildVC : HXBaseViewController
/* 主视图table */
@property(nonatomic,weak) RCPageMainTable *mainTable;
/* 楼盘类型 */
@property(nonatomic,copy) NSString *proType;
-(void)refreshData:(UIScrollView *)table;
@end

NS_ASSUME_NONNULL_END
