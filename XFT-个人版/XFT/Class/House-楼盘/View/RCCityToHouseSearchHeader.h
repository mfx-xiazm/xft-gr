//
//  RCCityToHouseSearchHeader.h
//  XFT
//
//  Created by 夏增明 on 2019/8/31.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXSearchBar.h"

NS_ASSUME_NONNULL_BEGIN
@class HXSearchBar;
@interface RCCityToHouseSearchHeader : UICollectionReusableView
/* 搜索条 */
@property(nonatomic,strong) HXSearchBar *searchBar;
@end

NS_ASSUME_NONNULL_END
