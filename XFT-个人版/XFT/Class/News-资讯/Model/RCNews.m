//
//  RCNews.m
//  XFT
//
//  Created by 夏增明 on 2019/11/21.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCNews.h"

@implementation RCNews
-(void)setCreateTime:(NSString *)createTime
{
    _createTime = [createTime getTimeFromTimestamp:@"YYYY-MM-dd"];
}
-(void)setPublishTime:(NSString *)publishTime
{
    _publishTime = [publishTime getTimeFromTimestamp:@"YYYY-MM-dd"];
}
@end
