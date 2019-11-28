//
//  RCHouseNotice.h
//  XFT
//
//  Created by 夏增明 on 2019/11/21.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCHouseNotice : NSObject
@property (nonatomic, strong) NSString * uuid;
@property (nonatomic, strong) NSString * newsType;
@property (nonatomic, strong) NSString * headPic;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * publishTime;
@property (nonatomic, strong) NSString * context;
@property (nonatomic, strong) NSString * cityUuid;
@property (nonatomic, strong) NSString * viewType;
@property (nonatomic, strong) NSString * clickNum;
@property (nonatomic, strong) NSString * shareNum;
@property (nonatomic, strong) NSString * favoriteNum;
@property (nonatomic, strong) NSString * activityNum;
@property (nonatomic, strong) NSString * createTime;
@property (nonatomic, strong) NSString * editTime;
@property (nonatomic, strong) NSString * state;
@property (nonatomic, strong) NSString * proUuid;

@end

NS_ASSUME_NONNULL_END
