//
//  RCHouseVC.m
//  XFT
//
//  Created by 夏增明 on 2019/8/26.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCHouseVC.h"
#import "RCHouseHeader.h"
#import "RCSearchHouseVC.h"
#import "RCSearchCityVC.h"
#import "RCNoticeVC.h"
#import "RCMapToHouseVC.h"
#import "RCPageMainTable.h"
#import "RCHouseChildVC.h"
#import "RCHouseCategoryView.h"

@interface RCHouseVC ()<UITableViewDelegate,UITableViewDataSource>
/** tableView */
@property (weak, nonatomic) IBOutlet RCPageMainTable *tableView;
/* 头视图 */
@property(nonatomic,strong) RCHouseHeader *header;
/* 筛选 */
@property(nonatomic,strong) RCHouseCategoryView *categoryView;
/** 子控制器承载scr */
@property (nonatomic,strong) UIScrollView *scrollView;
/** 子控制器数组 */
@property (nonatomic,strong) NSArray *childVCs;
/** 是否可以滑动 */
@property(nonatomic,assign)BOOL isCanScroll;
@end

@implementation RCHouseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"幸福通"];
    self.isCanScroll = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MainTableScroll:) name:@"MainTableScroll" object:nil];
    [self setUpNavBar];
    [self setUpTableView];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.header.frame = CGRectMake(0, -(10.f+170.f+50.f), HX_SCREEN_WIDTH, 10.f+170.f+50.f);
    self.categoryView.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 60.f);
}
-(RCHouseHeader *)header
{
    if (_header == nil) {
        _header = [RCHouseHeader loadXibView];
        _header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 10.f+170.f+50.f);
        hx_weakify(self);
        _header.houseHeaderBtnClicked = ^(NSInteger type, NSInteger index) {
            if (type == 0) {
                RCNoticeVC *nvc = [RCNoticeVC new];
                [weakSelf.navigationController pushViewController:nvc animated:YES];
            }else{
                
            }
        };
    }
    return _header;
}
-(RCHouseCategoryView *)categoryView
{
    if (_categoryView == nil) {
        _categoryView = [RCHouseCategoryView loadXibView];
        _categoryView.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 60.f);
        _categoryView.scrollView = self.scrollView;
        _categoryView.childVCs = self.childVCs;
        hx_weakify(self);
        _categoryView.mapToHouseCall = ^{
            RCMapToHouseVC *hvc = [RCMapToHouseVC new];
            [weakSelf.navigationController pushViewController:hvc animated:YES];
        };
    }
    return _categoryView;
}
-(NSArray *)childVCs
{
    if (_childVCs == nil) {
        NSMutableArray *vcs = [NSMutableArray array];
        for (int i=0;i<2;i++) {
            RCHouseChildVC *cvc0 = [RCHouseChildVC new];
            cvc0.mainTable = self.tableView;
            [self addChildViewController:cvc0];
            [vcs addObject:cvc0];
        }
        _childVCs = vcs;
    }
    return _childVCs;
}
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(0, 60.f, HX_SCREEN_WIDTH, HX_SCREEN_HEIGHT-self.HXNavBarHeight-self.HXTabBarHeight - 60.f);
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(HX_SCREEN_WIDTH*self.childVCs.count, 0);
        // 加第一个视图
        UIViewController *targetViewController = self.childVCs.firstObject;
        targetViewController.view.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, _scrollView.hxn_height);
        [_scrollView addSubview:targetViewController.view];
    }
    return  _scrollView;
}
#pragma mark -- 视图相关
-(void)setUpNavBar
{
    SPButton *item = [[SPButton alloc] initWithImagePosition:SPButtonImagePositionLeft];
    item.hxn_size = CGSizeMake(70, 30);
    item.imageTitleSpace = 5.f;
    item.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    [item setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [item setImage:HXGetImage(@"搜索") forState:UIControlStateNormal];
    [item setTitle:@"武汉" forState:UIControlStateNormal];
    [item addTarget:self action:@selector(cityClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:item];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(searchClicked) nomalImage:HXGetImage(@"搜索") higeLightedImage:HXGetImage(@"搜索") imageEdgeInsets:UIEdgeInsetsZero];
}
/**
 初始化tableView
 */
-(void)setUpTableView
{
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.estimatedRowHeight = 0;//预估高度
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.contentInset = UIEdgeInsetsMake(10.f+170.f+50.f,0, 0, 0);

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 设置背景色为clear
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.tableView.tableFooterView = [UIView new];
    //    hx_weakify(self);
    //    __weak __typeof(BBPageMainTable *) weakTable = _mainTable;
    //    _mainTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    //        hx_strongify(weakSelf);
    //        BBExcellentShopChildVC *cv = strongSelf.childVCs[strongSelf.pageMenu.selectedItemIndex];
    //        [cv refreshData:weakTable];
    //    }];
    //    _mainTable.mj_header.ignoredScrollViewContentInsetTop = (self.type != 2)?(HX_SCREEN_WIDTH*2/5.0 + (HX_SCREEN_WIDTH*4/5.0)*2 +10):(HX_SCREEN_WIDTH*2/5.0 + 10);
    //    _mainTable.mj_header.automaticallyChangeAlpha = YES;
    
    [self.tableView addSubview:self.header];
}
#pragma mark -- 主视图滑动通知处理
-(void)MainTableScroll:(NSNotification *)user{
    self.isCanScroll = YES;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.tableView) {
        CGFloat tabOffsetY = [self.tableView rectForSection:0].origin.y;
        CGFloat offsetY = scrollView.contentOffset.y;
        if (offsetY>=tabOffsetY) {
            self.isCanScroll = NO;
            scrollView.contentOffset = CGPointMake(0, 0);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"childScrollCan" object:nil];
        }else{
            if (!self.isCanScroll) {
                [scrollView setContentOffset:CGPointZero];
            }
        }
    }
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark -- 点击事件
-(void)cityClicked
{
    RCSearchCityVC *hvc = [RCSearchCityVC new];
    [self.navigationController pushViewController:hvc animated:YES];
}
-(void)searchClicked
{
    RCSearchHouseVC *hvc = [RCSearchHouseVC new];
    [self.navigationController pushViewController:hvc animated:YES];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return self.view.hxn_height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // 添加pageView
    [cell.contentView addSubview:self.scrollView];
    [cell.contentView addSubview:self.categoryView];
    
    return cell;
}

@end
