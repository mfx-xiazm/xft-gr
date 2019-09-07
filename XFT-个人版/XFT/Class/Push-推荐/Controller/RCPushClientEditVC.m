//
//  RCPushClientEditVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/7.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCPushClientEditVC.h"
#import "RCAddPhoneCell.h"
#import "WSDatePickerView.h"
#import "HXPlaceholderTextView.h"
#import "RCHouseAdviserVC.h"

static NSString *const AddPhoneCell = @"AddPhoneCell";

@interface RCPushClientEditVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *morePhoneViewHeight;
@property (weak, nonatomic) IBOutlet UITableView *morePhoneView;
@property (weak, nonatomic) IBOutlet HXPlaceholderTextView *remark;
@property (weak, nonatomic) IBOutlet UITextField *appointDate;
/* 多加的电话 */
@property(nonatomic,strong) NSMutableArray *phones;
@end

@implementation RCPushClientEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"客户推荐编辑"];
    self.remark.placeholder = @"请输入客户购房的补充说明(选填)";
    [self setUpTableView];
}
-(NSMutableArray *)phones
{
    if (_phones == nil) {
        _phones = [NSMutableArray array];
    }
    return _phones;
}
-(void)setUpTableView
{
    self.morePhoneView.estimatedRowHeight = 0;
    self.morePhoneView.estimatedSectionHeaderHeight = 0;
    self.morePhoneView.estimatedSectionFooterHeight = 0;
    self.morePhoneView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.morePhoneView.scrollEnabled = NO;
    self.morePhoneView.dataSource = self;
    self.morePhoneView.delegate = self;
    self.morePhoneView.showsVerticalScrollIndicator = NO;
    self.morePhoneView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.morePhoneView registerNib:[UINib nibWithNibName:NSStringFromClass([RCAddPhoneCell class]) bundle:nil] forCellReuseIdentifier:AddPhoneCell];
}
- (IBAction)addPhoneClicked:(UIButton *)sender {
    [self.phones addObject:@""];
    self.morePhoneViewHeight.constant = 50.f*self.phones.count;
    [self.morePhoneView reloadData];
}
- (IBAction)chooseWuYeClicked:(UIButton *)sender {
    HXLog(@"选择物业");
}
- (IBAction)chooseZhiYeClicked:(UIButton *)sender {
    RCHouseAdviserVC *avc = [RCHouseAdviserVC new];
    [self.navigationController pushViewController:avc animated:YES];
}
- (IBAction)chooseVisitDateClicked:(UIButton *)sender {
    //年-月-日
    hx_weakify(self);
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay CompleteBlock:^(NSDate *selectDate) {
        
        NSString *dateString = [selectDate stringWithFormat:@"yyyy-MM-dd"];
        weakSelf.appointDate.text = dateString;
    }];
    datepicker.dateLabelColor = HXControlBg;//年-月-日 颜色
    datepicker.datePickerColor = [UIColor blackColor];//滚轮日期颜色
    datepicker.doneButtonColor = HXControlBg;//确定按钮的颜色
    [datepicker show];
}
- (IBAction)choosePushRoleClicked:(UIButton *)sender {
    HXLog(@"报备身份");
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.phones.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCAddPhoneCell *cell = [tableView dequeueReusableCellWithIdentifier:AddPhoneCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    hx_weakify(self);
    cell.cutBtnCall = ^{
        hx_strongify(weakSelf);
        [strongSelf.phones removeLastObject];
        strongSelf.morePhoneViewHeight.constant = 50.f*strongSelf.phones.count;
        [tableView reloadData];
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 50.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
