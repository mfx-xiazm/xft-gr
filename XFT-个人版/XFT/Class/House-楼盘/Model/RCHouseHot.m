//
//  RCHouseHot.m
//  XFT
//
//  Created by 夏增明 on 2019/11/22.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCHouseHot.h"

@implementation RCHouseHot
-(void)setTime:(NSString *)time
{
    _time = [time getTimeFromTimestamp:@"YYYY-MM-dd HH:mm"];
}
@end
