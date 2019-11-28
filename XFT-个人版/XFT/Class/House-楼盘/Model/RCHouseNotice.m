//
//  RCHouseNotice.m
//  XFT
//
//  Created by 夏增明 on 2019/11/21.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCHouseNotice.h"

@implementation RCHouseNotice
-(void)setPublishTime:(NSString *)publishTime
{
    _publishTime = [publishTime getTimeFromTimestamp:@"YYYY-MM-dd HH:mm"];
}
@end
