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
#import "RCHouseAdviser.h"

static NSString *const HouseAdviserCell = @"HouseAdviserCell";

@interface RCHouseAdviserVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *searchView;
/* 搜索 */
@property(nonatomic,strong) HXSearchBar *search;
/* 类表 */
@property(nonatomic,strong) NSArray *advisers;
@end

@implementation RCHouseAdviserVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpTableView];
    [self getAdviserDataRequest];
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
    
    HXSearchBar *search = [HXSearchBar searchBar];
    search.backgroundColor = UIColorFromRGB(0xf5f5f5);
    search.hxn_x = 15.f;
    search.hxn_y = 10.f;
    search.hxn_width = HX_SCREEN_WIDTH - 30.f;
    search.hxn_height = 40.f;
    search.layer.cornerRadius = 40/2.f;
    search.layer.masksToBounds = YES;
    search.placeholder = @"请输入姓名进行搜索";
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
-(IBAction)sureClickd
{
    if (self.chooseAdviserCall) {
        self.chooseAdviserCall(self.lastAdvier?self.lastAdvier:nil);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)getAdviserDataRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"prouuid"] = self.prouuid;//项目uuid
    data[@"queryName"] = [self.search hasText]?self.search.text:@"";//反馈意见

    parameters[@"data"] = data;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"anchang/anchang/baobei/assignUserList" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if ([responseObject[@"code"] integerValue] == 0) {
            NSMutableArray *arrt = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[RCHouseAdviser class] json:responseObject[@"data"]]];
            RCHouseAdviser *adviser = [RCHouseAdviser new];
            adviser.isNotAdviser = YES;
            [arrt insertObject:adviser atIndex:0];
            strongSelf.advisers = [NSArray arrayWithArray:arrt];
            if (strongSelf.lastAdvier) {
                 for (RCHouseAdviser *adviser0 in strongSelf.advisers) {
                     if (adviser0.isNotAdviser && strongSelf.lastAdvier.isNotAdviser) {
                         adviser0.isSelected = YES;
                         strongSelf.lastAdvier = adviser0;
                         break;
                     }else if ([adviser0.accUuid isEqualToString:strongSelf.lastAdvier.accUuid]){
                         adviser0.isSelected = YES;
                         strongSelf.lastAdvier = adviser0;
                         break;
                     }
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.tableView reloadData];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.advisers.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCHouseAdviserCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseAdviserCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    RCHouseAdviser *adviser = self.advisers[indexPath.row];
    cell.adviser = adviser;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 64.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCHouseAdviser *adviser = self.advisers[indexPath.row];
    self.lastAdvier.isSelected = NO;
    adviser.isSelected = YES;
    self.lastAdvier = adviser;
    
    [tableView reloadData];
}


@end
