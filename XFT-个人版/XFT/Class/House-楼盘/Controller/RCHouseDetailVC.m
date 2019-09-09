//
//  RCHouseDetailVC.m
//  XFT
//
//  Created by 夏增明 on 2019/8/29.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCHouseDetailVC.h"
#import "RCHouseAppointVC.h"
#import "RCHouseNewsVC.h"
#import "RCHouseHotVC.h"
#import "RCShareView.h"
#import <zhPopupController.h>
#import "RCBannerCell.h"
#import <TYCyclePagerView/TYCyclePagerView.h>
#import "RCHouseDetailHotCell.h"
#import <ZLCollectionViewVerticalLayout.h>
#import <ZLCollectionViewHorzontalLayout.h>
#import "RCHouseDetailInfoCell.h"
#import "RCHouseDetailNewsCell.h"
#import "RCHouseStyleCell.h"
#import <MAMapKit/MAMapKit.h>
#import "RCHouseLoanVC.h"
#import "RCHouseStyleVC.h"
#import "RCHouseNearbyVC.h"
#import "RCNewsDetailVC.h"
#import "zhAlertView.h"
#import "RCHouseInfoVC.h"
#import <JXCategoryTitleView.h>
#import <JXCategoryIndicatorBackgroundView.h>
#import "RCPanoramaVC.h"
#import "RCVideoFullScreenVC.h"
#import "HXNavigationController.h"
#import "NSString+HXNExtension.h"
#import "RCHouseGoodsCell.h"
#import "RCHouseNearbyCell.h"
#import "RCFlowLayout.h"

static NSString *const HouseDetailHotCell = @"HouseDetailHotCell";
static NSString *const HouseDetailInfoCell = @"HouseDetailInfoCell";
static NSString *const HouseDetailNewsCell = @"HouseDetailNewsCell";
static NSString *const HouseStyleCell = @"HouseStyleCell";
static NSString *const HouseGoodsCell = @"HouseGoodsCell";
static NSString *const HouseNearbyCell = @"HouseNearbyCell";

@interface RCHouseDetailVC ()<TYCyclePagerViewDataSource, TYCyclePagerViewDelegate, UICollectionViewDelegate,UICollectionViewDataSource,ZLCollectionViewBaseFlowLayoutDelegate,UITableViewDelegate,UITableViewDataSource,MAMapViewDelegate,JXCategoryViewDelegate>
/** 轮播图 */
@property (weak, nonatomic) IBOutlet TYCyclePagerView *cycleView;
@property (weak, nonatomic) IBOutlet UILabel *cycleNum;
@property (weak, nonatomic) IBOutlet JXCategoryTitleView *categoryView;
/** 楼盘基础信息 */
@property (weak, nonatomic) IBOutlet UIView *houseInfoView;
/** 楼盘热度 */
@property (weak, nonatomic) IBOutlet UICollectionView *houseHotCollectionView;
/** 楼盘信息展示 */
@property (weak, nonatomic) IBOutlet UITableView *houseInfoTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *houseInfoTableViewHeight;
/** 推荐佣金 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *recommendRewardViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *houseRewardLabel;
/** 楼盘亮点 */
@property (weak, nonatomic) IBOutlet UILabel *houseGoodsLabel;
@property (weak, nonatomic) IBOutlet UITableView *houseGoodsTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *houseGoodsViewHeight;
/** 楼盘动态 */
@property (weak, nonatomic) IBOutlet UITableView *houseNewsTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *houseNewsTableViewHeight;
/** 产品户型图 */
@property (weak, nonatomic) IBOutlet UICollectionView *houseHUXiCollectionView;
/** 周边配套 */
@property (weak, nonatomic) IBOutlet UIView *mapSuperView;
@property (weak, nonatomic) IBOutlet UITableView *houseNearbyTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *houseNearbyViewHeight;
@property (nonatomic, strong) MAMapView *mapView;
@end

