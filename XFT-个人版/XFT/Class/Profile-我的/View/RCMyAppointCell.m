//
//  RCMyAppointCell.m
//  XFT
//
//  Created by 夏增明 on 2019/9/7.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCMyAppointCell.h"
#import "DCAvatar.h"

@interface RCMyAppointCell ()
@property (weak, nonatomic) IBOutlet UIImageView *hotImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hotImageViewWidth;
@end
@implementation RCMyAppointCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [DCAvatarManager sharedAvatar].placeholderImage = [UIImage imageNamed:@"avatarholder"];
    [DCAvatarManager sharedAvatar].groupAvatarType = DCGroupAvatarCustom;
    [DCAvatarManager sharedAvatar].avatarBgColor = [UIColor whiteColor];
    
    [self.hotImageView dc_setImageAvatarWithGroupId:@"avImageViewceshi4" Source:@[@"http://ww1.sinaimg.cn/small/006tNc79gy1g57h4j42ppj30u00u00vy.jpg",@"http://ww1.sinaimg.cn/small/006tNc79gy1g56mcmorgrj30rk0nm0ze.jpg",@"http://ww1.sinaimg.cn/small/006tNc79gy1g56or92vvmj30u00u048a.jpg",@"http://ww1.sinaimg.cn/small/006tNc79gy1g57hfrnhe6j30u00w01eu.jpg"]];
}
- (IBAction)doneClicked:(UIButton *)sender {
    if (self.doneAppointCall) {
        self.doneAppointCall();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
