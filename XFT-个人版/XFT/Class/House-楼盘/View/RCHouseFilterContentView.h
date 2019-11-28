//
//  RCHouseFilterContentView.h
//  XFT
//
//  Created by 夏增明 on 2019/11/21.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class RCHouseFilterContentView,GXMaterialFilter;
@protocol RCHouseFilterContentViewDelegate <NSObject>

@required
//出现位置
- (CGPoint)filterMenu_positionInSuperView;
//点击事件
- (void)filterMenu:(RCHouseFilterContentView *)filterView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@optional
//视图消失
- (void)filterMenu_didDismiss;
@end
#pragma mark - 数据源
@protocol RCHouseFilterContentViewDataSource <NSObject>

@required
//设置title
- (NSString *)filterMenu_titleForRow:(NSInteger)row;
//设置size
- (NSInteger)filterMenu_numberOfRows;

@end


@interface RCHouseFilterContentView : UIView
@property (nonatomic, assign) CGFloat menuCellHeight;
@property (nonatomic, assign) CGFloat menuMaxHeight;
@property (nonatomic, strong) UIColor *titleHightLightColor;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, assign ,readonly) BOOL show;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIImageView *transformImageView;
@property (nonatomic, weak) id<RCHouseFilterContentViewDelegate> delegate;
@property (nonatomic, weak) id<RCHouseFilterContentViewDataSource> dataSource;
- (void)reloadData;
- (void)menuHidden;
- (void)menuShowInSuperView:(UIView * _Nullable)view;
@end

NS_ASSUME_NONNULL_END
