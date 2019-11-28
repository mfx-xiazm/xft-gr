//
//  RCVisitCommentVC.h
//  XFT
//
//  Created by 夏增明 on 2019/9/7.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^submitCall)(void);
@interface RCVisitCommentVC : HXBaseViewController
/* 项目uuid */
@property(nonatomic,copy) NSString *proUuid;
/* 回调 */
@property(nonatomic,copy) submitCall submitCall;
@end

NS_ASSUME_NONNULL_END
