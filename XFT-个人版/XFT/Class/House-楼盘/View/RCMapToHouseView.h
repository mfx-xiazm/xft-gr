//
//  RCMapToHouseView.h
//  XFT
//
//  Created by 夏增明 on 2019/9/10.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RCMapToHouseView,RCHouseDetail,RCNearbyPOI;
@protocol RCMapToHouseViewDelegate <NSObject>

-(void)nearbyType:(RCMapToHouseView *)view didClicked:(NSInteger)index;//被点击
-(void)nearbyHouseDidClicked:(RCMapToHouseView *)view;
-(void)nearbyView:(RCMapToHouseView *)view nearbyType:(NSInteger)type didClickedPOI:(RCNearbyPOI *)poi;//被点击

@end
@interface RCMapToHouseView : UIView
/* 点击 */
@property(nonatomic,weak) id<RCMapToHouseViewDelegate> delegate;
/** 楼盘全部详情数据 */
@property(nonatomic,strong) RCHouseDetail *houseDetail;
/** 周边交通 */
@property(nonatomic,strong) NSArray *nearbyBus;
/** 周边教育 */
@property(nonatomic,strong) NSArray *nearbyEducation;
/** 周边医疗 */
@property(nonatomic,strong) NSArray *nearbyMedical;
/** 周边商业 */
@property(nonatomic,strong) NSArray *nearbyBusiness;
@end

NS_ASSUME_NONNULL_END