@implementation RCHouseDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"楼盘详情"];
    [self setUpCycleView];
    [self setUpCollectionView];
    [self setUpTableView];
    // 地图
    [self.mapSuperView addSubview:self.mapView];
    // 设置地图中心点
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(30.4865508426, 114.3347167969);
}
-(MAMapView *)mapView
{
    if (_mapView == nil) {
        _mapView = [[MAMapView alloc] initWithFrame:self.mapSuperView.bounds];
        _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _mapView.zoomLevel = 13;
        _mapView.delegate = self;
        MAPointAnnotation *a1 = [[MAPointAnnotation alloc] init];
        a1.coordinate = CLLocationCoordinate2DMake(30.4865508426, 114.3347167969);
        a1.title      = @"幸福里项目基地";
        [_mapView addAnnotation:a1];
    }
    return _mapView;
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    //[self.houseInfoView bezierPathByRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(6, 6)];
    
    [self.cycleView reloadData];
    
    [self.houseHotCollectionView reloadData];
    
    [self.houseInfoTableView reloadData];
    hx_weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.houseInfoTableViewHeight.constant = 10.f+44.f+weakSelf.houseInfoTableView.contentSize.height+64.f;
    });
    
    CGFloat textHeight = [@"规则说明:\n1.公寓单套佣金1000元，高层单套佣金2000元。\n2.拥金的最终解释权属于项目。" textHeightSize:CGSizeMake(HX_SCREEN_WIDTH-15*2, CGFLOAT_MAX) font:[UIFont fontWithName:@"PingFangSC-Medium" size: 14] lineSpacing:5.f];
    [self.houseRewardLabel setTextWithLineSpace:5.f withString:@"规则说明:\n1.公寓单套佣金1000元，高层单套佣金2000元。\n2.拥金的最终解释权属于项目。" withFont:[UIFont fontWithName:@"PingFangSC-Medium" size: 14]];
    self.recommendRewardViewHeight.constant = 10.f+44.f+textHeight+18.f;
    
    
    CGFloat textHeight1 = [@"项目秉承东方造园初衷，以中国东方美学为魂，以龙兴文脉基奠为师，匠心修为城市高端人居产品。在格局上，致力于打造移步易景、清韵优雅的山水归家画卷，依循东方园林的中轴布局，体现出开阔的视野。在建筑上，屋檐师法重檐，以简洁的建筑形体，深远的大屋面，虚实结合的立面效果，呈现大气而典雅的整体效果。在景观上，扎根东方美学，每处细节的点缀透露出匠心之精良，让山林丘木溪石湖等文化元素落位理想居住生活。" textHeightSize:CGSizeMake(HX_SCREEN_WIDTH-15*2, CGFLOAT_MAX) font:[UIFont fontWithName:@"PingFangSC-Medium" size: 14] lineSpacing:5.f];
    [self.houseGoodsLabel setTextWithLineSpace:5.f withString:@"项目秉承东方造园初衷，以中国东方美学为魂，以龙兴文脉基奠为师，匠心修为城市高端人居产品。在格局上，致力于打造移步易景、清韵优雅的山水归家画卷，依循东方园林的中轴布局，体现出开阔的视野。在建筑上，屋檐师法重檐，以简洁的建筑形体，深远的大屋面，虚实结合的立面效果，呈现大气而典雅的整体效果。在景观上，扎根东方美学，每处细节的点缀透露出匠心之精良，让山林丘木溪石湖等文化元素落位理想居住生活。" withFont:[UIFont fontWithName:@"PingFangSC-Medium" size: 14]];
    [self.houseGoodsTableView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.houseGoodsViewHeight.constant = 10.f+44.f+textHeight1+weakSelf.houseGoodsTableView.contentSize.height;
    });
    
    [self.houseNearbyTableView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.houseNearbyViewHeight.constant = 10.f+44.f+260.f+weakSelf.houseNearbyTableView.contentSize.height;
    });
    
    [self.houseNewsTableView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.houseNewsTableViewHeight.constant = 10.f+44.f+weakSelf.houseNewsTableView.contentSize.height+64.f;
    });
    
    self.mapView.frame = self.mapSuperView.bounds;
}

