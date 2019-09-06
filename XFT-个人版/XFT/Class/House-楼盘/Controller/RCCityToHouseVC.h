//
//  RCCityToHouseVC.h
//  XFT
//
//  Created by 夏增明 on 2019/8/31.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"
#import "RCCityToHouseSearchHeader.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^DidClickTextFieldBlock)(void);
@interface RCCityToHouseVC : HXBaseViewController
@property (strong, nonatomic) UICollectionView *collectionView;
/** 搜索头 */
@property(nonatomic,strong) RCCityToHouseSearchHeader *searchHeader;
@property (nonatomic, assign)   CGFloat                 offsetY; // shadowView在第一个视图中的位置  就3个位置：Y1 Y2 Y3;     offsetY初始值为0 无所谓 不影响结果
@property (nonatomic, copy)     DidClickTextFieldBlock  didClickTextFieldBlock;
- (void)didClickTextField: (DidClickTextFieldBlock)block;
@end

NS_ASSUME_NONNULL_END
