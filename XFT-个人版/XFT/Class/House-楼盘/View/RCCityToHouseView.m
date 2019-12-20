//
//  RCCityToHouseView.m
//  XFT
//
//  Created by 夏增明 on 2019/9/10.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCCityToHouseView.h"
#import "HXSearchBar.h"
#import <ZLCollectionViewVerticalLayout.h>
#import "RCSearchTagCell.h"
#import "RCSearchTagHeader.h"
#import "RCOpenArea.h"

static NSString *const SearchTagCell = @"SearchTagCell";
static NSString *const SearchTagHeader = @"SearchTagHeader";

@interface RCCityToHouseView ()<UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,ZLCollectionViewBaseFlowLayoutDelegate>
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
/* 搜索条 */
@property(nonatomic,strong) HXSearchBar *searchBar;
@end
@implementation RCCityToHouseView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.searchBar = [[HXSearchBar alloc] initWithFrame:self.searchView.bounds];
    self.searchBar.backgroundColor = UIColorFromRGB(0xf5f5f5);
    self.searchBar.layer.cornerRadius = 36/2.f;
    self.searchBar.layer.masksToBounds = YES;
    self.searchBar.placeholder = @"请输入城市名称搜索";
    self.searchBar.delegate = self;
    [self.searchView addSubview:self.searchBar];
    hx_weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.searchBar.frame = weakSelf.searchView.bounds;
    });
    
    ZLCollectionViewVerticalLayout *flowLayout = [[ZLCollectionViewVerticalLayout alloc] init];
    flowLayout.delegate = self;
    flowLayout.canDrag = NO;
    _collectionView.collectionViewLayout = flowLayout;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.bounces =  NO;
    _collectionView.userInteractionEnabled = YES;
    _collectionView.backgroundColor = HXGlobalBg;

    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([RCSearchTagCell class]) bundle:nil] forCellWithReuseIdentifier:SearchTagCell];
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([RCSearchTagHeader class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SearchTagHeader];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self bezierPathByRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(6, 6)];
}
-(void)setCitys:(NSArray *)citys
{
    _citys = citys;
    [self.collectionView reloadData];
}
#pragma mark -- UITextField代理
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(cityView:didSearchReturn:)]) {
        [self.delegate cityView:self didSearchReturn:[textField hasText]?textField.text:@""];
    }
    return YES;
}
#pragma mark -- 业务逻辑

#pragma mark -- UICollectionView 数据源和代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.citys.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    RCOpenArea *area = self.citys[section];
    return area.list.count;
}
- (ZLLayoutType)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section {
    return LabelLayout;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RCSearchTagCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:SearchTagCell forIndexPath:indexPath];
    RCOpenArea *area = self.citys[indexPath.section];
    RCOpenCity *city = area.list[indexPath.item];
    cell.contentText.text = [NSString stringWithFormat:@"%@(%@)",city.cname,city.num];
    cell.contentText.backgroundColor = [UIColor whiteColor];
    cell.contentText.textColor = [UIColor lightGrayColor];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    RCOpenArea *area = self.citys[indexPath.section];
    RCOpenCity *city = area.list[indexPath.item];
    if (city.num && city.num.length) {
        if ([self.delegate respondsToSelector:@selector(cityView:didClickedCity:)]) {
            [self.delegate cityView:self didClickedCity:city];
        }
    }else{
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"该城市暂无项目"];
    }
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString : UICollectionElementKindSectionHeader]){
        RCSearchTagHeader * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SearchTagHeader forIndexPath:indexPath];
        RCOpenArea *area = self.citys[indexPath.section];
        headerView.tabText.text = area.aname;
        headerView.locationBtn.hidden = YES;
        return headerView;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(HX_SCREEN_WIDTH, 44);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    RCOpenArea *area = self.citys[indexPath.section];
    RCOpenCity *city = area.list[indexPath.item];
    return CGSizeMake([[NSString stringWithFormat:@"%@(%@)",city.cname,city.num] boundingRectWithSize:CGSizeMake(1000000, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:14]} context:nil].size.width + 30, 30);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10.f;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return  UIEdgeInsetsMake(5, 15, 5, 15);
}
@end
