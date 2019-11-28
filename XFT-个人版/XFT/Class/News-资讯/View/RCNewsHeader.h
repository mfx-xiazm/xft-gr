//
//  RCNewsHeader.h
//  XFT
//
//  Created by 夏增明 on 2019/8/28.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^newsBannerClicked)(NSInteger index);
@interface RCNewsHeader : UIView
/* 轮播图 */
@property(nonatomic,strong) NSArray *banners;
/* 点击 */
@property(nonatomic,copy) newsBannerClicked newsBannerClicked;
@end

NS_ASSUME_NONNULL_END
