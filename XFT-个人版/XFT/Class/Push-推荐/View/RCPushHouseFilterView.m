//
//  RCPushHouseFilterView.m
//  XFT
//
//  Created by 夏增明 on 2019/8/28.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCPushHouseFilterView.h"
#import "HXDropMenuView.h"

@interface RCPushHouseFilterView ()<HXDropMenuDelegate,HXDropMenuDataSource>

@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UIImageView *areaImg;
@property (weak, nonatomic) IBOutlet UILabel *wuyeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *wuyeImg;
@property (weak, nonatomic) IBOutlet UILabel *huxingLabel;
@property (weak, nonatomic) IBOutlet UIImageView *huxingImg;
@property (weak, nonatomic) IBOutlet UILabel *mianjiLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mianjiImg;

/** 过滤 */
@property (nonatomic,strong) HXDropMenuView *menuView;
/** 选择的哪一个分类 */
@property (nonatomic,strong) UIButton *selectBtn;

@end
@implementation RCPushHouseFilterView

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.menuView = [[HXDropMenuView alloc] init];
    self.menuView.dataSource = self;
    self.menuView.delegate = self;
    self.menuView.titleColor = UIColorFromRGB(0x131D2D);
    self.menuView.titleHightLightColor = UIColorFromRGB(0xFF9F08);
}

- (IBAction)filterClicked:(UIButton *)sender {
    if (self.menuView.show) {
        [self.menuView menuHidden];
        return;
    }
    self.selectBtn = sender;
    if (sender.tag == 1) {
        self.menuView.transformImageView = self.areaImg;
        self.menuView.titleLabel = self.areaLabel;
    }else if (sender.tag == 2){
        self.menuView.transformImageView = self.wuyeImg;
        self.menuView.titleLabel = self.wuyeLabel;
    }else if (sender.tag == 3){
        self.menuView.transformImageView = self.huxingImg;
        self.menuView.titleLabel = self.huxingLabel;
    }else{
        self.menuView.transformImageView = self.mianjiImg;
        self.menuView.titleLabel = self.mianjiLabel;
    }

    [self.menuView menuShowInSuperView:self.target.view];
}

#pragma mark -- menuDelegate
- (CGPoint)menu_positionInSuperView {
    return CGPointMake(0, 44);
}
-(NSString *)menu_titleForRow:(NSInteger)row {
    if (self.selectBtn.tag == 1) {
        return self.areas[row];
    }else if (self.selectBtn.tag == 2) {
        return self.wuye[row];
    }else if (self.selectBtn.tag == 3) {
        return self.huxing[row];
    }else{
        return self.mianji[row];
    }
}
-(NSInteger)menu_numberOfRows {
    if (self.selectBtn.tag == 1) {
        return self.areas.count;
    }else if (self.selectBtn.tag == 2) {
        return self.wuye.count;
    }else if (self.selectBtn.tag == 3) {
        return self.huxing.count;
    }else{
        return self.mianji.count;
    }
}
- (void)menu:(HXDropMenuView *)menu didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.pushHouseFilterCall) {
        self.pushHouseFilterCall(self.selectBtn.tag, indexPath.row);
    }
}
@end
