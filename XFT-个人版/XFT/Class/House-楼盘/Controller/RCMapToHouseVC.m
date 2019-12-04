//
//  RCMapToHouseVC.m
//  XFT
//
//  Created by 夏增明 on 2019/8/30.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCMapToHouseVC.h"
#import "RCCustomAnnotationView.h"
#import <zhPopupController.h>
#import "RCCityToHouseView.h"
#import <IQKeyboardManager.h>
#import "RCCustomAnnotation.h"
#import "RCMapToHouseView.h"
#import <QMapKit/QMapKit.h>
#import "RCOpenArea.h"
#import "RCMapHouse.h"
#import "RCHouseDetail.h"
#import "RCNearbyPOI.h"
#import "RCHouseDetailVC.h"

@interface RCMapToHouseVC ()<QMapViewDelegate,RCMapToHouseViewDelegate,RCCityToHouseViewDelegate>
/** 地图 */
@property (nonatomic, strong) QMapView *mapView;
/* 导航栏 */
@property(nonatomic,strong) UIView *navBarView;
/* 定位城市 */
@property(nonatomic,strong) UIButton *loacationBtn;
/** 城市 */
@property (nonatomic,strong) NSArray *citys;
/* 选择城市视图 */
@property(nonatomic,strong) RCCityToHouseView *cityView;
/* 城市id */
@property(nonatomic,copy) NSString *cityId;
/* 楼盘 */
@property(nonatomic,strong) NSArray *houses;
/* 当前展示楼盘点 */
@property(nonatomic,strong) RCCustomAnnotation *currentPoint;
/** 楼盘全部详情数据 */
@property(nonatomic,strong) RCHouseDetail *houseDetail;
/** 正在展示的周边类型 1.交通 2.教育 3.医疗 4.商业 */
@property(nonatomic,assign) NSInteger lastNearbyType;
/** 周边交通 */
@property(nonatomic,strong) NSArray *nearbyBus;
/** 周边教育 */
@property(nonatomic,strong) NSArray *nearbyEducation;
/** 周边医疗 */
@property(nonatomic,strong) NSArray *nearbyMedical;
/** 周边商业 */
@property(nonatomic,strong) NSArray *nearbyBusiness;
/* 当前选择的周边打点 */
@property(nonatomic,strong) QPointAnnotation *nearbyPoint;
@end

