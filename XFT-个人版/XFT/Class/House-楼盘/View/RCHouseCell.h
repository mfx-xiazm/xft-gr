//
//  RCHouseCell.h
//  XFT
//
//  Created by 夏增明 on 2019/8/26.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^selectHouseCall)(void);

@class RCHouseList,RCSearchHouse,RCMyCollectHouse;
@interface RCHouseCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
/* 楼盘 */
@property(nonatomic,strong) RCHouseList *house;
/* 楼盘 */
@property(nonatomic,strong) RCSearchHouse *seaHouse;
/* 收藏 */
@property(nonatomic,strong) RCMyCollectHouse *collect;
/* 选择 */
@property(nonatomic,copy) selectHouseCall selectHouseCall;
@end

NS_ASSUME_NONNULL_END
