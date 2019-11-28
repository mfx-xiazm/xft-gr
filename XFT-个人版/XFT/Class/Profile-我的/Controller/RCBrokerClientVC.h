//
//  RCBrokerClientVC.h
//  XFT
//
//  Created by 夏增明 on 2019/9/7.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCBrokerClientVC : HXBaseViewController
/* 经纪人uuid */
@property(nonatomic,copy) NSString *uuid;
/* 经纪人name */
@property(nonatomic,copy) NSString *accName;
@end

NS_ASSUME_NONNULL_END
