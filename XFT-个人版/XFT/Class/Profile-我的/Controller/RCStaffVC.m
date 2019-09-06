//
//  RCStaffVC.m
//  XFT
//
//  Created by 夏增明 on 2019/8/29.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCStaffVC.h"
#import "RCStaffHeader.h"
#import "RCNavBarView.h"
#import "RCProfileCell.h"
#import "RCProfileInfoVC.h"
#import "RCProfileCollectVC.h"
#import "RCFeedbackVC.h"
#import "RCAboutUsVC.h"
#import "RCMySalaryVC.h"
#import "RCMyClientVC.h"
#import "RCProfileQuestionVC.h"
#import "RCBindCardVC.h"

static NSString *const ProfileCell = @"ProfileCell";

@interface RCStaffVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 导航栏 */
@property(nonatomic,strong) RCNavBarView *navBarView;
/* 头视图 */
@property(nonatomic,strong) RCStaffHeader *header;
/* titles */
@property(nonatomic,strong) NSArray *titles;
/* 关于我们的跳转（隐藏导航栏） */
@property(nonatomic,assign) BOOL isAboutUs;

@end

@implementation RCStaffVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.navBarView];
    [self setUpTableView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.isAboutUs = NO;
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:self.isAboutUs animated:animated];
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 600.f);
    self.navBarView.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, self.HXNavBarHeight);
}
-(RCNavBarView *)navBarView
{
    if (_navBarView == nil) {
        _navBarView = [RCNavBarView loadXibView];
        _navBarView.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, self.HXNavBarHeight);
        _navBarView.backBtn.hidden = YES;
        _navBarView.titleL.text = @"我的";
        _navBarView.titleL.textAlignment = NSTextAlignmentCenter;
    }
    return _navBarView;
}

-(RCStaffHeader *)header
{
    if (_header == nil) {
        _header = [RCStaffHeader loadXibView];
        _header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 600.f);
        hx_weakify(self);
        _header.staffHeaderBtnCall = ^(NSInteger index) {
            if (index == 1) {
                RCProfileInfoVC *ivc = [RCProfileInfoVC new];
                [weakSelf.navigationController pushViewController:ivc animated:YES];
            }else if (index == 2) {
                RCMySalaryVC *svc = [RCMySalaryVC new];
                [weakSelf.navigationController pushViewController:svc animated:YES];
            }else if (index == 3) {
                RCBindCardVC *bvc = [RCBindCardVC new];
                [weakSelf.navigationController pushViewController:bvc animated:YES];
            }else if (index == 4) {
                RCMyClientVC *cvc = [RCMyClientVC new];
                [weakSelf.navigationController pushViewController:cvc animated:YES];
            }else{
                
            }
        };
    }
    return _header;
}
-(NSArray *)titles
{
    if (_titles == nil) {
        _titles = @[@[@"我的收藏",@"我的预约"],@[@"平台问答",@"反馈与意见",@"关于我们"]];
    }
    return _titles;
}
-(void)setUpTableView
{
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCProfileCell class]) bundle:nil] forCellReuseIdentifier:ProfileCell];
    
    self.tableView.tableHeaderView = self.header;
}
#pragma mark -- 业务逻辑
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //该页面呈现时手动调用计算导航栏此时应当显示的颜色
    [self.navBarView changeColor:[UIColor whiteColor] offsetHeight:180-self.HXNavBarHeight withOffsetY:scrollView.contentOffset.y];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titles.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((NSArray *)self.titles[section]).count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section?10.f:0.1f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.hxn_width = HX_SCREEN_WIDTH;
    view.hxn_height = 10.f;
    view.backgroundColor = HXGlobalBg;
    
    return section?view:nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:ProfileCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.name.text = self.titles[indexPath.section][indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //我的收藏
            RCProfileCollectVC *cvc = [RCProfileCollectVC  new];
            [self.navigationController pushViewController:cvc animated:YES];
        }else{
            //我的预约
        }
    }else {
        if (indexPath.row == 0) {
            // 平台问答
            RCProfileQuestionVC *qvc = [RCProfileQuestionVC new];
            [self.navigationController pushViewController:qvc animated:YES];
        }else if (indexPath.row == 1) {
            // 反馈与意见
            RCFeedbackVC *fvc = [RCFeedbackVC new];
            [self.navigationController pushViewController:fvc animated:YES];
        }else{
            // 关于我们
            self.isAboutUs = YES;
            RCAboutUsVC *uvc = [RCAboutUsVC new];
            [self.navigationController pushViewController:uvc animated:YES];
        }
    }
}
@end
