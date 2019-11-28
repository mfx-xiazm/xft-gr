//
//  RCMyAppoint.m
//  XFT
//
//  Created by 夏增明 on 2019/11/27.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCMyAppoint.h"

@implementation RCMyAppoint
-(void)setBookTime:(NSString *)bookTime
{
    _bookTime = [bookTime getTimeFromTimestamp:@"yyyy-MM-dd"];
}
@end
