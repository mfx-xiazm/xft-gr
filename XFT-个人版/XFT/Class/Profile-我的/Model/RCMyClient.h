//
//  RCMyClient.h
//  XFT
//
//  Created by 夏增明 on 2019/11/25.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCMyClient : NSObject
@property (nonatomic, strong) NSString * baouuid;
// 经纪人客户状态0:报备,2:到访,4:认筹,5:认购,6:签约,7:退房,100:失效
// 我的客户状态0:已报备 2:到访 4:认筹 5:认购 6:签约 7:退房 8:失效 9:已发展
@property (nonatomic, strong) NSString * cusState;
@property (nonatomic, strong) NSString * isValid;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, strong) NSString * createTime;
@property (nonatomic, strong) NSString * transTime;
@property (nonatomic, strong) NSString * lastVistTime;

@property (nonatomic, strong) NSString * headpic;
@property (nonatomic, strong) NSString * proName;
@property (nonatomic, strong) NSString * cusUuid;
@property (nonatomic, strong) NSString * proUuid;
@property (nonatomic, strong) NSString * uuid;
@property (nonatomic, strong) NSString * fansUuid;
@property (nonatomic, strong) NSString * tradesTime;
@property (nonatomic, strong) NSString * invalidTime;
@property (nonatomic, strong) NSString * baobeiYuqiTime;
@property (nonatomic, strong) NSString * isLove;
@property (nonatomic, strong) NSString * salesName;
@property (nonatomic, strong) NSString * salesPhone;

@end

NS_ASSUME_NONNULL_END