#pragma mark -- 视图配置
-(void)setUpCycleView
{
    self.cycleView.isInfiniteLoop = YES;
    self.cycleView.autoScrollInterval = 3.0;
    self.cycleView.dataSource = self;
    self.cycleView.delegate = self;
    // registerClass or registerNib
    [self.cycleView registerNib:[UINib nibWithNibName:NSStringFromClass([RCBannerCell class]) bundle:nil] forCellWithReuseIdentifier:@"BannerCell"];
    
    self.categoryView.layer.cornerRadius = 12.f;
    self.categoryView.layer.masksToBounds = YES;
    self.categoryView.titles = @[@"VR",@"视频",@"图片"];
    self.categoryView.titleFont = [UIFont systemFontOfSize:11];
    self.categoryView.cellSpacing = 0;
    self.categoryView.cellWidth = 150.f/3;
    self.categoryView.titleColor = UIColorFromRGB(0x333333);
    self.categoryView.titleSelectedColor = [UIColor whiteColor];
    self.categoryView.titleLabelMaskEnabled = YES;
    self.categoryView.delegate = self;
    
    JXCategoryIndicatorBackgroundView *backgroundView = [[JXCategoryIndicatorBackgroundView alloc] init];
    backgroundView.indicatorHeight = 24;
    backgroundView.indicatorWidthIncrement = 0;
    backgroundView.indicatorColor = HXControlBg;
    self.categoryView.indicators = @[backgroundView];
}
-(void)setUpCollectionView
{
    RCFlowLayout *flowLayout = [[RCFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(40.f, 40.f);
    flowLayout.offsetX = 10.f;
    self.houseHotCollectionView.collectionViewLayout = flowLayout;
    self.houseHotCollectionView.dataSource = self;
    self.houseHotCollectionView.delegate = self;
    self.houseHotCollectionView.backgroundColor = [UIColor whiteColor];
    
    [self.houseHotCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([RCHouseDetailHotCell class]) bundle:nil] forCellWithReuseIdentifier:HouseDetailHotCell];
    
    ZLCollectionViewHorzontalLayout *flowLayout2 = [[ZLCollectionViewHorzontalLayout alloc] init];
    flowLayout2.delegate = self;
    flowLayout2.canDrag = NO;
    self.houseHUXiCollectionView.collectionViewLayout = flowLayout2;
    self.houseHUXiCollectionView.dataSource = self;
    self.houseHUXiCollectionView.delegate = self;
    self.houseHUXiCollectionView.backgroundColor = [UIColor whiteColor];
    
    [self.houseHUXiCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([RCHouseStyleCell class]) bundle:nil] forCellWithReuseIdentifier:HouseStyleCell];
}
-(void)setUpTableView
{
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.houseInfoTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.houseInfoTableView.estimatedRowHeight = UITableViewAutomaticDimension;//预估高度
    self.houseInfoTableView.estimatedSectionHeaderHeight = 0;
    self.houseInfoTableView.estimatedSectionFooterHeight = 0;
    
    self.houseInfoTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.houseInfoTableView.dataSource = self;
    self.houseInfoTableView.delegate = self;
    
    self.houseInfoTableView.showsVerticalScrollIndicator = NO;
    
    self.houseInfoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.houseInfoTableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCHouseDetailInfoCell class]) bundle:nil] forCellReuseIdentifier:HouseDetailInfoCell];
    
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.houseGoodsTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.houseGoodsTableView.estimatedRowHeight = 0;//预估高度
    self.houseGoodsTableView.estimatedSectionHeaderHeight = 0;
    self.houseGoodsTableView.estimatedSectionFooterHeight = 0;
    
    self.houseGoodsTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.houseGoodsTableView.dataSource = self;
    self.houseGoodsTableView.delegate = self;
    
    self.houseGoodsTableView.showsVerticalScrollIndicator = NO;
    
    self.houseGoodsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.houseGoodsTableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCHouseGoodsCell class]) bundle:nil] forCellReuseIdentifier:HouseGoodsCell];
    
    
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.houseNearbyTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.houseNearbyTableView.estimatedRowHeight = 0;//预估高度
    self.houseNearbyTableView.estimatedSectionHeaderHeight = 0;
    self.houseNearbyTableView.estimatedSectionFooterHeight = 0;
    
    self.houseNearbyTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.houseNearbyTableView.dataSource = self;
    self.houseNearbyTableView.delegate = self;
    
    self.houseNearbyTableView.showsVerticalScrollIndicator = NO;
    
    self.houseNearbyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.houseNearbyTableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCHouseNearbyCell class]) bundle:nil] forCellReuseIdentifier:HouseNearbyCell];
    
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.houseNewsTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.houseNewsTableView.estimatedRowHeight = 0;//预估高度
    self.houseNewsTableView.estimatedSectionHeaderHeight = 0;
    self.houseNewsTableView.estimatedSectionFooterHeight = 0;
    
    self.houseNewsTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.houseNewsTableView.dataSource = self;
    self.houseNewsTableView.delegate = self;
    
    self.houseNewsTableView.showsVerticalScrollIndicator = NO;
    
    self.houseNewsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.houseNewsTableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCHouseDetailNewsCell class]) bundle:nil] forCellReuseIdentifier:HouseDetailNewsCell];
}
#pragma mark -- 点击事件
-(IBAction)shareClicked:(UIButton *)sender
{
    RCShareView *share = [RCShareView loadXibView];
    share.hxn_width = HX_SCREEN_WIDTH;
    share.hxn_height = 260.f;
    hx_weakify(self);
    share.shareTypeCall = ^(NSInteger type, NSInteger index) {
        if (type == 1) {
            if (index == 1) {
                HXLog(@"微信好友");
            }else if (index == 2) {
                HXLog(@"朋友圈");
            }else{
                HXLog(@"链接");
            }
        }else{
            [weakSelf.zh_popupController dismissWithDuration:0.25 springAnimated:NO];
        }
    };
    self.zh_popupController = [[zhPopupController alloc] init];
    self.zh_popupController.layoutType = zhPopupLayoutTypeBottom;
    [self.zh_popupController presentContentView:share duration:0.25 springAnimated:NO];
}
- (IBAction)houseCollectClicked:(SPButton *)sender {
    HXLog(@"收藏");
}
- (IBAction)openHouseClicked:(UIButton *)sender {
    HXLog(@"开盘通知");
}
- (IBAction)houseInfoClicked:(UIButton *)sender {
    RCHouseInfoVC *ivc = [RCHouseInfoVC new];
    [self.navigationController pushViewController:ivc animated:YES];
}
- (IBAction)houseNewsClicked:(UIButton *)sender {
    RCHouseNewsVC *nvc = [RCHouseNewsVC new];
    [self.navigationController pushViewController:nvc animated:YES];
}
- (IBAction)houseNearbyClicked:(UIButton *)sender {
    RCHouseNearbyVC *nvc = [RCHouseNearbyVC new];
    [self.navigationController pushViewController:nvc animated:YES];
}
- (IBAction)houseApointClicked:(UIButton *)sender {
    if (sender.tag == 1) {
        RCHouseAppointVC *avc = [RCHouseAppointVC new];
        [self.navigationController pushViewController:avc animated:YES];
    }else{
        hx_weakify(self);
        zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"提示" message:@"027-27549123" constantWidth:HX_SCREEN_WIDTH - 50*2];
        zhAlertButton *cancelButton = [zhAlertButton buttonWithTitle:@"取消" handler:^(zhAlertButton * _Nonnull button) {
            hx_strongify(weakSelf);
            [strongSelf.zh_popupController dismiss];
        }];
        zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"拨打" handler:^(zhAlertButton * _Nonnull button) {
            hx_strongify(weakSelf);
            [strongSelf.zh_popupController dismiss];
            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",@"13496755975"]]];
        }];
        cancelButton.lineColor = UIColorFromRGB(0xDDDDDD);
        [cancelButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        okButton.lineColor = UIColorFromRGB(0xDDDDDD);
        [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
        [alert adjoinWithLeftAction:cancelButton rightAction:okButton];
        self.zh_popupController = [[zhPopupController alloc] init];
        [self.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
    }
}
#pragma mark - Map Delegate
/*!
 @brief 根据anntation生成对应的View
 @param mapView 地图View
 @param annotation 指定的标注
 @return 生成的标注View
 */
- (MAAnnotationView*)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:pointReuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"mappin"];
        annotationView.canShowCallout               = YES;
        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
        //annotationView.centerOffset = CGPointMake(0, -18);
        return annotationView;
    }
    
    return nil;
}
#pragma mark -- JXCategoryView代理
/**
 点击选中的情况才会调用该方法
 
 @param categoryView categoryView对象
 @param index 选中的index
 */
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index
{
    [self.cycleView scrollToItemAtIndex:index animate:YES];
}
#pragma mark -- TYCyclePagerView代理
- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    return 5;
}
- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    RCBannerCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"BannerCell" forIndex:index];
    if (index == 0) {
        cell.bannerTagImg.hidden = NO;
        cell.bannerTagImg.image = HXGetImage(@"icon_vr");
    }else if (index == 1) {
        cell.bannerTagImg.hidden = NO;
        cell.bannerTagImg.image = HXGetImage(@"icon_video");
    }else{
        cell.bannerTagImg.hidden = YES;
    }
    return cell;
}
- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView {
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc]init];
    layout.itemSize = CGSizeMake(CGRectGetWidth(pageView.frame), CGRectGetHeight(pageView.frame));
    layout.itemSpacing = 0.f;
    layout.itemHorizontalCenter = YES;
    return layout;
}

