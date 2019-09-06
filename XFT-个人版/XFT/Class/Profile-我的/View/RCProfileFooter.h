//
//  RCProfileFooter.h
//  XFT
//
//  Created by 夏增明 on 2019/9/6.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^upRoleCall)(void);
@interface RCProfileFooter : UIView
/* 升级 */
@property(nonatomic,copy) upRoleCall upRoleCall;
@end

NS_ASSUME_NONNULL_END
