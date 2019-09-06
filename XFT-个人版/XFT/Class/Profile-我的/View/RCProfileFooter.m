//
//  RCProfileFooter.m
//  XFT
//
//  Created by 夏增明 on 2019/9/6.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCProfileFooter.h"

@implementation RCProfileFooter

-(void)awakeFromNib
{
    [super awakeFromNib];
}
- (IBAction)uoclicked:(UIButton *)sender {
    if (self.upRoleCall) {
        self.upRoleCall();
    }
}

@end
