//
//  RCHouseDetail.m
//  XFT
//
//  Created by 夏增明 on 2019/11/22.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCHouseDetail.h"

@implementation RCHouseDetail
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"rhxList":[RCHouseStyle class]
             };
}
@end

@implementation RCHouseStyle

@end
