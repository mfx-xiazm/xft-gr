//
//  RCHouseDetailHotCell.m
//  XFT
//
//  Created by 夏增明 on 2019/8/30.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCHouseDetailHotCell.h"

@interface RCHouseDetailHotCell ()
@property (weak, nonatomic) IBOutlet UIImageView *image;

@end
@implementation RCHouseDetailHotCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.image.layer.cornerRadius = (HX_SCREEN_WIDTH-15.f*7)/6/2.0;
    self.image.layer.masksToBounds = YES;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}
@end
