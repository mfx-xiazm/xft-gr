//
//  RCMyCollectHouse.h
//  XFT
//
//  Created by 夏增明 on 2019/11/25.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCMyCollectHouse : NSObject
@property (nonatomic, strong) NSString * uuid;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * headPic;
@property (nonatomic, strong) NSString * geoAreaName;
@property (nonatomic, strong) NSString * price;
@property (nonatomic, strong) NSString * areaInterval;
@property (nonatomic, strong) NSString * tag;
@property (nonatomic, strong) NSString * mainHuxingName;
@property (nonatomic, strong) NSString * housePrice;
@property (nonatomic, strong) NSString * commissionRules;
@property (nonatomic, strong) NSString * watchCount;
@property (nonatomic, strong) NSString * huxingName;
@property (nonatomic, strong) NSString * roomArea;
@property (nonatomic, strong) NSArray * listWatchPic;

@property (nonatomic, assign) CGFloat  longitude;
@property (nonatomic, assign) CGFloat  dimension;

@end

NS_ASSUME_NONNULL_END
