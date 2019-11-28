//
//  RCPushHouseFilterView.m
//  XFT
//
//  Created by 夏增明 on 2019/8/28.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCPushHouseFilterView.h"
#import "HXDropMenuView.h"
#import "RCHouseFilterData.h"
#import "HXBaseViewController.h"
#import "RCPushHouseVC.h"

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
-(void)setFilterData:(RCHouseFilterData *)filterData
{
    _filterData = filterData;
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
    return CGPointMake(0, 44.f);
}
-(NSString *)menu_titleForRow:(NSInteger)row {
    if (self.selectBtn.tag == 1) {
        RCHouseFilterDistrict *dus = self.filterData.countryList[row];
        return dus.name;
    }else if (self.selectBtn.tag == 2) {
        RCHouseFilterService *ser = self.filterData.buldType[row];
        return ser.dictName;
    }else if (self.selectBtn.tag == 3) {
        RCHouseFilterStyle *sty = self.filterData.hxType[row];
        return sty.dictName;
    }else{
        RCHouseFilterArea *area = self.filterData.areaType[row];
        return area.dictName;
    }
}
-(NSInteger)menu_numberOfRows {
    if (self.selectBtn.tag == 1) {
        return self.filterData.countryList.count;
    }else if (self.selectBtn.tag == 2) {
        return self.filterData.buldType.count;
    }else if (self.selectBtn.tag == 3) {
        return self.filterData.hxType.count;
    }else{
        return self.filterData.areaType.count;
    }
}
- (void)menu:(HXDropMenuView *)menu didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectBtn.tag == 1) {
        RCHouseFilterDistrict *dus = self.filterData.countryList[indexPath.row];
        self.areaLabel.text = indexPath.row ?dus.name:@"行政区域";
    }else if (self.selectBtn.tag == 2){
        RCHouseFilterService *ser = self.filterData.buldType[indexPath.row];
        self.wuyeLabel.text = indexPath.row ?ser.dictName:@"物业类型";
    }else if (self.selectBtn.tag == 3){
        RCHouseFilterStyle *sty = self.filterData.hxType[indexPath.row];
        self.huxingLabel.text = indexPath.row ?sty.dictName:@"户型";
    }else{
        RCHouseFilterArea *area = self.filterData.areaType[indexPath.row];
        self.mianjiLabel.text = indexPath.row ?area.dictName:@"面积";
    }
    if (self.pushHouseFilterCall) {
        self.pushHouseFilterCall(self.selectBtn.tag, indexPath.row);
    }
}
@end
