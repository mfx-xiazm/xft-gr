//
//  RCMapToHouseVC.m
//  XFT
//
//  Created by 夏增明 on 2019/8/30.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCMapToHouseVC.h"
#import <MAMapKit/MAMapKit.h>
#import "RCCustomAnnotationView.h"
#import <zhPopupController.h>
#import "RCCityToHouseView.h"
#import <IQKeyboardManager.h>
#import "RCCustomAnnotation.h"
#import "RCMapToHouseView.h"

@interface RCMapToHouseVC ()<MAMapViewDelegate>
/** 地图 */
@property (nonatomic, strong) MAMapView *mapView;
/* 导航栏 */
@property(nonatomic,strong) UIView *navBarView;
/* 定位城市 */
@property(nonatomic,strong) UIButton *loacationBtn;
@end

@implementation RCMapToHouseVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"地图找房"];
    // 地图
    [self.view addSubview:self.mapView];
    
    [self.view addSubview:self.navBarView];
    
    [self.view addSubview:self.loacationBtn];
    // 打标记点
    NSMutableArray *tempArr = [NSMutableArray array];
    CLLocationCoordinate2D coordinates[6] = {
        {30.4865508426, 114.3347167969},
        {30.4855508426, 114.3347167969},
        {30.4865508426, 114.3327167969},
        {30.4845508426, 114.3337167969},
        {30.4845508426, 114.3317167969},
        {30.4837508426, 114.3289167969}};
    
    for (int i = 0; i < 6; ++i) {
        RCCustomAnnotation *a1 = [[RCCustomAnnotation alloc] init];
        a1.coordinate = coordinates[i];
        a1.title      = [NSString stringWithFormat:@"武汉融公馆%d", i];
        a1.subtitle = @"12000/平";
        a1.otherMsg = @"58-142m";
        a1.contentId = [NSString stringWithFormat:@"%d",i];
        [tempArr addObject:a1];
    }
    [self.mapView addAnnotations:tempArr];// 打标记
    [self.mapView showAnnotations:tempArr animated:YES];//自动设置地图以显示标记点
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.mapView.frame = self.view.bounds;
    
    self.navBarView.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, self.HXNavBarHeight);
    
    [self.loacationBtn setTitle:@"武汉" forState:UIControlStateNormal];
    [self.loacationBtn sizeToFit];
    self.loacationBtn.frame = CGRectMake(15.f, self.HXNavBarHeight + 15.f, self.loacationBtn.hxn_width+20.f, 35.f);
}
-(UIButton *)loacationBtn
{
    if (_loacationBtn == nil) {
        _loacationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loacationBtn setBackgroundColor:HXControlBg];
        _loacationBtn.layer.cornerRadius = 6.f;
        _loacationBtn.layer.masksToBounds = YES;
        _loacationBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_loacationBtn setImage:HXGetImage(@"btn_place") forState:UIControlStateNormal];
        [_loacationBtn addTarget:self action:@selector(locationClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loacationBtn;
}
#pragma mark - 懒加载
-(UIView *)navBarView
{
    if (_navBarView == nil) {
        _navBarView = [UIView new];
        _navBarView.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, self.HXNavBarHeight);
        _navBarView.backgroundColor = [UIColor whiteColor];
        UILabel *title = [UILabel new];
        title.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
        title.textColor = UIColorFromRGB(0x333333);
        title.textAlignment = NSTextAlignmentCenter;
        title.frame = CGRectMake(0, self.HXStatusHeight, HX_SCREEN_WIDTH, 44);
        title.text = @"地图找房";
        [_navBarView addSubview:title];
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(0, self.HXStatusHeight, 44, 44);
        [backBtn setImage:HXGetImage(@"返回") forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backClicked) forControlEvents:UIControlEventTouchUpInside];
        [_navBarView addSubview:backBtn];
    }
    return _navBarView;
}
-(MAMapView *)mapView
{
    if (_mapView == nil) {
        _mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
        _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _mapView.zoomLevel = 13;
        _mapView.delegate = self;
        //_mapView.showsUserLocation = YES;
        //_mapView.userTrackingMode = MAUserTrackingModeFollow;
    }
    return _mapView;
}
#pragma mark -- 点击事件
-(void)backClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)locationClicked:(UIButton *)sender
{
    RCCityToHouseView *hvc = [RCCityToHouseView loadXibView];
    hvc.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, HX_SCREEN_HEIGHT - 160);
    hx_weakify(self);
    hvc.didSelectCityCall = ^{
        [weakSelf.zh_popupController dismissWithDuration:0.25 springAnimated:NO];
    };
    self.zh_popupController = [[zhPopupController alloc] init];
    self.zh_popupController.offsetSpacingOfKeyboard = -270.f;//这里应该是键盘的高度，在这里只给一个大概值
    self.zh_popupController.maskAlpha = 0.f;
    self.zh_popupController.layoutType = zhPopupLayoutTypeBottom;
    [self.zh_popupController presentContentView:hvc duration:0.25 springAnimated:NO];
}
-(void)showHouseInfoView
{
    RCMapToHouseView *hvc = [RCMapToHouseView loadXibView];
    hvc.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, HX_SCREEN_HEIGHT*3/5);
    
    self.zh_popupController = [[zhPopupController alloc] init];
    self.zh_popupController.maskAlpha = 0.f;
    self.zh_popupController.layoutType = zhPopupLayoutTypeBottom;
    [self.zh_popupController presentContentView:hvc duration:0.25 springAnimated:NO];
    
    // 选中打点代码
    //    MAPointAnnotation *a1 = [[MAPointAnnotation alloc] init];
    //    a1.coordinate = CLLocationCoordinate2DMake(30.4839508426, 114.3299167969);
    //    a1.title      = @"公交站";
    //    [self.mapView addAnnotation:a1];
}
#pragma mark -- AMap Delegate
/*!
 @brief 根据anntation生成对应的View
 @param mapView 地图View
 @param annotation 指定的标注
 @return 生成的标注View
 */
