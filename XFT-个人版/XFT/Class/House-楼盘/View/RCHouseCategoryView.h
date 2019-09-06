//
//  JXHouseCategoryView.h
//  XFT
//
//  Created by 夏增明 on 2019/9/6.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^mapToHouseCall)(void);
@interface RCHouseCategoryView : UIView
/** 子控制器承载scr */
@property (nonatomic,strong) UIScrollView *scrollView;
/** 子控制器数组 */
@property (nonatomic,strong) NSArray *childVCs;
/* 找房点击 */
@property(nonatomic,copy) mapToHouseCall mapToHouseCall;
@end

NS_ASSUME_NONNULL_END
