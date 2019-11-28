//
//  RCHouseHotCell.m
//  XFT
//
//  Created by 夏增明 on 2019/8/29.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCHouseHotCell.h"
#import "RCHouseHot.h"

@interface RCHouseHotCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headPic;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;

@end
@implementation RCHouseHotCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setHot:(RCHouseHot *)hot
{
    _hot = hot;
    [self.headPic sd_setImageWithURL:[NSURL URLWithString:_hot.headpic] placeholderImage:HXGetImage(@"avatarholder")];
    self.name.text = _hot.nick;
    self.time.text = _hot.time;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
