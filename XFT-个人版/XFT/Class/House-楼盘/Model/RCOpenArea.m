//
//  RCOpenArea.m
//  XFT
//
//  Created by 夏增明 on 2019/11/21.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCOpenArea.h"

@implementation RCOpenArea
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list":[RCOpenCity class]
             };
}
@end

@implementation RCOpenCity

@end
