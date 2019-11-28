//
//  RCMapToHouseView.m
//  XFT
//
//  Created by 夏增明 on 2019/9/10.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCMapToHouseView.h"
#import "RCHouseNearbyCell.h"
#import "RCHouseDetail.h"

static NSString *const HouseNearbyCell = @"HouseNearbyCell";

@interface RCMapToHouseView ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 第一个按键 */
@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
/* 上一次选中的类型按键 */
@property(nonatomic,strong) UIButton *lastBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hotImageViewWidth;
@property (weak, nonatomic) IBOutlet UIView *fourView;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *fourimgs;
@property (weak, nonatomic) IBOutlet UIView *thirdView;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *thirdimgs;
@property (weak, nonatomic) IBOutlet UIView *twoView;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *twoimgs;
@property (weak, nonatomic) IBOutlet UIView *oneView;
@property (weak, nonatomic) IBOutlet UIImageView *oneimg;
@property (weak, nonatomic) IBOutlet UILabel *area;
@property (weak, nonatomic) IBOutlet UIImageView *pic;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *yongjin;
@property (weak, nonatomic) IBOutlet UILabel *weiguanNum;

@end
@implementation RCMapToHouseView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.lastBtn = self.firstBtn;

    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    }
    _tableView.estimatedRowHeight = 0;//预估高度
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    _tableView.showsVerticalScrollIndicator = NO;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.bounces =  NO;
    _tableView.backgroundColor = [UIColor whiteColor];
    
    // 注册cell
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCHouseNearbyCell class]) bundle:nil] forCellReuseIdentifier:HouseNearbyCell];
}
- (IBAction)nearbyTypeClicked:(UIButton *)sender {
    self.lastBtn.selected = NO;
    sender.selected = YES;
    self.lastBtn = sender;
    
    if ([self.delegate respondsToSelector:@selector(nearbyType:didClicked:)]) {
        [self.delegate nearbyType:self didClicked:sender.tag];
    }
}
- (IBAction)houseClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(nearbyHouseDidClicked:)]) {
        [self.delegate nearbyHouseDidClicked:self];
    }
}

-(void)setHouseDetail:(RCHouseDetail *)houseDetail
{
    _houseDetail = houseDetail;
    
    [self.pic sd_setImageWithURL:[NSURL URLWithString:_houseDetail.headPic]];
    self.titleL.text = _houseDetail.name;
    self.area.text = [NSString stringWithFormat:@" %@ ",_houseDetail.geoAreaName.length?_houseDetail.geoAreaName:_houseDetail.geoCityName];
    self.address.text = _houseDetail.buldAddr;
    self.yongjin.text = _houseDetail.commissionRules;
    self.weiguanNum.text = [NSString stringWithFormat:@"%@人围观",_houseDetail.watchCount];
    
    if (_houseDetail.listWatchPic.count >= 4) {
        NSArray *imgs = [_houseDetail.listWatchPic subarrayWithRange:NSMakeRange(0, 4)];
        self.fourView.hidden = NO;
        self.thirdView.hidden = YES;
        self.twoView.hidden = YES;
        self.oneView.hidden = YES;
        self.hotImageViewWidth.constant = 25*imgs.count - 5*(imgs.count-1);
        for (int i=0;i<4;i++) {
            UIImageView *imageView = self.fourimgs[i];
            [imageView sd_setImageWithURL:[NSURL URLWithString:imgs[i]]];
        }
    }else if (_houseDetail.listWatchPic.count == 3){
        self.fourView.hidden = YES;
        self.thirdView.hidden = NO;
        self.twoView.hidden = YES;
        self.oneView.hidden = YES;
        self.hotImageViewWidth.constant = 25*3 - 5*(3-1);
        for (int i=0;i<3;i++) {
            UIImageView *imageView = self.thirdimgs[i];
            [imageView sd_setImageWithURL:[NSURL URLWithString:_houseDetail.listWatchPic[i]]];
        }
    }else if (_houseDetail.listWatchPic.count == 2){
        self.fourView.hidden = YES;
        self.thirdView.hidden = YES;
        self.twoView.hidden = NO;
        self.oneView.hidden = YES;
        self.hotImageViewWidth.constant = 25*2 - 5*(2-1);
        for (int i=0;i<2;i++) {
            UIImageView *imageView = self.twoimgs[i];
            [imageView sd_setImageWithURL:[NSURL URLWithString:_houseDetail.listWatchPic[i]]];
        }
    }else if (_houseDetail.listWatchPic.count == 1){
        self.fourView.hidden = YES;
        self.thirdView.hidden = YES;
        self.twoView.hidden = YES;
        self.oneView.hidden = NO;
        self.hotImageViewWidth.constant = 25;
        [self.oneimg sd_setImageWithURL:[NSURL URLWithString:_houseDetail.listWatchPic.firstObject]];
    }else{
        self.hotImageViewWidth.constant = 10.f;
        self.fourView.hidden = YES;
        self.thirdView.hidden = YES;
        self.twoView.hidden = YES;
        self.oneView.hidden = YES;
    }
}
-(void)setNearbyBus:(NSArray *)nearbyBus
{
    _nearbyBus = nearbyBus;
    [self.tableView reloadData];
}
-(void)setNearbyMedical:(NSArray *)nearbyMedical
{
    _nearbyMedical = nearbyMedical;
    [self.tableView reloadData];
}
-(void)setNearbyBusiness:(NSArray *)nearbyBusiness
{
    _nearbyBusiness = nearbyBusiness;
    [self.tableView reloadData];
}
-(void)setNearbyEducation:(NSArray *)nearbyEducation
{
    _nearbyEducation = nearbyEducation;
    [self.tableView reloadData];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   if (self.lastBtn.tag == 1) {
       return self.nearbyBus.count;
    }else if (self.lastBtn.tag == 2){
       return self.nearbyEducation.count;
    }else if (self.lastBtn.tag == 3){
       return self.nearbyMedical.count;
    }else{
       return self.nearbyBusiness.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCHouseNearbyCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseNearbyCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.numRow.text = [NSString stringWithFormat:@"%zd",indexPath.row+1];
    if (self.lastBtn.tag == 1) {
        RCNearbyPOI *nearby = self.nearbyBus[indexPath.row];
        cell.nearby = nearby;
    }else if (self.lastBtn.tag == 2){
        RCNearbyPOI *nearby = self.nearbyEducation[indexPath.row];
        cell.nearby = nearby;
    }else if (self.lastBtn.tag == 3){
        RCNearbyPOI *nearby = self.nearbyMedical[indexPath.row];
        cell.nearby = nearby;
    }else{
        RCNearbyPOI *nearby = self.nearbyBusiness[indexPath.row];
        cell.nearby = nearby;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 44.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCNearbyPOI *nearby = nil;
       if (self.lastBtn.tag == 1) {
           nearby = self.nearbyBus[indexPath.row];
       }else if (self.lastBtn.tag == 2){
           nearby = self.nearbyEducation[indexPath.row];
       }else if (self.lastBtn.tag == 3){
           nearby = self.nearbyMedical[indexPath.row];
       }else{
           nearby = self.nearbyBusiness[indexPath.row];
       }
    if ([self.delegate respondsToSelector:@selector(nearbyView:nearbyType:didClickedPOI:)]) {
        [self.delegate nearbyView:self nearbyType:self.lastBtn.tag didClickedPOI:nearby];
    }
}
@end
