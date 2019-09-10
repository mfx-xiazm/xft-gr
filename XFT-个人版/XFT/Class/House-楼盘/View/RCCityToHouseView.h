//
//  RCCityToHouseView.h
//  XFT
//
//  Created by 夏增明 on 2019/9/10.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^didSelectCityCall)(void);
@interface RCCityToHouseView : UIView
/* 选中城市 */
@property(nonatomic,copy) didSelectCityCall didSelectCityCall;
@end

NS_ASSUME_NONNULL_END
