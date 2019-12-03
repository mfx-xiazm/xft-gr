//
//  RCShowPicCell.m
//  XFT
//
//  Created by 夏增明 on 2019/12/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCShowPicCell.h"
#import "RCHouseDetailTopCycle.h"

@interface RCShowPicCell ()
@property (weak, nonatomic) IBOutlet UIImageView *picImg;
@property (weak, nonatomic) IBOutlet UIImageView *tipImg;

@end
@implementation RCShowPicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setCycle:(RCHouseDetailTopCycle *)cycle
{
    _cycle = cycle;
    if ([_cycle.type isEqualToString:@"8"] || [_cycle.type isEqualToString:@"9"]) {
        [self.picImg sd_setImageWithURL:[NSURL URLWithString:_cycle.picUrl]];
       
        self.tipImg.hidden = NO;
        if ([_cycle.type isEqualToString:@"8"]) {
            self.tipImg.image = HXGetImage(@"icon_shipin");
        }else{
            self.tipImg.image = HXGetImage(@"icon_vr");
        }
    }else{
        self.tipImg.hidden = YES;
        [self.picImg sd_setImageWithURL:[NSURL URLWithString:_cycle.url]];
    }
}
@end
