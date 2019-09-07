//
//  RCNoticeVC.m
//  XFT
//
//  Created by 夏增明 on 2019/8/28.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCNoticeVC.h"
#import "RCNoticeCell.h"
#import "RCWebContentVC.h"

static NSString *const NoticeCell = @"NoticeCell";

@interface RCNoticeVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RCNoticeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HXGlobalBg;
    [self.navigationItem setTitle:self.navTitle];
    [self setUpTableView];
    [self setUpEmptyView];
}
#pragma mark -- 视图相关
-(void)setUpEmptyView
{
    LYEmptyView *emptyView = [LYEmptyView emptyViewWithImageStr:@"no_report" titleStr:nil detailStr:@"暂无内容"];
    emptyView.contentViewOffset = -(self.HXNavBarHeight);
    emptyView.subViewMargin = 30.f;
    emptyView.detailLabTextColor = UIColorFromRGB(0x131D2D);
    emptyView.detailLabFont = [UIFont fontWithName:@"PingFangSC-Semibold" size: 16];
    self.tableView.ly_emptyView = emptyView;
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCNoticeCell class]) bundle:nil] forCellReuseIdentifier:NoticeCell];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:NoticeCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 155.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCWebContentVC *wvc = [RCWebContentVC new];
    wvc.navTitle = @"公告";
    wvc.url = @"https://www.baidu.com/";
    [self.navigationController pushViewController:wvc animated:YES];
}

@end
