//
//  RCInnerMsg.m
//  XFT
//
//  Created by 夏增明 on 2019/11/28.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCInnerMsg.h"

@implementation RCInnerMsg
-(void)setCreateDate:(NSString *)createDate
{
    _createDate = [createDate getTimeFromTimestamp:@"YYYY-MM-dd HH:mm"];
}
@end
