//
//  RCMyClient.m
//  XFT
//
//  Created by 夏增明 on 2019/11/25.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCMyClient.h"

@implementation RCMyClient
-(void)setTransTime:(NSString *)transTime
{
    _transTime = [transTime getTimeFromTimestamp:@"YYYY-MM-dd HH:mm"];
}
-(void)setLastVistTime:(NSString *)lastVistTime
{
    _lastVistTime = [lastVistTime getTimeFromTimestamp:@"YYYY-MM-dd HH:mm"];
}
-(void)setCreateTime:(NSString *)createTime
{
    _createTime = [createTime getTimeFromTimestamp:@"YYYY-MM-dd HH:mm"];
}
-(void)setTradesTime:(NSString *)tradesTime
{
    _tradesTime = [tradesTime getTimeFromTimestamp:@"YYYY-MM-dd HH:mm"];
}
-(void)setInvalidTime:(NSString *)invalidTime
{
    _invalidTime = [invalidTime getTimeFromTimestamp:@"YYYY-MM-dd HH:mm"];
}
-(void)setBaobeiYuqiTime:(NSString *)baobeiYuqiTime
{
    NSDate *currentDate = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval currentDateInt = [currentDate timeIntervalSince1970];

    _baobeiYuqiTime = [NSString stringWithFormat:@"%.f天后失效",ceil(([baobeiYuqiTime integerValue]-currentDateInt)/(3600*24.0))];//向上取整
}
@end
