//
//  RCHouseStyleCell.h
//  XFT
//
//  Created by 夏增明 on 2019/8/30.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class RCHouseStyle;
typedef void(^jisuanCall)(void);
@interface RCHouseStyleCell : UICollectionViewCell
/* 户型 */
@property(nonatomic,assign) RCHouseStyle *style;
/* 计算 */
@property(nonatomic,copy) jisuanCall jisuanCall;
@end

NS_ASSUME_NONNULL_END