- (void)pagerView:(TYCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    if (toIndex > 1) {
        self.cycleNum.hidden = NO;
        self.cycleNum.text = [NSString stringWithFormat:@"%zd/3",toIndex-1];
        [self.categoryView selectItemAtIndex:2];
    }else{
        self.cycleNum.hidden = YES;
        [self.categoryView selectItemAtIndex:toIndex];
    }
}

- (void)pagerView:(TYCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index
{
    if (index == 0) {
        RCPanoramaVC *pvc = [RCPanoramaVC new];
        HXNavigationController *nav = [[HXNavigationController alloc] initWithRootViewController:pvc];
        [self presentViewController:nav animated:YES completion:nil];
    }else if (index == 1) {
        RCVideoFullScreenVC *fvc = [RCVideoFullScreenVC new];
        [self.navigationController pushViewController:fvc animated:NO];
    }else{
        HXLog(@"点击图片");
    }
}
#pragma mark -- UICollectionView 数据源和代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 8;
}
- (ZLLayoutType)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section {
    return ColumnLayout;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout*)collectionViewLayout columnCountOfSection:(NSInteger)section
{
    if (collectionView == self.houseHotCollectionView) {
        return 6;
    }else{
        return 1;
    }
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.houseHotCollectionView) {
        RCHouseDetailHotCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:HouseDetailHotCell forIndexPath:indexPath];
        return cell;
    }else{
        RCHouseStyleCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:HouseStyleCell forIndexPath:indexPath];
        return cell;
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.houseHotCollectionView) {
        RCHouseHotVC *hvc = [RCHouseHotVC new];
        [self.navigationController pushViewController:hvc animated:YES];
    }else if (collectionView == self.houseHUXiCollectionView) {
        RCHouseStyleVC *svc = [RCHouseStyleVC new];
        [self.navigationController pushViewController:svc animated:YES];
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.houseHotCollectionView) {
        return CGSizeMake(42.f,42.f);
    }else{
        return CGSizeMake(150.f,collectionView.hxn_height-15.f*2);
    }
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 15.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return collectionView == self.houseHotCollectionView ? 0.f:15.f;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return collectionView == self.houseHotCollectionView ?UIEdgeInsetsMake(10, 15, 10, 15):UIEdgeInsetsMake(15, 15, 15, 15);
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.houseInfoTableView) {
        return 7;
    }else if (tableView == self.houseNewsTableView) {
        return 2;
    }else if (tableView == self.houseGoodsTableView) {
        return 4;
    }else{
        return 5;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.houseInfoTableView) {
        RCHouseDetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseDetailInfoCell forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.locationBtn.hidden = indexPath.row;
        return cell;
    }else if (tableView == self.houseNewsTableView) {
        RCHouseDetailNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseDetailNewsCell forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (tableView == self.houseGoodsTableView) {
        RCHouseGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseGoodsCell forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        RCHouseNearbyCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseNearbyCell forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.houseInfoTableView) {
        return UITableViewAutomaticDimension;
    }else if (tableView == self.houseNewsTableView) {
        return 120.f;
    }else if (tableView == self.houseGoodsTableView) {
        return 36.f;
    }else{
        return 44.f;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.houseNewsTableView) {
        RCNewsDetailVC *dvc = [RCNewsDetailVC new];
        [self.navigationController pushViewController:dvc animated:YES];
    }
}
@end
