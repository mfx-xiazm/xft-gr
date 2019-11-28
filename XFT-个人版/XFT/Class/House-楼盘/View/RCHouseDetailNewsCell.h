//
//  RCHouseDetailNewsCell.h
//  XFT
//
//  Created by 夏增明 on 2019/8/30.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RCNews;
@interface RCHouseDetailNewsCell : UITableViewCell
/* 资讯 */
@property(nonatomic,strong) RCNews *news;
@end

NS_ASSUME_NONNULL_END
