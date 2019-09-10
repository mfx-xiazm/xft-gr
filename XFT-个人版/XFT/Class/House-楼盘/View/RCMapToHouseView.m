//
//  RCMapToHouseView.m
//  XFT
//
//  Created by 夏增明 on 2019/9/10.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCMapToHouseView.h"
#import "RCHouseNearbyCell.h"

static NSString *const HouseNearbyCell = @"HouseNearbyCell";

@interface RCMapToHouseView ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 第一个按键 */
@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
/* 上一次选中的类型按键 */
@property(nonatomic,strong) UIButton *lastBtn;
@end
@implementation RCMapToHouseView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.lastBtn = self.firstBtn;

    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    }
    _tableView.estimatedRowHeight = 0;//预估高度
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    _tableView.showsVerticalScrollIndicator = NO;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.bounces =  NO;
    _tableView.backgroundColor = [UIColor whiteColor];
    
    // 注册cell
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCHouseNearbyCell class]) bundle:nil] forCellReuseIdentifier:HouseNearbyCell];
}
- (IBAction)nearbyTypeClicked:(UIButton *)sender {
    self.lastBtn.selected = NO;
    sender.selected = YES;
    self.lastBtn = sender;
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCHouseNearbyCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseNearbyCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 44.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
