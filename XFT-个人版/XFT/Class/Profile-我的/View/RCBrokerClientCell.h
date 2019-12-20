//
//  RCBrokerClientCell.h
//  XFT
//
//  Created by 夏增明 on 2019/9/7.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class RCMyClient;
@interface RCBrokerClientCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *state;
/* 客户 */
@property(nonatomic,strong) RCMyClient *client;
@end

NS_ASSUME_NONNULL_END
