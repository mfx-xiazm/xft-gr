//
//  RCSearchResultHeader.m
//  XFT
//
//  Created by 夏增明 on 2019/11/22.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCSearchResultHeader.h"

@implementation RCSearchResultHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
}
- (IBAction)moreCliked:(UIButton *)sender {
    if (self.moreClickedCall) {
        self.moreClickedCall();
    }
}

@end
