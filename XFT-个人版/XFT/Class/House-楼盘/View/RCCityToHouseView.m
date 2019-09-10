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

#define KFilePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"kSearchCityHistory.plist"]

static NSString *const SearchTagCell = @"SearchTagCell";
static NSString *const SearchTagHeader = @"SearchTagHeader";

@interface RCCityToHouseView ()<UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,ZLCollectionViewBaseFlowLayoutDelegate>
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
/* 搜索条 */
@property(nonatomic,strong) HXSearchBar *searchBar;
/** 搜索历史 */
@property (nonatomic,strong) NSMutableArray *citys;
/** 搜索历史 */
@property (nonatomic,strong) NSMutableArray *historys;
@end
@implementation RCCityToHouseView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [self readHistorySearch];
    
    self.searchBar = [[HXSearchBar alloc] initWithFrame:self.searchView.bounds];
    self.searchBar.backgroundColor = UIColorFromRGB(0xf5f5f5);
    self.searchBar.layer.cornerRadius = 36/2.f;
    self.searchBar.layer.masksToBounds = YES;
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
    _collectionView.backgroundColor = [UIColor whiteColor];
    
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([RCSearchTagCell class]) bundle:nil] forCellWithReuseIdentifier:SearchTagCell];
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([RCSearchTagHeader class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SearchTagHeader];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self bezierPathByRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(6, 6)];
}
-(NSMutableArray *)historys
{
    if (_historys == nil) {
        _historys = [NSMutableArray array];
    }
    return _historys;
}
-(NSMutableArray *)citys
{
    if (_citys == nil) {
        _citys = [NSMutableArray arrayWithArray:@[@{@"tag":@"历史访问",@"citys":self.historys},@{@"tag":@"热门访问",@"citys":@[@"长沙",@"太原",@"武汉",@"呼和浩特",@"郑州",@"郑州",@"北京",@"长沙",@"太原",@"武汉",@"呼和浩特",@"郑州",@"郑州",@"北京",@"长沙",@"太原",@"武汉",@"呼和浩特",@"郑州",@"郑州",@"北京"]},@{@"tag":@"武汉区域",@"citys":@[@"长沙",@"呼和浩特",@"武汉",@"上海",@"郑州",@"郑州",@"北京",@"长沙",@"呼和浩特",@"武汉",@"上海",@"郑州",@"郑州",@"北京",@"长沙",@"呼和浩特",@"武汉",@"上海",@"郑州",@"郑州",@"北京"]},@{@"tag":@"上海区域",@"citys":@[@"长沙",@"太原",@"武汉",@"上海",@"郑州",@"乌鲁木齐",@"北京",@"长沙",@"太原",@"武汉",@"上海",@"郑州",@"乌鲁木齐",@"北京",@"长沙",@"太原",@"武汉",@"上海",@"郑州",@"乌鲁木齐",@"北京"]},@{@"tag":@"郑州区域",@"citys":@[@"长沙",@"太原",@"武汉",@"上海",@"郑州",@"郑州",@"北京",@"长沙",@"太原",@"武汉",@"上海",@"郑州",@"郑州",@"北京",@"长沙",@"太原",@"武汉",@"上海",@"郑州",@"郑州",@"北京"]}]];
    }
    return _citys;
}
#pragma mark -- UITextField代理
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    // ============ 触发block =============
//    if (self.didClickTextFieldBlock) {
//        self.didClickTextFieldBlock();
//    }
    return YES;
}
#pragma mark -- 业务逻辑
//-(void)didClickTextField:(DidClickTextFieldBlock)block
//{
//    self.didClickTextFieldBlock = block;
//}
-(void)readHistorySearch
{
    // 判断是否存在
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:KFilePath] == NO) {
        HXLog(@"不存在");
        // 一、使用NSMutableArray来接收plist里面的文件
        //        plistArr = [[NSMutableArray alloc] init];
    } else {
        HXLog(@"存在");
        // 使用NSArray来接收plist里面的文件，获取里面的数据
        NSArray *arr = [NSArray arrayWithContentsOfFile:KFilePath];
        if (arr.count != 0) {
            [self.historys addObjectsFromArray:arr];
        } else {
            HXLog(@"plist文件为空");
        }
    }
    [self.collectionView reloadData];
}
-(void)writeHistorySearch
{
    [self.historys writeToFile:KFilePath atomically:YES];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.citys.firstObject];
    dict[@"citys"] = self.historys;
    [self.citys replaceObjectAtIndex:0 withObject:dict];
    //    RCSearchHouseResultVC *rvc = [RCSearchHouseResultVC new];
    //    [self.navigationController pushViewController:rvc animated:YES];
}
-(void)checkHistoryData:(NSString *)history
{
    if (![self.historys containsObject:history]) {//如果历史数据不包含就加
        [self.historys insertObject:history atIndex:0];
    }else{//如果历史数据包含就更新
        [self.historys removeObject:history];
        [self.historys insertObject:history atIndex:0];
    }
    //    if (self.historys.count > 6) {
    //        [self.historys removeLastObject];
    //    }
    [self writeHistorySearch];//写入
    
    [self.collectionView reloadData];//刷新页面
}
-(void)clearClicked
{
    [self.historys removeAllObjects];
    [self writeHistorySearch];//写入
    [self.collectionView reloadData];
}
#pragma mark -- UICollectionView 数据源和代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.citys.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSDictionary *dict = self.citys[section];
    return ((NSArray *)dict[@"citys"]).count;
}
- (ZLLayoutType)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section {
    return LabelLayout;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RCSearchTagCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:SearchTagCell forIndexPath:indexPath];
    NSDictionary *dict = self.citys[indexPath.section];
    cell.contentText.backgroundColor = HXGlobalBg;
    cell.contentText.text = ((NSArray *)dict[@"citys"])[indexPath.item];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.citys[indexPath.section];
    [self checkHistoryData:((NSArray *)dict[@"citys"])[indexPath.item]];
    
    if (self.didSelectCityCall) {
        self.didSelectCityCall();
    }
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString : UICollectionElementKindSectionHeader]){
        RCSearchTagHeader * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SearchTagHeader forIndexPath:indexPath];
        NSDictionary *dict = self.citys[indexPath.section];
        headerView.tabText.text = dict[@"tag"];
        headerView.locationBtn.hidden = YES;
        return headerView;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(HX_SCREEN_WIDTH, 44);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.citys[indexPath.section];
    return CGSizeMake([((NSArray *)dict[@"citys"])[indexPath.item] boundingRectWithSize:CGSizeMake(1000000, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:14]} context:nil].size.width + 30, 30);
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
