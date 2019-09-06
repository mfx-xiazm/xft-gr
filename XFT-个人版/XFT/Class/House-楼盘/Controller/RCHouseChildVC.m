//
//  RCHouseChildVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/6.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCHouseChildVC.h"
#import "RCHouseCell.h"
#import "RCHouseDetailVC.h"
#import "RCHouseFilterView.h"
#import "RCPageMainTable.h"

static NSString *const HouseCell = @"HouseCell";

@interface RCHouseChildVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 筛选 */
@property(nonatomic,strong) RCHouseFilterView *filterView;
/** 是否滑动 */
@property(nonatomic,assign)BOOL isCanScroll;

@end

@implementation RCHouseChildVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(childScrollHandle:) name:@"childScrollCan" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(childScrollHandle:) name:@"MainTableScroll" object:nil];
    [self setUpTableView];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.view.hxn_width = HX_SCREEN_WIDTH;
}
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
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCHouseCell class]) bundle:nil] forCellReuseIdentifier:HouseCell];
}
#pragma mark -- 通知处理
-(void)childScrollHandle:(NSNotification *)user{
    if ([user.name isEqualToString:@"childScrollCan"]){
        self.isCanScroll = YES;
    }else if ([user.name isEqualToString:@"MainTableScroll"]){
        self.isCanScroll = NO;
        [self.tableView setContentOffset:CGPointZero];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (!self.isCanScroll) {
        [scrollView setContentOffset:CGPointZero];
    }
    if (scrollView.contentOffset.y<=0) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"MainTableScroll" object:nil];
    }
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.filterView) {
        _filterView.target = self;
        _filterView.tableView = self.tableView;
        _filterView.areas = @[@"全部",@"洪山区",@"武昌区",@"汉口区",@"汉阳区",@"蔡甸区",@"青山区"];
        _filterView.wuye = @[@"全部",@"物业1",@"物业3",@"物业3",@"物业4"];
        _filterView.huxing = @[@"全部",@"一居室",@"二居室",@"三居室",@"四居室"];
        _filterView.mianji = @[@"全部",@"50-80平方",@"80-100平方",@"100-120平方",@"120-150平方"];
        return self.filterView;
    }
    RCHouseFilterView *filterView = [RCHouseFilterView loadXibView];
    filterView.frame = CGRectMake(0, 60.f, HX_SCREEN_WIDTH, 44.f);
    filterView.target = self.parentViewController;//父控制器
    filterView.tableView = self.mainTable;
    filterView.areas = @[@"全部",@"洪山区",@"武昌区",@"汉口区",@"汉阳区",@"蔡甸区",@"青山区"];
    filterView.wuye = @[@"全部",@"物业1",@"物业3",@"物业3",@"物业4"];
    filterView.huxing = @[@"全部",@"一居室",@"二居室",@"三居室",@"四居室"];
    filterView.mianji = @[@"全部",@"50-80平方",@"80-100平方",@"100-120平方",@"120-150平方"];
    filterView.filterCall = ^(NSInteger type, NSInteger btnTag, NSInteger index) {
        if (index == 1) {
            HXLog(@"筛选结果");
        }
    };
    return filterView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 165.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCHouseDetailVC *dvc = [RCHouseDetailVC new];
    [self.navigationController pushViewController:dvc animated:YES];
}

@end
