//
//  RCNearbyPOI.h
//  XFT
//
//  Created by 夏增明 on 2019/11/22.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class RCNearbyAdInfo,RCNearbyLocation;
@interface RCNearbyPOI : NSObject
@property (nonatomic, copy) NSString *_distance;
@property (nonatomic, strong) RCNearbyAdInfo * ad_info;
@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSString * category;
@property (nonatomic, strong) NSString * ID;
@property (nonatomic, strong) RCNearbyLocation * location;
@property (nonatomic, strong) NSString * tel;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, assign) NSInteger type;
@end

@interface RCNearbyAdInfo : NSObject
@property (nonatomic, assign) NSInteger adcode;
@property (nonatomic, strong) NSString * city;
@property (nonatomic, strong) NSString * district;
@property (nonatomic, strong) NSString * province;
@end

@interface RCNearbyLocation : NSObject
@property (nonatomic, assign) CGFloat lat;
@property (nonatomic, assign) CGFloat lng;
@end

NS_ASSUME_NONNULL_END
