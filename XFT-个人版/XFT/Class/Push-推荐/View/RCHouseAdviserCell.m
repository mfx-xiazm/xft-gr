//
//  RCHouseAdviserCell.m
//  XFT
//
//  Created by 夏增明 on 2019/9/7.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCHouseAdviserCell.h"
#import "RCHouseAdviser.h"

@interface RCHouseAdviserCell ()
@property (weak, nonatomic) IBOutlet UIImageView *tagImg;
@property (weak, nonatomic) IBOutlet UIImageView *headPic;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *notName;

@end
@implementation RCHouseAdviserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setAdviser:(RCHouseAdviser *)adviser
{
    _adviser = adviser;
    if (_adviser.isNotAdviser) {
        self.notName.hidden = NO;
    }else{
        self.notName.hidden = YES;
        [self.headPic sd_setImageWithURL:[NSURL URLWithString:_adviser.headpic] placeholderImage:HXGetImage(@"pic_header")];
        self.name.text = [NSString stringWithFormat:@"%@(%@)",_adviser.accName,_adviser.regPhone];
    }
    self.tagImg.image = _adviser.isSelected ? HXGetImage(@"icon_choose_click") : HXGetImage(@"icon_choose");
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