- (MAAnnotationView*)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[MAUserLocation class]]) {
        return nil;
    }
    
    if ([annotation isKindOfClass:[RCCustomAnnotation class]]) {
        static NSString *customReuseIndetifier = @"customReuseIndetifier";
        RCCustomAnnotationView *annotationView = (RCCustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
        if (annotationView == nil){
            annotationView = [[RCCustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier];
        }
        hx_weakify(self);
        annotationView.callOutViewClicked = ^{
            [weakSelf showHouseInfoView];
        };
        annotationView.image = [UIImage imageNamed:@"icon_loupan"];
        annotationView.canShowCallout               = NO;
        annotationView.annotation = annotation;
        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
        //annotationView.centerOffset = CGPointMake(0, -18);
        return annotationView;
    }else if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil){
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"icon_place"];
        annotationView.canShowCallout               = YES;
        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
        //annotationView.centerOffset = CGPointMake(0, -18);
        return annotationView;
    }
    
    return nil;
}
/*!
 @brief 当选中一个annotation views时调用此接口
 @param mapView 地图View
 @param view 选中的annotation views
 */
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view {
    if ([view.annotation isKindOfClass:[RCCustomAnnotation class]]) {
        view.image = [UIImage imageNamed:@"icon_loupan_click"];
        RCCustomAnnotation *annotation = (RCCustomAnnotation *)view.annotation;
        HXLog(@"选中的楼盘事件id-%@",annotation.contentId);
    }else{
        HXLog(@"附件周边点击");
    }
}

/*!
 @brief 当取消选中一个annotation views时调用此接口
 @param mapView 地图View
 @param view 取消选中的annotation views
 */
- (void)mapView:(MAMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view {
    if ([view.annotation isKindOfClass:[RCCustomAnnotation class]]) {
        view.image = [UIImage imageNamed:@"icon_loupan"];
    }
}

@end
