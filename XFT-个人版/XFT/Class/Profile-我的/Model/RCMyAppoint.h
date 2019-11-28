//
//  RCMyAppoint.h
//  XFT
//
//  Created by 夏增明 on 2019/11/27.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCMyAppoint : NSObject
@property (nonatomic, strong) NSString * productUuid;
@property (nonatomic, strong) NSString * productHeadPic;
@property (nonatomic, strong) NSString * productName;
@property (nonatomic, strong) NSString * getProductprice;
@property (nonatomic, strong) NSString * geoAreaName;
@property (nonatomic, strong) NSString * huxingName;
@property (nonatomic, strong) NSString * roomArea;
@property (nonatomic, strong) NSString * totalAre;
@property (nonatomic, strong) NSString * tag;
@property (nonatomic, strong) NSString * commissionRules;
@property (nonatomic, strong) NSString * watchCount;
@property (nonatomic, strong) NSString * bookTime;
/**预约状态，1：未到访，2：已到访*/
@property (nonatomic, strong) NSString * state;
/**完成状态，1：已完成，2：未完成，3未到访*/
@property (nonatomic, strong) NSString * questionnaire;
@property (nonatomic, strong) NSString * longitude;
@property (nonatomic, strong) NSString * latitude;
@property (nonatomic, strong) NSArray * headpic;
@end

NS_ASSUME_NONNULL_END
