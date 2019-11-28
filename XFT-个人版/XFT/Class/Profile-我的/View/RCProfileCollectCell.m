//
//  RCProfileCollectCell.m
//  XFT
//
//  Created by 夏增明 on 2019/8/29.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCProfileCollectCell.h"
#import "RCMyCollectStyle.h"

@interface RCProfileCollectCell ()
@property (weak, nonatomic) IBOutlet UIImageView *pic;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *styleName;
@property (weak, nonatomic) IBOutlet UILabel *styleDesc;
@property (weak, nonatomic) IBOutlet UILabel *area;

@end
@implementation RCProfileCollectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setStyle:(RCMyCollectStyle *)style
{
    _style = style;
    
    [self.pic sd_setImageWithURL:[NSURL URLWithString:_style.housePic]];
    self.name.text = _style.proName;
    self.styleName.text = _style.name;
    self.styleDesc.text = _style.hxTypeDisc;
    self.area.text = [NSString stringWithFormat:@"建面%@ 套内%@",_style.buldArea,_style.roomArea];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
