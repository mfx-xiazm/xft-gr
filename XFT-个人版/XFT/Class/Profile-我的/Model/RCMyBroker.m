//
//  RCMyBroker.m
//  XFT
//
//  Created by 夏增明 on 2019/11/25.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCMyBroker.h"

@implementation RCMyBroker
-(void)setCreaTime:(NSString *)creaTime
{
     _creaTime = [creaTime getTimeFromTimestamp:@"YYYY-MM-dd HH:mm"];
}
@end
