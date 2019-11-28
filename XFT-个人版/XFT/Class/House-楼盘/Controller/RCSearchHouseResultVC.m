//
//  RCSearchHouseResultVC.m
//  XFT
//
//  Created by 夏增明 on 2019/8/27.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCSearchHouseResultVC.h"
#import "HXSearchBar.h"
#import "RCHouseCell.h"
#import "RCNewsCell.h"
#import "RCHouseDetailVC.h"
#import "RCSearchResultHeader.h"
#import "RCSearchHouse.h"
#import "RCNews.h"
#import "RCNewsDetailVC.h"
#import "RCHouseNewsVC.h"
#import "RCSearchMoreHouseVC.h"

static NSString *const HouseCell = @"HouseCell";
static NSString *const NewsCell = @"NewsCell";

@interface RCSearchHouseResultVC ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 楼盘 */
@property(nonatomic,strong) NSArray *houses;
/* 资讯 */
@property(nonatomic,strong) NSArray *news;
@end
@implementation RCSearchHouseResultVC
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpUIConfig];
    [self setUpTableView];
    [self setUpEmptyView];
    [self startShimmer];
    [self getSearchRequest];
}
#pragma mark -- 视图相关
-(void)setUpUIConfig
{
    HXSearchBar *search = [HXSearchBar searchBar];
    search.backgroundColor = UIColorFromRGB(0xf5f5f5);
    search.hxn_width = HX_SCREEN_WIDTH - 80;
    search.hxn_height = 32;
    search.layer.cornerRadius = 32/2.f;
    search.layer.masksToBounds = YES;
    search.delegate = self;
    search.text = self.keyword;
    self.navigationItem.titleView = search;
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(cancelClickd) title:@"取消" font:[UIFont systemFontOfSize:15] titleColor:UIColorFromRGB(0xFF9F08) highlightedColor:UIColorFromRGB(0xFF9F08) titleEdgeInsets:UIEdgeInsetsZero];
}
-(void)setUpEmptyView
{
    LYEmptyView *emptyView = [LYEmptyView emptyViewWithImageStr:@"pic_none_search" titleStr:nil detailStr:@"暂无搜索内容"];
    emptyView.contentViewOffset = -(self.HXNavBarHeight);
    emptyView.subViewMargin = 30.f;
    emptyView.detailLabTextColor = UIColorFromRGB(0x131D2D);
    emptyView.detailLabFont = [UIFont fontWithName:@"PingFangSC-Semibold" size: 16];
    emptyView.autoShowEmptyView = NO;
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCHouseCell class]) bundle:nil] forCellReuseIdentifier:HouseCell];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCNewsCell class]) bundle:nil] forCellReuseIdentifier:NewsCell];
}
-(void)getSearchRequest
{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    // 执行循序1
    hx_weakify(self);
    dispatch_group_async(group, queue, ^{
        hx_strongify(weakSelf);
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        NSMutableDictionary *data = [NSMutableDictionary dictionary];
        data[@"proCityUuid"] = [[NSUserDefaults standardUserDefaults] objectForKey:HXCityCode];
        data[@"name"] = self.keyword;
        NSMutableDictionary *page = [NSMutableDictionary dictionary];
        page[@"current"] = @"1";
        page[@"size"] = @"3";
        parameters[@"data"] = data;
        parameters[@"page"] = page;

        [HXNetworkTool POST:HXRC_M_URL action:@"pro/pro/proBaseInfo/search" parameters:parameters success:^(id responseObject) {
            if ([responseObject[@"code"] integerValue] == 0) {
                strongSelf.houses = [NSArray yy_modelArrayWithClass:[RCSearchHouse class] json:responseObject[@"data"]];
            }else{
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
            }
            dispatch_semaphore_signal(semaphore);

        } failure:^(NSError *error) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
            dispatch_semaphore_signal(semaphore);

        }];
    });
    // 执行循序2
    dispatch_group_async(group, queue, ^{
        hx_strongify(weakSelf);
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        NSMutableDictionary *data = [NSMutableDictionary dictionary];
        data[@"cityId"] = [[NSUserDefaults standardUserDefaults] objectForKey:HXCityCode];
        data[@"title"] = self.keyword;
        parameters[@"data"] = data;
        
        [HXNetworkTool POST:HXRC_M_URL action:@"pro/pro/information/infListByLike" parameters:parameters success:^(id responseObject) {
            if ([responseObject[@"code"] integerValue] == 0) {
                NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCNews class] json:responseObject[@"data"]];
                if (arrt.count) {
                    strongSelf.news = [arrt subarrayWithRange:NSMakeRange(0, 1)];
                }else{
                    strongSelf.news = @[];
                }
            }else{
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
            }
            dispatch_semaphore_signal(semaphore);
        } failure:^(NSError *error) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
            dispatch_semaphore_signal(semaphore);
        }];
    });
    dispatch_group_notify(group, queue, ^{
        // 执行循序4
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        // 执行顺序6
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

        // 执行顺序10
        dispatch_async(dispatch_get_main_queue(), ^{
            // 刷新界面
            hx_strongify(weakSelf);
            [strongSelf stopShimmer];
            [strongSelf.tableView reloadData];
            if (strongSelf.houses.count || strongSelf.news.count) {
                [strongSelf.tableView ly_hideEmptyView];
            }else{
                [strongSelf.tableView ly_showEmptyView];
            }
        });
    });
}
#pragma mark -- 点击事件
-(void)cancelClickd
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- UITextField代理
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (![textField hasText]) {
        [MBProgressHUD showOnlyTextToView:self.view title:@"请输入关键字"];
        return NO;
    }
    [textField resignFirstResponder];//放弃响应
    self.keyword = textField.text;
    [self getSearchRequest];
    return YES;
}
#pragma mark -- UITableView数据源和代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.houses.count;
    }else{
        return self.news.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        RCHouseCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseCell forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        RCSearchHouse *seaHouse = self.houses[indexPath.row];
        cell.seaHouse = seaHouse;
        return cell;
    }else{
        RCNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:NewsCell forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        RCNews *news = self.news[indexPath.row];
        cell.news = news;
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    if (indexPath.section == 0) {
        return 165.f;
    }else{
        return 130.f;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return self.houses.count ?44.f:CGFLOAT_MIN;
    }else{
        return self.news.count?44.f:CGFLOAT_MIN;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    RCSearchResultHeader *header = [RCSearchResultHeader loadXibView];
    header.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 44.f);
    hx_weakify(self);
    header.moreClickedCall = ^{
        hx_strongify(weakSelf);
        if (section == 0) {
            if (strongSelf.houses.count >= 3) {
                RCSearchMoreHouseVC *hvc = [RCSearchMoreHouseVC new];
                hvc.keyword = strongSelf.keyword;
                [strongSelf.navigationController pushViewController:hvc animated:YES];
            }
        }else{
            if (strongSelf.news.count) {
                RCHouseNewsVC *nvc = [RCHouseNewsVC new];
                nvc.isSearchNews = YES;
                nvc.keyword = strongSelf.keyword;
                [strongSelf.navigationController pushViewController:nvc animated:YES];
            }
        }
    };
    if (section == 0) {
        header.title_txt.text = @"项目楼盘";
        header.more_txt.hidden = (self.houses.count >= 3)?NO:YES;
        return self.houses.count ?header:nil;
    }else{
        header.title_txt.text = @"新闻资讯";
        header.more_txt.hidden = (self.news.count)?NO:YES;
        return self.news.count ?header:nil;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        RCHouseDetailVC *dvc = [RCHouseDetailVC new];
        RCSearchHouse *seaHouse = self.houses[indexPath.row];
        dvc.uuid = seaHouse.uuid;
        [self.navigationController pushViewController:dvc animated:YES];
    }else{
        RCNewsDetailVC *dvc = [RCNewsDetailVC new];
        RCNews *news = self.news[indexPath.row];
        dvc.uuid = news.uuid;
        [self.navigationController pushViewController:dvc animated:YES];
    }
}
@end
