//
//  RCHouseCell.m
//  XFT
//
//  Created by 夏增明 on 2019/8/26.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCHouseCell.h"
#import "RCHouseList.h"
#import "RCSearchHouse.h"
#import "RCMyCollectHouse.h"

@interface RCHouseCell ()
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

@end
@implementation RCHouseCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
-(void)setHouse:(RCHouseList *)house
{
    _house = house;
    [self.pic sd_setImageWithURL:[NSURL URLWithString:_house.headpic]];
    self.titleL.text = _house.name;
    self.price.text = _house.price;
    self.area.text = [NSString stringWithFormat:@"%@ %@",_house.huXingName,_house.roomArea];
    if (_house.tag && _house.tag.length) {
        NSArray *tagNames = [_house.tag componentsSeparatedByString:@","];
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
    self.yongjin.text = _house.commissionRules;
    self.weiguanNum.text = [NSString stringWithFormat:@"%@人围观",_house.watchCount];
    
    if (_house.headpicList.count >= 4) {
        NSArray *imgs = [_house.headpicList subarrayWithRange:NSMakeRange(0, 4)];
        self.fourView.hidden = NO;
        self.thirdView.hidden = YES;
        self.twoView.hidden = YES;
        self.oneView.hidden = YES;
        self.hotImageViewWidth.constant = 25*imgs.count - 5*(imgs.count-1);
        for (int i=0;i<4;i++) {
            UIImageView *imageView = self.fourimgs[i];
            [imageView sd_setImageWithURL:[NSURL URLWithString:imgs[i]]];
        }
    }else if (_house.headpicList.count == 3){
        self.fourView.hidden = YES;
        self.thirdView.hidden = NO;
        self.twoView.hidden = YES;
        self.oneView.hidden = YES;
        self.hotImageViewWidth.constant = 25*3 - 5*(3-1);
        for (int i=0;i<3;i++) {
            UIImageView *imageView = self.thirdimgs[i];
            [imageView sd_setImageWithURL:[NSURL URLWithString:_house.headpicList[i]]];
        }
    }else if (_house.headpicList.count == 2){
        self.fourView.hidden = YES;
        self.thirdView.hidden = YES;
        self.twoView.hidden = NO;
        self.oneView.hidden = YES;
        self.hotImageViewWidth.constant = 25*2 - 5*(2-1);
        for (int i=0;i<2;i++) {
            UIImageView *imageView = self.twoimgs[i];
            [imageView sd_setImageWithURL:[NSURL URLWithString:_house.headpicList[i]]];
        }
    }else if (_house.headpicList.count == 1){
        self.fourView.hidden = YES;
        self.thirdView.hidden = YES;
        self.twoView.hidden = YES;
        self.oneView.hidden = NO;
        self.hotImageViewWidth.constant = 25;
        [self.oneimg sd_setImageWithURL:[NSURL URLWithString:_house.headpicList.firstObject]];
    }else{
        self.hotImageViewWidth.constant = 10.f;
        self.fourView.hidden = YES;
        self.thirdView.hidden = YES;
        self.twoView.hidden = YES;
        self.oneView.hidden = YES;
    }
    if (_house.isSelected) {
        self.selectBtn.selected = YES;
        self.selectBtn.backgroundColor = HXRGBAColor(255, 159, 8, 0.2);
    }else{
        self.selectBtn.selected = NO;
        self.selectBtn.backgroundColor = UIColorFromRGB(0xF6F7FB);
    }
}
- (IBAction)selectBtnClicked:(UIButton *)sender {
    if (self.selectHouseCall) {
        self.selectHouseCall();
    }
}
-(void)setSeaHouse:(RCSearchHouse *)seaHouse
{
    _seaHouse = seaHouse;
    
    [self.pic sd_setImageWithURL:[NSURL URLWithString:_seaHouse.headPic]];
    self.titleL.text = _seaHouse.name;
    self.price.text = _seaHouse.price;
    self.area.text = [NSString stringWithFormat:@"%@ %@",_seaHouse.mainHuxingName,_seaHouse.areaInterval];
    if (_seaHouse.tag && _seaHouse.tag.length) {
        NSArray *tagNames = [_seaHouse.tag componentsSeparatedByString:@","];
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
    self.yongjin.text = _seaHouse.commissionRules;
    self.weiguanNum.text = [NSString stringWithFormat:@"%@人围观",_seaHouse.collectionCount];
    
    if (_seaHouse.headpicList.count >= 4) {
        NSArray *imgs = [_seaHouse.headpicList subarrayWithRange:NSMakeRange(0, 4)];
        self.fourView.hidden = NO;
        self.thirdView.hidden = YES;
        self.twoView.hidden = YES;
        self.oneView.hidden = YES;
        self.hotImageViewWidth.constant = 25*imgs.count - 5*(imgs.count-1);
        for (int i=0;i<4;i++) {
            UIImageView *imageView = self.fourimgs[i];
            [imageView sd_setImageWithURL:[NSURL URLWithString:imgs[i]]];
        }
    }else if (_seaHouse.headpicList.count == 3){
        self.fourView.hidden = YES;
        self.thirdView.hidden = NO;
        self.twoView.hidden = YES;
        self.oneView.hidden = YES;
        self.hotImageViewWidth.constant = 25*3 - 5*(3-1);
        for (int i=0;i<3;i++) {
            UIImageView *imageView = self.thirdimgs[i];
            [imageView sd_setImageWithURL:[NSURL URLWithString:_seaHouse.headpicList[i]]];
        }
    }else if (_seaHouse.headpicList.count == 2){
        self.fourView.hidden = YES;
        self.thirdView.hidden = YES;
        self.twoView.hidden = NO;
        self.oneView.hidden = YES;
        self.hotImageViewWidth.constant = 25*2 - 5*(2-1);
        for (int i=0;i<2;i++) {
            UIImageView *imageView = self.twoimgs[i];
            [imageView sd_setImageWithURL:[NSURL URLWithString:_seaHouse.headpicList[i]]];
        }
    }else if (_seaHouse.headpicList.count == 1){
        self.fourView.hidden = YES;
        self.thirdView.hidden = YES;
        self.twoView.hidden = YES;
        self.oneView.hidden = NO;
        self.hotImageViewWidth.constant = 25;
        [self.oneimg sd_setImageWithURL:[NSURL URLWithString:_seaHouse.headpicList.firstObject]];
    }else{
        self.hotImageViewWidth.constant = 10.f;
        self.fourView.hidden = YES;
        self.thirdView.hidden = YES;
        self.twoView.hidden = YES;
        self.oneView.hidden = YES;
    }
}
-(void)setCollect:(RCMyCollectHouse *)collect
{
    _collect = collect;
    [self.pic sd_setImageWithURL:[NSURL URLWithString:_collect.headPic]];
    self.titleL.text = _collect.name;
    self.price.text = _collect.price;
    self.area.text = [NSString stringWithFormat:@"%@ %@",_collect.mainHuxingName,_collect.areaInterval];
    if (_collect.tag && _collect.tag.length) {
        NSArray *tagNames = [_collect.tag componentsSeparatedByString:@","];
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
    self.yongjin.text = _collect.commissionRules;
    self.weiguanNum.text = [NSString stringWithFormat:@"%@人围观",_collect.watchCount];
    
    if (_collect.listWatchPic.count >= 4) {
        NSArray *imgs = [_collect.listWatchPic subarrayWithRange:NSMakeRange(0, 4)];
        self.fourView.hidden = NO;
        self.thirdView.hidden = YES;
        self.twoView.hidden = YES;
        self.oneView.hidden = YES;
        self.hotImageViewWidth.constant = 25*imgs.count - 5*(imgs.count-1);
        for (int i=0;i<4;i++) {
            UIImageView *imageView = self.fourimgs[i];
            [imageView sd_setImageWithURL:[NSURL URLWithString:imgs[i]]];
        }
    }else if (_collect.listWatchPic.count == 3){
        self.fourView.hidden = YES;
        self.thirdView.hidden = NO;
        self.twoView.hidden = YES;
        self.oneView.hidden = YES;
        self.hotImageViewWidth.constant = 25*3 - 5*(3-1);
        for (int i=0;i<3;i++) {
            UIImageView *imageView = self.thirdimgs[i];
            [imageView sd_setImageWithURL:[NSURL URLWithString:_collect.listWatchPic[i]]];
        }
    }else if (_collect.listWatchPic.count == 2){
        self.fourView.hidden = YES;
        self.thirdView.hidden = YES;
        self.twoView.hidden = NO;
        self.oneView.hidden = YES;
        self.hotImageViewWidth.constant = 25*2 - 5*(2-1);
        for (int i=0;i<2;i++) {
            UIImageView *imageView = self.twoimgs[i];
            [imageView sd_setImageWithURL:[NSURL URLWithString:_collect.listWatchPic[i]]];
        }
    }else if (_collect.listWatchPic.count == 1){
        self.fourView.hidden = YES;
        self.thirdView.hidden = YES;
        self.twoView.hidden = YES;
        self.oneView.hidden = NO;
        self.hotImageViewWidth.constant = 25;
        [self.oneimg sd_setImageWithURL:[NSURL URLWithString:_collect.listWatchPic.firstObject]];
    }else{
        self.hotImageViewWidth.constant = 10.f;
        self.fourView.hidden = YES;
        self.thirdView.hidden = YES;
        self.twoView.hidden = YES;
        self.oneView.hidden = YES;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
