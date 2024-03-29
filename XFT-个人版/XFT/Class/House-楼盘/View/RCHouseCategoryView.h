//
//  JXHouseCategoryView.h
//  XFT
//
//  Created by 夏增明 on 2019/9/6.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JXCategoryView.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^mapToHouseCall)(void);
@interface RCHouseCategoryView : UIView
@property (weak, nonatomic) IBOutlet JXCategoryTitleView *categoryView;
/** 子控制器承载scr */
@property (nonatomic,strong) UIScrollView *scrollView;
/** 子控制器数组 */
@property (nonatomic,strong) NSArray *childVCs;
/* 房源分类 */
@property(nonatomic,strong) NSArray *cates;
/* 找房点击 */
@property(nonatomic,copy) mapToHouseCall mapToHouseCall;
@end

NS_ASSUME_NONNULL_END
