//
//  RCNews.h
//  XFT
//
//  Created by 夏增明 on 2019/11/21.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCNews : NSObject
@property(nonatomic,copy) NSString *uuid;
@property(nonatomic,copy) NSString *newsType;
@property(nonatomic,copy) NSString *headPic;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *publishTime;
@property(nonatomic,copy) NSString *context;
@property(nonatomic,copy) NSString *cityUuid;
@property(nonatomic,copy) NSString *viewType;
@property(nonatomic,copy) NSString *clickNum;
@property(nonatomic,copy) NSString *shareNum;
@property(nonatomic,copy) NSString *favoriteNum;
@property(nonatomic,copy) NSString *activityNum;
@property(nonatomic,copy) NSString *createTime;
@property(nonatomic,copy) NSString *editTime;
@property(nonatomic,copy) NSString *state;
@property(nonatomic,copy) NSString *proUuid;
@property(nonatomic,copy) NSString *proName;
@property(nonatomic,copy) NSString *endTime;
@property(nonatomic,copy) NSString *shareUrl;
@property(nonatomic,copy) NSString *productName;

@end

NS_ASSUME_NONNULL_END
