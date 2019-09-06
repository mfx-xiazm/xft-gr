//
//  RCHouseHeader.h
//  XFT
//
//  Created by 夏增明 on 2019/8/27.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^houseHeaderBtnClicked)(NSInteger,NSInteger);
@interface RCHouseHeader : UIView
/* 点击 */
@property(nonatomic,copy) houseHeaderBtnClicked houseHeaderBtnClicked;
@end

NS_ASSUME_NONNULL_END
