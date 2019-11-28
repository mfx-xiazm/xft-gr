//
//  RCInnerMsg.h
//  XFT
//
//  Created by 夏增明 on 2019/11/28.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCInnerMsg : NSObject
@property (nonatomic, strong) NSString * content;//消息主体
@property (nonatomic, strong) NSString * createDate;//通知时间
@property (nonatomic, strong) NSString * isDel;//删除/正常
@property (nonatomic, strong) NSString * state;//已读/未读
/**1.客户失效通知,    2.客户到访通知,   3.客户成交(认购、签约)通知,    4.客户转入转出通知*/
@property (nonatomic, strong) NSString * type;//消息类型
@property (nonatomic, strong) NSString * uuid;//消息UUID
@end

NS_ASSUME_NONNULL_END
