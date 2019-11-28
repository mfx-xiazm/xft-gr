//
//  RCMyAppointCell.m
//  XFT
//
//  Created by 夏增明 on 2019/9/7.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCMyAppointCell.h"
#import "DCAvatar.h"
#import "RCMyAppoint.h"

@interface RCMyAppointCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hotImageViewWidth;
@property (weak, nonatomic) IBOutlet UIView *fourView;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *fourimgs;
@property (weak, nonatomic) IBOutlet UIView *thirdView;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *thirdimgs;
@property (weak, nonatomic) IBOutlet UIView *twoView;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *twoimgs;
@property (weak, nonatomic) IBOutlet UIView *oneView;
@property (weak, nonatomic) IBOutlet UIImageView *oneimg;

@property (weak, nonatomic) IBOutlet UIImageView *pic;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *area;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *tags;
@property (weak, nonatomic) IBOutlet UILabel *yongjin;
@property (weak, nonatomic) IBOutlet UILabel *weiguanNum;
@property (weak, nonatomic) IBOutlet UILabel *appintTime;

@end
@implementation RCMyAppointCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
-(void)setAppoint:(RCMyAppoint *)appoint
{
    _appoint = appoint;
    [self.pic sd_setImageWithURL:[NSURL URLWithString:_appoint.productHeadPic]];
    self.titleL.text = _appoint.productName;
    self.price.text = _appoint.getProductprice;
    self.area.text = [NSString stringWithFormat:@"%@ %@",_appoint.huxingName,_appoint.roomArea];
    if (_appoint.tag && _appoint.tag.length) {
        NSArray *tagNames = [_appoint.tag componentsSeparatedByString:@","];
        for (int i=0; i<self.tags.count; i++) {
            UILabel *tagL = self.tags[i];
            if ((tagNames.count-1) >= i) {
                tagL.hidden = NO;
                tagL.text = [NSString stringWithFormat:@" %@ ",tagNames[i]];
            }else{
                tagL.hidden = YES;
            }
        }
    }else{
        for (UILabel *tagL in self.tags) {
            tagL.hidden = YES;
        }
    }
    self.yongjin.text = _appoint.commissionRules;
    self.weiguanNum.text = [NSString stringWithFormat:@"%@人围观",_appoint.watchCount];
    
    if (_appoint.headpic.count >= 4) {
        NSArray *imgs = [_appoint.headpic subarrayWithRange:NSMakeRange(0, 4)];
        self.fourView.hidden = NO;
        self.thirdView.hidden = YES;
        self.twoView.hidden = YES;
        self.oneView.hidden = YES;
        self.hotImageViewWidth.constant = 25*imgs.count - 5*(imgs.count-1);
        for (int i=0;i<4;i++) {
            UIImageView *imageView = self.fourimgs[i];
            [imageView sd_setImageWithURL:[NSURL URLWithString:imgs[i]]];
        }
    }else if (_appoint.headpic.count == 3){
        self.fourView.hidden = YES;
        self.thirdView.hidden = NO;
        self.twoView.hidden = YES;
        self.oneView.hidden = YES;
        self.hotImageViewWidth.constant = 25*3 - 5*(3-1);
        for (int i=0;i<3;i++) {
            UIImageView *imageView = self.thirdimgs[i];
            [imageView sd_setImageWithURL:[NSURL URLWithString:_appoint.headpic[i]]];
        }
    }else if (_appoint.headpic.count == 2){
        self.fourView.hidden = YES;
        self.thirdView.hidden = YES;
        self.twoView.hidden = NO;
        self.oneView.hidden = YES;
        self.hotImageViewWidth.constant = 25*2 - 5*(2-1);
        for (int i=0;i<2;i++) {
            UIImageView *imageView = self.twoimgs[i];
            [imageView sd_setImageWithURL:[NSURL URLWithString:_appoint.headpic[i]]];
        }
    }else if (_appoint.headpic.count == 1){
        self.fourView.hidden = YES;
        self.thirdView.hidden = YES;
        self.twoView.hidden = YES;
        self.oneView.hidden = NO;
        self.hotImageViewWidth.constant = 25;
        [self.oneimg sd_setImageWithURL:[NSURL URLWithString:_appoint.headpic.firstObject]];
    }else{
        self.hotImageViewWidth.constant = 10.f;
        self.fourView.hidden = YES;
        self.thirdView.hidden = YES;
        self.twoView.hidden = YES;
        self.oneView.hidden = YES;
    }
    
    self.appintTime.text = [NSString stringWithFormat:@"预约时间：%@",_appoint.bookTime];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
