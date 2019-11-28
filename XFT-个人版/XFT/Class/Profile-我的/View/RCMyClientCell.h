//
//  RCMyClientCell.h
//  XFT
//
//  Created by 夏增明 on 2019/8/29.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class RCMyClient;
typedef void(^clientHandleCall)(NSInteger index);
@interface RCMyClientCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *pushBtn;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
/* 客户 */
@property(nonatomic,strong) RCMyClient *client;
/* 点击 */
@property(nonatomic,copy) clientHandleCall clientHandleCall;
@end

NS_ASSUME_NONNULL_END
