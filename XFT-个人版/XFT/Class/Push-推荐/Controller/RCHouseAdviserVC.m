//
//  RCHouseAdviserVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/7.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCHouseAdviserVC.h"
#import "RCHouseAdviserCell.h"
#import "HXSearchBar.h"

static NSString *const HouseAdviserCell = @"HouseAdviserCell";

@interface RCHouseAdviserVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *searchView;
/* 搜索 */
@property(nonatomic,strong) HXSearchBar *search;
@end

@implementation RCHouseAdviserVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpTableView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    });
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.search.frame = CGRectMake(15.f, 10.f, HX_SCREEN_WIDTH - 30.f, 40.f);
}
#pragma mark -- 视图相关
-(void)setUpNavBar
{
    [self.navigationItem setTitle:@"顾问选择"];

    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(sureClickd) title:@"确定" font:[UIFont systemFontOfSize:15] titleColor:UIColorFromRGB(0xFF9F08) highlightedColor:UIColorFromRGB(0xFF9F08) titleEdgeInsets:UIEdgeInsetsZero];
    
    
    HXSearchBar *search = [HXSearchBar searchBar];
    search.backgroundColor = UIColorFromRGB(0xf5f5f5);
    search.hxn_x = 15.f;
    search.hxn_y = 10.f;
    search.hxn_width = HX_SCREEN_WIDTH - 30.f;
    search.hxn_height = 40.f;
    search.layer.cornerRadius = 40/2.f;
    search.layer.masksToBounds = YES;
    search.delegate = self;
    self.search = search;
    [self.searchView addSubview:search];
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
    // 设置背景色为clear
    self.tableView.backgroundColor = [UIColor clearColor];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCHouseAdviserCell class]) bundle:nil] forCellReuseIdentifier:HouseAdviserCell];
}
#pragma mark -- 点击事件
-(void)sureClickd
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCHouseAdviserCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseAdviserCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 64.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}


@end
