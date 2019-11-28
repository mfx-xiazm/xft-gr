//
//  RCCityToHouseView.h
//  XFT
//
//  Created by 夏增明 on 2019/9/10.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class RCOpenCity,RCCityToHouseView;

@protocol RCCityToHouseViewDelegate <NSObject>
-(void)cityView:(RCCityToHouseView *)view didSearchReturn:(NSString *)keyword;//被点击
-(void)cityView:(RCCityToHouseView *)view didClickedCity:(RCOpenCity *)city;//被点击

@end
@interface RCCityToHouseView : UIView
/** 城市 */
@property (nonatomic,strong) NSArray *citys;

@property(nonatomic,weak) id<RCCityToHouseViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
