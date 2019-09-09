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
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.image.layer.cornerRadius = self.hxn_width/2.0;
    self.image.layer.masksToBounds = YES;
    self.image.layer.borderColor = [UIColor whiteColor].CGColor;
    self.image.layer.borderWidth = 1.f;
}
@end
