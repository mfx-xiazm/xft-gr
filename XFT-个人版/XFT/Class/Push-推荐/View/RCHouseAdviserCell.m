//
//  RCHouseAdviserCell.m
//  XFT
//
//  Created by 夏增明 on 2019/9/7.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCHouseAdviserCell.h"

@interface RCHouseAdviserCell ()
@property (weak, nonatomic) IBOutlet UIImageView *tagImg;

@end
@implementation RCHouseAdviserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.tagImg.image = selected ? HXGetImage(@"icon_choose_click") : HXGetImage(@"icon_choose");
}

@end
