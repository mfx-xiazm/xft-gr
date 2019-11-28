//
//  RCMyCollectNews.m
//  XFT
//
//  Created by 夏增明 on 2019/11/25.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCMyCollectNews.h"

@implementation RCMyCollectNews
-(void)setPublishTime:(NSString *)publishTime
{
    _publishTime = [publishTime getTimeFromTimestamp:@"YYYY-MM-dd"];
}
@end
