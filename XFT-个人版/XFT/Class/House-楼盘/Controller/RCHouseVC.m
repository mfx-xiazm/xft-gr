//
//  RCHouseVC.m
//  XFT
//
//  Created by 夏增明 on 2019/8/26.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCHouseVC.h"
#import "RCHouseCell.h"
#import "RCHouseFilterView.h"
#import "RCHouseHeader.h"
#import "RCSearchHouseVC.h"
#import "RCSearchCityVC.h"
#import "RCNoticeVC.h"
#import "RCHouseDetailVC.h"
#import "RCMapToHouseVC.h"

static NSString *const HouseCell = @"HouseCell";
@interface RCHouseVC ()<UITableViewDelegate,UITableViewDataSource>
/** tableView */
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 头视图 */
@property(nonatomic,strong) RCHouseHeader *header;
/* 筛选 */
@property(nonatomic,strong) RCHouseFilterView *filterView;
@end

@implementation RCHouseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"幸福通"];
    [self setUpNavBar];
    [self setUpTableView];
    [self setUpTableHeaderView];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 10.f+170.f+50.f);
}
-(RCHouseHeader *)header
{
    if (_header == nil) {
        _header = [RCHouseHeader loadXibView];
        _header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 10.f+170.f+50.f);
    }
    return _header;
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
    self.tableView.estimatedRowHeight = 100;//预估高度
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 设置背景色为clear
    self.tableView.backgroundColor = [UIColor clearColor];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCHouseCell class]) bundle:nil] forCellReuseIdentifier:HouseCell];
    
    [self.view insertSubview:self.tableView atIndex:0];
}
-(void)setUpTableHeaderView
{
    hx_weakify(self);
    self.header.houseHeaderBtnClicked = ^(NSInteger type, NSInteger index) {
        hx_strongify(weakSelf);
        if (type == 0) {
            RCNoticeVC *nvc = [RCNoticeVC new];
            [strongSelf.navigationController pushViewController:nvc animated:YES];
        }else{
            
        }
    };
    self.tableView.tableHeaderView = self.header;
}
/**
 添加刷新控件
 */
-(void)setUpRefresh
{
    hx_weakify(self);
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    self.tableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf.tableView.mj_footer resetNoMoreData];
        
    }];
    //追加尾部刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        hx_strongify(weakSelf);
        
    }];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCHouseCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 165.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 100.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.filterView) {
        self.filterView.target = self;
        self.filterView.tableView = tableView;
        self.filterView.areas = @[@"全部",@"洪山区",@"武昌区",@"汉口区",@"汉阳区",@"蔡甸区",@"青山区"];
        self.filterView.wuye = @[@"全部",@"物业1",@"物业3",@"物业3",@"物业4"];
        self.filterView.huxing = @[@"全部",@"一居室",@"二居室",@"三居室",@"四居室"];
        self.filterView.mianji = @[@"全部",@"50-80平方",@"80-100平方",@"100-120平方",@"120-150平方"];
        return self.filterView;
    }
    RCHouseFilterView *fv = [RCHouseFilterView loadXibView];
    fv.hxn_width = HX_SCREEN_WIDTH;
    fv.hxn_height = 100.f;
    fv.target = self;
    fv.tableView = tableView;
    fv.areas = @[@"全部",@"洪山区",@"武昌区",@"汉口区",@"汉阳区",@"蔡甸区",@"青山区"];
    fv.wuye = @[@"全部",@"物业1",@"物业3",@"物业3",@"物业4"];
    fv.huxing = @[@"全部",@"一居室",@"二居室",@"三居室",@"四居室"];
    fv.mianji = @[@"全部",@"50-80平方",@"80-100平方",@"100-120平方",@"120-150平方"];
    hx_weakify(self);
    fv.filterCall = ^(NSInteger type, NSInteger btnTag, NSInteger index) {
        hx_strongify(weakSelf);
        if (index == 1) {
            
        }else{
            RCMapToHouseVC *hvc = [RCMapToHouseVC new];
            [strongSelf.navigationController pushViewController:hvc animated:YES];
        }
    };
    self.filterView = fv;
    return fv;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCHouseDetailVC *dvc = [RCHouseDetailVC new];
    [self.navigationController pushViewController:dvc animated:YES];
}


@end
