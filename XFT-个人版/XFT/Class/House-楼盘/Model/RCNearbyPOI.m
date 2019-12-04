//
//  RCNearbyPOI.m
//  XFT
//
//  Created by 夏增明 on 2019/11/22.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCNearbyPOI.h"

@implementation RCNearbyPOI
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"ad_info":[RCNearbyAdInfo class],
             @"location":[RCNearbyLocation class]
             };
}
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID" : @"id"};
}
@end

@implementation RCNearbyAdInfo

@end

@implementation RCNearbyLocation
@end
