//
//  RCMyAppointFooter.m
//  XFT
//
//  Created by 夏增明 on 2019/11/27.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCMyAppointFooter.h"

@implementation RCMyAppointFooter

-(void)awakeFromNib
{
    [super awakeFromNib];
}

- (IBAction)doneClicked:(UIButton *)sender {
    if (self.doneAppointCall) {
        self.doneAppointCall();
    }
}
@end
