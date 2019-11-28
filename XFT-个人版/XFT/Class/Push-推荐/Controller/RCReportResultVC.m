//
//  RCReportResultVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCReportResultVC.h"
#import "RCReportResultHeader.h"
#import "RCReportResultCell.h"
#import "RCReportResultSectionHeader.h"
#import "RCReportTarget.h"
#import "RCPushClientEditVC.h"

static NSString *const ReportResultSectionHeader = @"ReportResultSectionHeader";
static NSString *const ReportResultCell = @"ReportResultCell";
@interface RCReportResultVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 头视图 */
@property(nonatomic,strong) RCReportResultHeader *header;
/* 成功数组 */
@property(nonatomic,strong) NSArray *successList;
/* 失败数组 */
@property(nonatomic,strong) NSArray *errorList;
/** vc控制器 */
@property (nonatomic,strong) NSMutableArray *controllers;
@end

@implementation RCReportResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"推荐结果"];
    self.view.backgroundColor = [UIColor whiteColor];
    hx_weakify(self);
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[RCPushClientEditVC class]]) {
            hx_strongify(weakSelf);
            [strongSelf.controllers removeObjectAtIndex:idx];
            *stop = YES;
        }
    }];
    [self.navigationController setViewControllers:self.controllers];
    
    [self setUpTableView];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.tableView reloadData];
    });
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 145);
}
- (NSMutableArray *)controllers {
    if (!_controllers) {
        _controllers = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
    }
    return _controllers;
}
-(RCReportResultHeader *)header
{
    if (_header == nil) {
        _header = [RCReportResultHeader loadXibView];
    }
    return _header;
}
-(void)setResults:(NSDictionary *)results
{
    _results = results;
    self.successList = [NSArray yy_modelArrayWithClass:[RCReportTarget class] json:_results[@"successList"]];
    self.errorList = [NSArray yy_modelArrayWithClass:[RCReportTarget class] json:_results[@"errorList"]];
}
#pragma mark -- 视图相关
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
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCReportResultCell class]) bundle:nil] forCellReuseIdentifier:ReportResultCell];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCReportResultSectionHeader class]) bundle:nil] forHeaderFooterViewReuseIdentifier:ReportResultSectionHeader];
    
    if (self.successList.count && !self.errorList.count) {
        // 展示头部
        self.header.header_img.image = HXGetImage(@"icon_complete");
        self.header.header_title.text = @"推荐成功";
        self.tableView.tableHeaderView = self.header;
    }else if (!self.successList.count && self.errorList.count) {
        // 展示头部
        self.header.header_img.image = HXGetImage(@"icon_complete_er");
        self.header.header_title.text = @"推荐失败";
        self.tableView.tableHeaderView = self.header;
    }else{
        // 不展示头部
    }
}
#pragma mark -- 点击事件
- (IBAction)reportAganClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.successList.count;
    }else{
        return self.errorList.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCReportResultCell *cell = [tableView dequeueReusableCellWithIdentifier:ReportResultCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.nnum.text = [NSString stringWithFormat:@"%d.",indexPath.row+1];
    if (indexPath.section == 0) {
        cell.isSuccess = YES;
        RCReportTarget *person = self.successList[indexPath.row];
        cell.person = person;
    }else{
        cell.isSuccess = NO;
        RCReportTarget *person = self.errorList[indexPath.row];
        cell.person = person;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return self.successList.count?44.f:0.f;
    }else{
        return self.errorList.count?44.f:0.f;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    RCReportResultSectionHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ReportResultSectionHeader];
    if (!header) {
        header = [[RCReportResultSectionHeader alloc] initWithReuseIdentifier:ReportResultSectionHeader];
    }
    if (section == 0) {
        header.resultTitle.text = @"已推荐";
        header.resultTitle.textColor = HXControlBg;
        header.resultNum.text = [NSString stringWithFormat:@"%zd人",self.successList.count];
        return self.successList.count?header:nil;
    }else{
        header.resultTitle.text = @"推荐失败";
        header.resultTitle.textColor = [UIColor redColor];
        header.resultNum.text = [NSString stringWithFormat:@"%zd人",self.errorList.count];
        return self.errorList.count?header:nil;
    }
    return header;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15.f;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer = [UIView new];
    footer.backgroundColor = [UIColor whiteColor];
    return footer;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}



@end
