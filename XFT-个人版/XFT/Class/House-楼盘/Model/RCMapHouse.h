//
//  RCMapHouse.h
//  XFT
//
//  Created by 夏增明 on 2019/11/25.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCMapHouse : NSObject
@property (nonatomic, strong) NSString * uuid;
@property (nonatomic, strong) NSString * geo_area_name;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * price;
@property (nonatomic, strong) NSString * areaInterval;
@property (nonatomic, assign) CGFloat  longitude;
@property (nonatomic, assign) CGFloat  dimension;

@end

NS_ASSUME_NONNULL_END
