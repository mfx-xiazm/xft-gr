//
//  RCHouseFilterContentView.m
//  XFT
//
//  Created by 夏增明 on 2019/11/21.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCHouseFilterContentView.h"
#import "RCFilterCell.h"

//默认cell高度
#define tableViewCellHeight 44.f
//默认最大下拉高度
#define tableViewMaxHeight 352.f
//遮罩颜色
#define bgColor [UIColor colorWithWhite:0.0 alpha:0.2]
//默认未选中文案颜色
#define unselectColor UIColorFromRGB(0x131d2d)
//默认选中文案颜色
#define selectColor UIColorFromRGB(0xFF9F08)

static NSString *const FilterCell = @"FilterCell";
@interface RCHouseFilterContentView ()<UITableViewDataSource, UITableViewDelegate>
//是否显示
@property (nonatomic, assign) BOOL show;
@property (nonatomic, strong) NSMutableArray *menuArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *backGroundView;

@end
@implementation RCHouseFilterContentView

- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0, HX_SCREEN_WIDTH, HX_SCREEN_HEIGHT)];
    if (self) {
        [self initUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    //列表
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCFilterCell class]) bundle:nil] forCellReuseIdentifier:FilterCell];

    UIView *buttomView = [[UIView alloc] initWithFrame:self.bounds];
    buttomView.backgroundColor = [UIColor clearColor];
    buttomView.opaque = NO;
    //事件
    UIGestureRecognizer *gesture0 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuHidden)];
    [buttomView addGestureRecognizer:gesture0];
    [self addSubview:buttomView];

    //遮罩
    _backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _backGroundView.backgroundColor = bgColor;
    _backGroundView.opaque = NO;
    //事件
    UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuHidden)];
    [_backGroundView addGestureRecognizer:gesture];
    [self addSubview:_backGroundView];
    
    [self addSubview:_tableView];
}

#pragma mark - 更新数据源
-(void)reloadData {
//    _tableView.rowHeight = self.menuCellHeight ?: tableViewCellHeight;
//    CGFloat maxHeight = self.menuMaxHeight?:tableViewMaxHeight;
//    CGFloat count = [self.dataSource filterMenu_numberOfRows];
//    CGFloat height = count * _tableView.rowHeight  > maxHeight ? maxHeight : count * _tableView.rowHeight;
//    _tableView.frame = CGRectMake(0, 0, self.frame.size.width, height);
//    _tableView.scrollEnabled = count * _tableView.rowHeight  > maxHeight ? YES : NO;
    [_tableView reloadData];
}
#pragma mark - 触发下拉事件
- (void)menuShowInSuperView:(UIView *)view {
    if (!_show) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(filterMenu_positionInSuperView)]) {
            CGPoint position = [self.delegate filterMenu_positionInSuperView];
            _tableView.frame = CGRectMake(0.f, position.y, self.frame.size.width, HX_SCREEN_HEIGHT-280.f);
            _backGroundView.frame = CGRectMake(0.f, position.y, self.frame.size.width, HX_SCREEN_HEIGHT-position.y);
        } else {
            self.frame = CGRectMake(0, 0, self.frame.size.width, HX_SCREEN_HEIGHT);
        }
        if (view) {
            [view addSubview:self];
        }else{
            [[UIApplication sharedApplication].keyWindow addSubview:self];
        }
    }
    hx_weakify(self);
    [UIView animateWithDuration:0.2 animations:^{
        hx_strongify(weakSelf);
        strongSelf.backGroundView.backgroundColor = strongSelf.show ? [UIColor colorWithWhite:0.0 alpha:0.0] : bgColor;
        if (strongSelf.transformImageView) {
            strongSelf.transformImageView.transform = strongSelf.show ? CGAffineTransformMakeRotation(0) : CGAffineTransformMakeRotation(M_PI);
        }
    } completion:^(BOOL finished) {
        hx_strongify(weakSelf);
        if (strongSelf.show) {
            [strongSelf removeFromSuperview];
        }
        strongSelf.show = !strongSelf.show;
    }];
    
    self.titleLabel.textColor = HXControlBg;
    
    [self reloadData];
}

#pragma mark - 触发收起事件
- (void)menuHidden{
    if (_show) {
        self.titleLabel.textColor = UIColorFromRGB(0x131D2D);
        hx_weakify(self);
        [UIView animateWithDuration:0.2 animations:^{
            hx_strongify(weakSelf);
            strongSelf.backGroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
            if (strongSelf.transformImageView) {
                strongSelf.transformImageView.transform = CGAffineTransformMakeRotation(0);
            }
        } completion:^(BOOL finished) {
            hx_strongify(weakSelf);
            strongSelf.show = !strongSelf.show;
            [strongSelf removeFromSuperview];
            if ([strongSelf.delegate respondsToSelector:@selector(filterMenu_didDismiss)]) {
                [strongSelf.delegate filterMenu_didDismiss];
            }
        }];
    }
}
#pragma mark - 代理、数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource filterMenu_numberOfRows];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCFilterCell *cell = [tableView dequeueReusableCellWithIdentifier:FilterCell forIndexPath:indexPath];
    cell.cate.text = [self.dataSource filterMenu_titleForRow:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([self.titleLabel.text isEqualToString:cell.cate.text]) {
        cell.cate.textColor = self.titleHightLightColor ?: selectColor;
    }else{
        cell.cate.textColor = self.titleColor ?: unselectColor;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    self.titleLabel.text = [self.dataSource filterMenu_titleForRow:indexPath.row];
    if (self.delegate || [self.delegate respondsToSelector:@selector(filterMenu:didSelectRowAtIndexPath:)]) {
        [self.delegate filterMenu:self didSelectRowAtIndexPath:indexPath];
        [self menuHidden];
    }
}
@end
