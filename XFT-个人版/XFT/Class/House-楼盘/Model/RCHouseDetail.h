//
//  RCHouseDetail.h
//  XFT
//
//  Created by 夏增明 on 2019/11/22.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class RCHouseStyle;
@interface RCHouseDetail : NSObject
@property (nonatomic, strong) NSString * uuid;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * geoCityName;
@property (nonatomic, strong) NSString * geoAreaName;
@property (nonatomic, assign) CGFloat  longitude;
@property (nonatomic, assign) CGFloat  dimension;
@property (nonatomic, strong) NSString * intr;
@property (nonatomic, strong) NSString * tag;
@property (nonatomic, strong) NSString * price;
@property (nonatomic, strong) NSString * buldAddr;
@property (nonatomic, strong) NSString * salesAddr;
@property (nonatomic, strong) NSString * salesTel;
@property (nonatomic, strong) NSString * areaInterval;
@property (nonatomic, strong) NSString * openTime;
@property (nonatomic, strong) NSString * totalAre;
@property (nonatomic, strong) NSString * commissionRules;
@property (nonatomic, strong) NSString * commissionIntr;
@property (nonatomic, strong) NSString * meritsIntr;
@property (nonatomic, strong) NSString * meritsList;
@property (nonatomic, strong) NSString * proType;
@property (nonatomic, strong) NSString * headPic;
@property (nonatomic, strong) NSArray <RCHouseStyle *> * rhxList;
@property (nonatomic, strong) NSString * watchCount;
@property (nonatomic, strong) NSArray * listWatchPic;
@property (nonatomic, strong) NSString * collectionCount;
@property (nonatomic, strong) NSString * fanCount;
@property (nonatomic, strong) NSString * mainHuxingName;
@property (nonatomic, strong) NSString * salesState;
@property (nonatomic, strong) NSString * mainHuxingBuldArea;
@property (nonatomic, strong) NSString * buildType;
@property (nonatomic, strong) NSString * buldType;
@property (nonatomic, strong) NSString * shareUrl;
@property (nonatomic, strong) NSString * huxingName;
@property (nonatomic, strong) NSString * roomArea;
@property (nonatomic, strong) NSString * buldArea;
@property (nonatomic, strong) NSString * leftHuxingName;
@property (nonatomic, strong) NSString * buldTypeIsShows;
@property (nonatomic, strong) NSString * staffPic;
@end

@interface RCHouseStyle : NSObject
@property (nonatomic, strong) NSString * buldArea;
@property (nonatomic, strong) NSString * housePic;
@property (nonatomic, strong) NSString * hxType;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * roomArea;
@property (nonatomic, strong) NSString * salesState;
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, strong) NSString * totalPrice;
@property (nonatomic, strong) NSString * uuid;
@end

NS_ASSUME_NONNULL_END
