//
//  RCHouseLoanVC.h
//  XFT
//
//  Created by 夏增明 on 2019/8/30.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCHouseLoanVC : HXBaseViewController
/* 楼盘信息 */
@property(nonatomic,copy) NSString *proName;
@property(nonatomic,copy) NSString *hxName;
@property(nonatomic,copy) NSString *buldArea;
@property(nonatomic,copy) NSString *roomArea;
/* HU型uuid */
@property(nonatomic,copy) NSString *hxUuid;
@end

NS_ASSUME_NONNULL_END
