//
//  RCMySalaryVC.m
//  XFT
//
//  Created by 夏增明 on 2019/8/29.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCMySalaryVC.h"
#import "RCMySalaryCell.h"
#import "RCCashDetailVC.h"

static NSString *const MySalaryCell = @"MySalaryCell";
@interface RCMySalaryVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RCMySalaryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"我的佣金"];
    [self setUpTableView];
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCMySalaryCell class]) bundle:nil] forCellReuseIdentifier:MySalaryCell];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCMySalaryCell *cell = [tableView dequeueReusableCellWithIdentifier:MySalaryCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 115.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCCashDetailVC *dvc = [RCCashDetailVC new];
    [self.navigationController pushViewController:dvc animated:YES];
}

@end