@implementation RCMapToHouseVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
//    [[IQKeyboardManager sharedManager] setEnable:NO];
//    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
//    [[IQKeyboardManager sharedManager] setEnable:YES];
//    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"地图找房"];
    // 地图
    [self.view addSubview:self.mapView];
    
    [self.view addSubview:self.navBarView];
    
    [self.view addSubview:self.loacationBtn];
    
    [self getAllHouseRequest];//获取当前城市所有的楼盘信息
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.mapView.frame = self.view.bounds;
    
    self.navBarView.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, self.HXNavBarHeight);
}
#pragma mark - 懒加载
-(UIButton *)loacationBtn
{
    if (_loacationBtn == nil) {
        _loacationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loacationBtn setBackgroundColor:UIColorFromRGB(0xF33C51)];
        _loacationBtn.layer.cornerRadius = 6.f;
        _loacationBtn.layer.masksToBounds = YES;
        _loacationBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_loacationBtn setImage:HXGetImage(@"btn_place") forState:UIControlStateNormal];
        [_loacationBtn addTarget:self action:@selector(locationClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_loacationBtn setTitle:self.cityName forState:UIControlStateNormal];
        _loacationBtn.frame = CGRectMake(15.f, self.HXNavBarHeight + 15.f, 100.f, 35.f);
    }
    return _loacationBtn;
}
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
-(QMapView *)mapView
{
    if (_mapView == nil) {
        _mapView = [[QMapView alloc] initWithFrame:self.view.bounds];
        _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _mapView.zoomLevel = 10;
        _mapView.showsCompass = YES;
        _mapView.delegate = self;
        //        [_mapView setShowsUserLocation:YES];
        //        _mapView.userTrackingMode = QUserTrackingModeFollow;
    }
    return _mapView;
}
-(RCCityToHouseView *)cityView
{
    if (_cityView == nil) {
        _cityView = [RCCityToHouseView loadXibView];
        _cityView.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, HX_SCREEN_HEIGHT - 160);
        _cityView.delegate = self;
    }
    return _cityView;
}
-(void)setCityId:(NSString *)cityId
{
    if (![_cityId isEqualToString:cityId]) {
        _cityId = cityId;
        [self getAllHouseRequest];
    }
}
#pragma mark -- 点击事件
-(void)backClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)locationClicked:(UIButton *)sender
{
    if (self.citys && self.citys.count) {
        [self showCityView];
    }else{
        hx_weakify(self);
        [self getAllCitysRequestWithCityName:@"" completeCall:^{
            hx_strongify(weakSelf);
            [strongSelf showCityView];
        }];
    }
}
#pragma mark -- 接口请求
/** 查询楼盘信息 */
-(void)getAllHouseRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"geoCityName"] = self.cityName;
    data[@"geoCityUuid"] = (self.cityId && self.cityId.length)?self.cityId:[[NSUserDefaults standardUserDefaults] objectForKey:HXCityCode];//城市id
    data[@"proType"] = @"";//项目类型,1:住宅 2:商办
    parameters[@"data"] = data;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"pro/pro/map/proListNew" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if ([responseObject[@"code"] integerValue] == 0) {
            strongSelf.houses = [NSArray yy_modelArrayWithClass:[RCMapHouse class] json:responseObject[@"data"]];
            // 打标记点
            NSMutableArray *tempArr = [NSMutableArray array];
            for (int i = 0; i < strongSelf.houses.count;i++) {
                RCMapHouse *house = strongSelf.houses[i];
                RCCustomAnnotation *a1 = [[RCCustomAnnotation alloc] init];
                a1.coordinate = CLLocationCoordinate2DMake(house.dimension, house.longitude);
                a1.title      = house.name;
                a1.subtitle = house.price;
                a1.otherMsg = house.areaInterval;
                a1.contentId = [NSString stringWithFormat:@"%@",house.uuid];
                [tempArr addObject:a1];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.mapView setZoomLevel:10 animated:YES];
                [strongSelf.mapView addAnnotations:tempArr];// 打标记
                if (tempArr.count) {
                    RCMapHouse *cerHouse = strongSelf.houses.firstObject;
                    [strongSelf.mapView setCenterCoordinate:CLLocationCoordinate2DMake(cerHouse.dimension, cerHouse.longitude) animated:YES];
                }
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
/** 查询所有城市信息 */
-(void)getAllCitysRequestWithCityName:(NSString *)cityName completeCall:(void(^)(void))completeCall
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"cityName"] = cityName;
    //data[@"geoCityUuid"] = [[NSUserDefaults standardUserDefaults] objectForKey:HXCityCode];//城市id
    data[@"proType"] = @"";//项目类型,1:住宅 2:商办
    parameters[@"data"] = data;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"sys/sys/city/queryCityList" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if ([responseObject[@"code"] integerValue] == 0) {
            strongSelf.citys = [NSArray yy_modelArrayWithClass:[RCOpenArea class] json:responseObject[@"data"]];
            if (completeCall) {
                completeCall();
            }
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
#pragma mark -- 楼盘信息接口
-(void)getHouseDetailRequest
{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    // 执行循序0
    hx_weakify(self);
    // 执行循序1
    dispatch_group_async(group, queue, ^{
        hx_strongify(weakSelf);
        // 楼盘详情
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        NSMutableDictionary *data = [NSMutableDictionary dictionary];
        data[@"uuid"] = self.currentPoint.contentId;
        parameters[@"data"] = data;

        [HXNetworkTool POST:HXRC_M_URL action:@"pro/pro/proBaseInfo/proInfo" parameters:parameters success:^(id responseObject) {
            if ([responseObject[@"code"] integerValue] == 0) {
                strongSelf.houseDetail = [RCHouseDetail yy_modelWithDictionary:responseObject[@"data"]];
            }else{
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
            }
            dispatch_semaphore_signal(semaphore);
        } failure:^(NSError *error) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
            dispatch_semaphore_signal(semaphore);
        }];
    });
    // 执行循序1
    dispatch_group_async(group, queue, ^{
        hx_strongify(weakSelf);
        strongSelf.lastNearbyType = 1;// 只要调起这个接口，就是改变了展示楼盘，重新赋值为1
        // 楼盘详情
        [strongSelf getNearbyDataRequestCompleteCall:^{
            dispatch_semaphore_signal(semaphore);
        }];
    });
    
    dispatch_group_notify(group, queue, ^{
        hx_strongify(weakSelf);
        // 执行循序4
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        // 执行顺序6
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        // 执行顺序10
        dispatch_async(dispatch_get_main_queue(), ^{
            // 刷新界面
//            [strongSelf stopShimmer];
//            [strongSelf handleHouseDetailData];
            [strongSelf showHouseInfoView];
        });
    });
}
/** 获取项目周边配套缓存 */
-(void)getNearbyDataRequestCompleteCall:(void(^)(void))completeCall
{
    // 楼盘周边
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"type"] = @(self.lastNearbyType);//类型 1.交通 2.教育 3.医疗 4.商业
    data[@"uuid"] = self.currentPoint.contentId;
    parameters[@"data"] = data;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"pro/pro/map/getProductPeripheralMatchingRel" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if ([responseObject[@"code"] integerValue] == 0) {
            if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {//有存储的数据返回
                NSArray *resultArr = [NSArray yy_modelArrayWithClass:[RCNearbyPOI class] json:responseObject[@"data"][@"josnStr"]];
                if (strongSelf.lastNearbyType == 1) {
                    strongSelf.nearbyBus = resultArr;
                }else if (strongSelf.lastNearbyType == 2) {
                    strongSelf.nearbyEducation = resultArr;
                }else if (strongSelf.lastNearbyType == 3) {
                    strongSelf.nearbyMedical = resultArr;
                }else{
                    strongSelf.nearbyBusiness = resultArr;
                }
                if (completeCall) {
                    completeCall();
                }
            }else{// 没有存储的数据返回
                [strongSelf getNearbyDataRequestFromQServerCompleteCall:^{
                    if (completeCall) {
                        completeCall();
                    }
                }];
            }
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
            if (completeCall) {
                completeCall();
            }
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
        if (completeCall) {
            completeCall();
        }
    }];
}
/** 未取到周边数据缓存时向腾讯服务器请求并存入服务器 */
-(void)getNearbyDataRequestFromQServerCompleteCall:(void(^)(void))completeCall
{
    // 楼盘周边
    hx_weakify(self);
    NSString *keyword = nil;
    if (self.lastNearbyType == 1) {
        keyword = @"交通";
    }else if (self.lastNearbyType == 2) {
        keyword = @"教育";
    }else if (self.lastNearbyType == 3) {
        keyword = @"医疗";
    }else{
        keyword = @"商业";
    }
    [HXNetworkTool GET:@"https://apis.map.qq.com/ws/place/v1/search" action:nil parameters:@{@"boundary":[NSString stringWithFormat:@"nearby(%@,%@,1000)",@(self.currentPoint.coordinate.latitude),@(self.currentPoint.coordinate.longitude)],@"keyword":keyword,@"orderby":@"_distance",@"key":HXQMapKey} success:^(id responseObject) {
        hx_strongify(weakSelf);
        if ([responseObject[@"status"] integerValue] == 0) {
            NSArray *resultArr = [NSArray yy_modelArrayWithClass:[RCNearbyPOI class] json:responseObject[@"data"]];
            if (strongSelf.lastNearbyType == 1) {
                strongSelf.nearbyBus = resultArr;
            }else if (strongSelf.lastNearbyType == 2) {
                strongSelf.nearbyEducation = resultArr;
            }else if (strongSelf.lastNearbyType == 3) {
                strongSelf.nearbyMedical = resultArr;
            }else{
                strongSelf.nearbyBusiness = resultArr;
            }
            [strongSelf saveNearbyDataRequest:resultArr];//将数据存入服务器，下次直接从服务器获取
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
        if (completeCall) {
            completeCall();
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
        if (completeCall) {
            completeCall();
        }
    }];
}
/** 储存项目周边配套缓存 */
-(void)saveNearbyDataRequest:(NSArray *)resultArr
{
    // 楼盘周边
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"type"] = @(self.lastNearbyType);//类型 1.交通 2.教育 3.医疗 4.商业
    data[@"jsonStr"] = [resultArr yy_modelToJSONString];
    data[@"uuid"] = self.currentPoint.contentId;
    parameters[@"data"] = data;
    
    [HXNetworkTool POST:HXRC_M_URL action:@"pro/pro/map/saveProductPeripheralMatchingRel" parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            // 周边数据上传存入成功
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
#pragma mark -- 展示楼盘信息
-(void)showHouseInfoView
{
    RCMapToHouseView *hvc = [RCMapToHouseView loadXibView];
    hvc.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, HX_SCREEN_HEIGHT*3/5);
    hvc.houseDetail = self.houseDetail;
    hvc.nearbyBus = self.nearbyBus;
    hvc.delegate = self;

    self.zh_popupController = [[zhPopupController alloc] init];
    self.zh_popupController.maskAlpha = 0.f;
    self.zh_popupController.layoutType = zhPopupLayoutTypeBottom;
    [self.zh_popupController presentContentView:hvc duration:0.25 springAnimated:NO];
}
-(void)nearbyHouseDidClicked:(RCMapToHouseView *)view
{
    RCHouseDetailVC *dvc = [RCHouseDetailVC new];
    dvc.uuid = self.currentPoint.contentId;
    [self.navigationController pushViewController:dvc animated:YES];
}
-(void)nearbyType:(RCMapToHouseView *)view didClicked:(NSInteger)index
{
    self.lastNearbyType = index;
    hx_weakify(self);
    if (self.lastNearbyType == 1) {
        [self getNearbyDataRequestCompleteCall:^{
            view.nearbyBus = weakSelf.nearbyBus;
        }];
    }else if (self.lastNearbyType == 2) {
        [self getNearbyDataRequestCompleteCall:^{
            view.nearbyEducation = weakSelf.nearbyEducation;
        }];
    }else if (self.lastNearbyType == 3) {
        [self getNearbyDataRequestCompleteCall:^{
            view.nearbyMedical = weakSelf.nearbyMedical;
        }];
    }else{
        [self getNearbyDataRequestCompleteCall:^{
            view.nearbyBusiness = weakSelf.nearbyBusiness;
        }];
    }
}
- (void)nearbyView:(RCMapToHouseView *)view nearbyType:(NSInteger)type didClickedPOI:(RCNearbyPOI *)poi
{
    // 选中打点代码
    if (!self.nearbyPoint) {
        self.nearbyPoint = [[QPointAnnotation alloc] init];
    }else{
        [self.mapView removeAnnotation:self.nearbyPoint];
    }
    
    self.nearbyPoint.coordinate = CLLocationCoordinate2DMake(poi.location.lat, poi.location.lng);
    self.nearbyPoint.title      = poi.title;
    [self.mapView addAnnotation:self.nearbyPoint];
    [self.mapView setCenterCoordinate:self.nearbyPoint.coordinate animated:YES];
}
#pragma mark -- 展示城市视图
-(void)showCityView
{
    self.cityView.citys = self.citys;
    
    self.zh_popupController = [[zhPopupController alloc] init];
    self.zh_popupController.offsetSpacingOfKeyboard = -270.f;//这里应该是键盘的高度，在这里只给一个大概值
    self.zh_popupController.maskAlpha = 0.f;
    self.zh_popupController.layoutType = zhPopupLayoutTypeBottom;
    [self.zh_popupController presentContentView:self.cityView duration:0.25 springAnimated:NO];
}
-(void)cityView:(RCCityToHouseView *)view didClickedCity:(RCOpenCity *)city
{
    self.cityName = city.cname;
    self.cityId = city.cid;
    [self.loacationBtn setTitle:city.cname forState:UIControlStateNormal];
    
    [self.zh_popupController dismissWithDuration:0.25 springAnimated:NO];
}
-(void)cityView:(RCCityToHouseView *)view didSearchReturn:(NSString *)keyword {
    
//    [self.zh_popupController dismissWithDuration:0.25 springAnimated:NO];

    hx_weakify(self);
    [self getAllCitysRequestWithCityName:keyword completeCall:^{
        view.citys = weakSelf.citys;
    }];
}
#pragma mark -- AMap Delegate
/**
 * @brief 根据anntation生成对应的View
 * @param mapView 地图View
 * @param annotation 指定的标注
 * @return 生成的标注View
 */
- (QAnnotationView *)mapView:(QMapView *)mapView viewForAnnotation:(id <QAnnotation>)annotation;
{
    if ([annotation isKindOfClass:[QUserLocation class]]) {
        return nil;
    }
    
    if ([annotation isKindOfClass:[RCCustomAnnotation class]]) {
        static NSString *customReuseIndetifier = @"customReuseIndetifier";
        RCCustomAnnotationView *annotationView = (RCCustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
        if (annotationView == nil){
            annotationView = [[RCCustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier];
        }
        [annotationView setEnabled:NO];
        [annotationView setSelected:YES animated:NO];
        hx_weakify(self);
        annotationView.callOutViewClicked = ^{
            weakSelf.currentPoint = annotation;
            [mapView setCenterOffset:CGPointMake(0.5, 0.35)];
            [mapView setZoomLevel:15 animated:YES];
            [mapView setCenterCoordinate:annotation.coordinate animated:YES];
            [weakSelf getHouseDetailRequest];
        };
        annotationView.image = [UIImage imageNamed:@"icon_loupan"];
        annotationView.canShowCallout               = NO;
        annotationView.annotation = annotation;
        
        return annotationView;
    }else if ([annotation isKindOfClass:[QPointAnnotation class]]) {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        QAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil) {
            annotationView = [[QAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        // 可拖拽.
        annotationView.draggable = NO;
        //显示气泡
        [annotationView setCanShowCallout:YES];
        //设置图标
        if (self.lastNearbyType == 1) {
            annotationView.image = [UIImage imageNamed:@"icon_bus_click"];
        }else if (self.lastNearbyType == 2){
            annotationView.image = [UIImage imageNamed:@"icon_education_click"];
        }else if (self.lastNearbyType == 3){
            annotationView.image = [UIImage imageNamed:@"icon_medical_click"];
        }else{
            annotationView.image = [UIImage imageNamed:@"icon_business_click"];
        }
        
        return annotationView;
    }
    
    return nil;
}
/**
 * @brief  当选中一个annotation view时，调用此接口
 * @param mapView 地图View
 * @param view 选中的annotation view
 */
- (void)mapView:(QMapView *)mapView didSelectAnnotationView:(QAnnotationView *)view
{
    if ([view.annotation isKindOfClass:[RCCustomAnnotation class]]) {
        view.image = [UIImage imageNamed:@"icon_loupan"];
        RCCustomAnnotation *annotation = (RCCustomAnnotation *)view.annotation;
        HXLog(@"选中的楼盘事件id-%@",annotation.contentId);
    }else{
        HXLog(@"附件周边点击");
    }
}

/**
 * @brief  当取消选中一个annotation view时，调用此接口
 * @param mapView 地图View
 * @param view 取消选中的annotation view
 */
- (void)mapView:(QMapView *)mapView didDeselectAnnotationView:(QAnnotationView *)view
{
    if ([view.annotation isKindOfClass:[RCCustomAnnotation class]]) {
        view.image = [UIImage imageNamed:@"icon_loupan"];
    }
}

@end
