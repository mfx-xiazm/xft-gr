//
//  RCHouseNewsVC.m
//  XFT
//
//  Created by 夏增明 on 2019/8/29.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCHouseNewsVC.h"
#import "RCNewsCell.h"
#import "RCNewsDetailVC.h"
#import "RCNews.h"

static NSString *const NewsCell = @"NewsCell";

@interface RCHouseNewsVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 资讯 */
@property(nonatomic,strong) NSArray *news;
@end

@implementation RCHouseNewsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:self.isSearchNews?@"新闻资讯":@"楼盘动态"];
    [self setUpTableView];
    [self startShimmer];
    [self getNewsDataRequest];
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCNewsCell class]) bundle:nil] forCellReuseIdentifier:NewsCell];
}
-(void)getNewsDataRequest
{
    if (self.isSearchNews) {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        NSMutableDictionary *data = [NSMutableDictionary dictionary];
        data[@"cityId"] = [[NSUserDefaults standardUserDefaults] objectForKey:HXCityCode];
        data[@"title"] = self.keyword;
        parameters[@"data"] = data;
        
        hx_weakify(self);
        [HXNetworkTool POST:HXRC_M_URL action:@"pro/pro/information/infListByLike" parameters:parameters success:^(id responseObject) {
            hx_strongify(weakSelf);
            [strongSelf stopShimmer];
            if ([responseObject[@"code"] integerValue] == 0) {
                strongSelf.news = [NSArray yy_modelArrayWithClass:[RCNews class] json:responseObject[@"data"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 刷新界面
                    hx_strongify(weakSelf);
                    [strongSelf stopShimmer];
                    [strongSelf.tableView reloadData];
                });
            }else{
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
            }
        } failure:^(NSError *error) {
            hx_strongify(weakSelf);
            [strongSelf stopShimmer];
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
        }];
    }else{
        // 楼盘动态
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        NSMutableDictionary *data = [NSMutableDictionary dictionary];
        data[@"proUuid"] = self.uuid;
        data[@"newsType"] = @"1";//类别: 1:新闻咨询 2:报名活动 3:城市公告
        parameters[@"data"] = data;

        hx_weakify(self);
        [HXNetworkTool POST:HXRC_M_URL action:@"pro/pro/information/infListByProUuid" parameters:parameters success:^(id responseObject) {
            hx_strongify(weakSelf);
            [strongSelf stopShimmer];
            if ([responseObject[@"code"] integerValue] == 0) {
                strongSelf.news = [NSArray yy_modelArrayWithClass:[RCNews class] json:responseObject[@"data"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 刷新界面
                    hx_strongify(weakSelf);
                    [strongSelf stopShimmer];
                    [strongSelf.tableView reloadData];
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
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.news.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:NewsCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    RCNews *news = self.news[indexPath.row];
    cell.news = news;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 130.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCNewsDetailVC *dvc = [RCNewsDetailVC new];
    RCNews *news = self.news[indexPath.row];
    dvc.uuid = news.uuid;
    dvc.lookSuccessCall = ^{
        news.clickNum = [NSString stringWithFormat:@"%zd",[news.clickNum integerValue]+1];
        [tableView reloadData];
    };
    [self.navigationController pushViewController:dvc animated:YES];
}


@end
