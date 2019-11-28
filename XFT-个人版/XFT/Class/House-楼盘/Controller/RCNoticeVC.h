//
//  RCNoticeVC.h
//  XFT
//
//  Created by 夏增明 on 2019/8/28.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCNoticeVC : HXBaseViewController
/* 标题 */
@property(nonatomic,copy) NSString *navTitle;
/* 是否是站内信 */
@property(nonatomic,assign) BOOL isInnerMsg;
@end

NS_ASSUME_NONNULL_END
