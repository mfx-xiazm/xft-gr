//
//  RCPushHouseFilterView.h
//  XFT
//
//  Created by 夏增明 on 2019/8/28.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class RCHouseFilterData,RCPushHouseVC;
typedef void(^pushHouseFilterCall)(NSInteger, NSInteger);
@interface RCPushHouseFilterView : UIView
@property (nonatomic,weak) RCPushHouseVC *target;
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) RCHouseFilterData *filterData;
/** 筛选点击回调 */
@property (nonatomic,copy) pushHouseFilterCall pushHouseFilterCall;
@end

NS_ASSUME_NONNULL_END
