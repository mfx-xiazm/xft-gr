//
//  RCClientNoteVC.m
//  XFT
//
//  Created by 夏增明 on 2019/8/31.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCClientNoteVC.h"
#import "RCClientNoteCell.h"
#import "RCMyClientNote.h"

static NSString *const ClientNoteCell = @"ClientNoteCell";
@interface RCClientNoteVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 客户轨迹 */
@property(nonatomic,strong) NSArray *clientNotes;
@end

@implementation RCClientNoteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"客户轨迹"];
    [self setUpTableView];
    [self setUpEmptyView];
    [self startShimmer];
    [self getClientNoteRequest];
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCClientNoteCell class]) bundle:nil] forCellReuseIdentifier:ClientNoteCell];
}
-(void)setUpEmptyView
{
    LYEmptyView *emptyView = [LYEmptyView emptyViewWithImageStr:@"pic_none_search" titleStr:nil detailStr:@"暂无轨迹"];
    emptyView.contentViewOffset = -(self.HXNavBarHeight);
    emptyView.subViewMargin = 30.f;
    emptyView.detailLabTextColor = UIColorFromRGB(0x131D2D);
    emptyView.detailLabFont = [UIFont fontWithName:@"PingFangSC-Semibold" size: 16];
    emptyView.autoShowEmptyView = NO;
    self.tableView.ly_emptyView = emptyView;
}
-(void)getClientNoteRequest
{
    // 请求客户轨迹的接口
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"cusUuid"] = self.cusUuid;
    parameters[@"data"] = data;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"cus/cus/cusInfo/getCusTrackInfo" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if ([responseObject[@"code"] integerValue] == 0) {
            strongSelf.clientNotes = [NSArray yy_modelArrayWithClass:[RCMyClientNote class] json:responseObject[@"data"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.tableView reloadData];
                if (strongSelf.clientNotes.count) {
                    [strongSelf.tableView ly_hideEmptyView];
                }else{
                    [strongSelf.tableView ly_showEmptyView];
                }
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
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.clientNotes.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCClientNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:ClientNoteCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.num.text = [NSString stringWithFormat:@"%zd",indexPath.row+1];
    cell.tabImg.image = indexPath.row ?HXGetImage(@"circle_jindu"):HXGetImage(@"circle_jindu_yellow");
    cell.buttomLine.hidden = (indexPath.row == self.clientNotes.count-1)?YES:NO;
    cell.bgView.backgroundColor = indexPath.row?UIColorFromRGB(0xf5f5f5):[UIColor whiteColor];
    RCMyClientNote *note = self.clientNotes[indexPath.row];
    cell.note = note;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
