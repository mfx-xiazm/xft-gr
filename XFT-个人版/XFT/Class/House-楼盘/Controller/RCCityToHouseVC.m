//
//  RCCityToHouseVC.m
//  XFT
//
//  Created by 夏增明 on 2019/8/31.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCCityToHouseVC.h"
#import "HXSearchBar.h"
#import <ZLCollectionViewVerticalLayout.h>
#import "RCSearchTagCell.h"
#import "RCSearchTagHeader.h"

#define KFilePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"kSearchCityHistory.plist"]

#define Y1               150
//#define Y2               self.view.frame.size.height - 250
#define Y3               self.view.frame.size.height - 64

static NSString *const SearchTagCell = @"SearchTagCell";
static NSString *const SearchTagHeader = @"SearchTagHeader";
static NSString *const CityToHouseSearchHeader = @"CityToHouseSearchHeader";

@interface RCCityToHouseVC ()<UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,ZLCollectionViewBaseFlowLayoutDelegate>
/** 搜索历史 */
@property (nonatomic,strong) NSMutableArray *citys;
/** 搜索历史 */
@property (nonatomic,strong) NSMutableArray *historys;
@end

@implementation RCCityToHouseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.userInteractionEnabled = YES;
    self.view.clipsToBounds = YES;
    self.view.layer.cornerRadius = 6.f;
    
    [self readHistorySearch];
    [self.view addSubview:self.collectionView];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}
-(UICollectionView *)collectionView
{
    if (_collectionView ==  nil) {
        ZLCollectionViewVerticalLayout *flowLayout = [[ZLCollectionViewVerticalLayout alloc] init];
        flowLayout.delegate = self;
        flowLayout.canDrag = NO;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, HX_SCREEN_WIDTH, HX_SCREEN_HEIGHT-Y1) collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.bounces =  NO;
        _collectionView.userInteractionEnabled = YES;
        _collectionView.scrollEnabled = NO; // 让collectionView默认禁止滚动
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([RCSearchTagCell class]) bundle:nil] forCellWithReuseIdentifier:SearchTagCell];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([RCSearchTagHeader class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SearchTagHeader];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([RCCityToHouseSearchHeader class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CityToHouseSearchHeader];
        
    }
    return _collectionView;
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
#pragma mark -- 视图相关
-(void)setUpCollectionView
{
    ZLCollectionViewVerticalLayout *flowLayout = [[ZLCollectionViewVerticalLayout alloc] init];
    flowLayout.delegate = self;
    flowLayout.canDrag = NO;
    self.collectionView.collectionViewLayout = flowLayout;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.bounces = NO;
    self.collectionView.userInteractionEnabled = YES;
    self.collectionView.scrollEnabled = NO; // 让collectionView默认禁止滚动
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([RCSearchTagCell class]) bundle:nil] forCellWithReuseIdentifier:SearchTagCell];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([RCSearchTagHeader class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SearchTagHeader];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([RCCityToHouseSearchHeader class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CityToHouseSearchHeader];
}
#pragma mark -- UITextField代理
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (!self.offsetY) {
        self.offsetY = Y3;
    }
    
    // 如果点击时，shadowView的y坐标 在Y2 Y3的位置，
    if (self.offsetY > Y1) {
        // ============ 触发block =============
        if (self.didClickTextFieldBlock) {
            self.didClickTextFieldBlock();
        }
        return NO;
    }
    
    return YES;
}
#pragma mark -- 业务逻辑
-(void)didClickTextField:(DidClickTextFieldBlock)block
{
    self.didClickTextFieldBlock = block;
}
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
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString : UICollectionElementKindSectionHeader]){
        if (indexPath.section) {
            RCSearchTagHeader * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SearchTagHeader forIndexPath:indexPath];
            NSDictionary *dict = self.citys[indexPath.section];
            headerView.tabText.text = dict[@"tag"];
            headerView.locationBtn.hidden = indexPath.section;
            return headerView;
        }else{
            RCCityToHouseSearchHeader * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CityToHouseSearchHeader forIndexPath:indexPath];
            headerView.searchBar.delegate = self;
            self.searchHeader = headerView;
            return headerView;
        }
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section) {
        return CGSizeMake(HX_SCREEN_WIDTH, 44);
    }else{
        return CGSizeMake(HX_SCREEN_WIDTH, 100);
    }
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
