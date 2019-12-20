//
//  RCShowPicVC.m
//  XFT
//
//  Created by 夏增明 on 2019/12/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCShowPicVC.h"
#import "RCShowPicCell.h"
#import <ZLCollectionViewVerticalLayout.h>
#import "RCSearchTagHeader.h"
#import "RCHouseDetailTopCycle.h"
#import "RCHousePicInfo.h"
#import "RCShowPic.h"
#import "RCVideoFullScreenVC.h"
#import "RCWebContentVC.h"
#import <ZLPhotoActionSheet.h>

static NSString *const ShowPicCell = @"ShowPicCell";
static NSString *const SearchTagHeader = @"SearchTagHeader";

@interface RCShowPicVC ()<UICollectionViewDelegate,UICollectionViewDataSource,ZLCollectionViewBaseFlowLayoutDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
/* 处理过的图片数组 */
@property(nonatomic,strong) NSMutableArray *showResult;
@end

@implementation RCShowPicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"楼盘图片"];
    [self setUpCollectionView];
    
    NSMutableArray *handledPics = [NSMutableArray arrayWithArray:self.housePics];
    // 图片类别: 0:封面图 1:封面图 2:规划图 3:效果图 4:实景图 5:配套图 6:户型图 7:样板间图 8:视频 9:VR'
    self.showResult = [NSMutableArray array];
    NSArray *types = @[@"9",@"8",@"2",@"3",@"4",@"5",@"6",@"7"];
    for (NSString *type in types) {
        RCShowPic *showPic = [RCShowPic new];
        showPic.type = type;
        NSArray *tmpArray = [handledPics filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"type = %@",type]];
        showPic.pics = [NSArray arrayWithArray:tmpArray];
        [self.showResult addObject:showPic];
        
        [handledPics removeObjectsInArray:tmpArray];
    }
    RCShowPic *showPic = [RCShowPic new];
    showPic.type = @"1";
    showPic.pics = [NSArray arrayWithArray:handledPics];
    [self.showResult insertObject:showPic atIndex:2];
    
    [self.collectionView reloadData];
}
-(void)setUpCollectionView
{
    ZLCollectionViewVerticalLayout *flowLayout = [[ZLCollectionViewVerticalLayout alloc] init];
    flowLayout.delegate = self;
    flowLayout.canDrag = NO;
    self.collectionView.collectionViewLayout = flowLayout;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([RCShowPicCell class]) bundle:nil] forCellWithReuseIdentifier:ShowPicCell];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([RCSearchTagHeader class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SearchTagHeader];
}
#pragma mark -- UICollectionView 数据源和代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.showResult.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    RCShowPic *showPic = self.showResult[section];
    return showPic.pics.count;
}
- (ZLLayoutType)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section {
    return ColumnLayout;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout*)collectionViewLayout columnCountOfSection:(NSInteger)section
{
    return 3;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RCShowPicCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:ShowPicCell forIndexPath:indexPath];
    RCShowPic *showPic = self.showResult[indexPath.section];
    RCHouseDetailTopCycle *cycle = showPic.pics[indexPath.row];
    cell.cycle = cycle;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    RCShowPic *showPic = self.showResult[indexPath.section];
    RCHouseDetailTopCycle *cycle = showPic.pics[indexPath.row];

    if ([cycle.type isEqualToString:@"9"]) {
        RCWebContentVC *wvc = [RCWebContentVC new];
        wvc.url = cycle.url;
        wvc.navTitle = @"全景看房";
        [self.navigationController pushViewController:wvc animated:YES];
    }else if ([cycle.type isEqualToString:@"8"]) {
        RCVideoFullScreenVC *fvc = [RCVideoFullScreenVC new];
        fvc.url = cycle.url;
        [self.navigationController pushViewController:fvc animated:NO];
    }else{
        NSMutableArray *items = [NSMutableArray array];
        for (RCHouseDetailTopCycle *resultCycle in showPic.pics) {
            NSMutableDictionary *temp = [NSMutableDictionary dictionary];
            temp[@"ZLPreviewPhotoObj"] = [NSURL URLWithString:resultCycle.url];
            temp[@"ZLPreviewPhotoTyp"] = @(ZLPreviewPhotoTypeURLImage);
            [items addObject:temp];
        }
                
        ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
        actionSheet.configuration.navBarColor = [UIColor clearColor];
        actionSheet.sender = self;
        [actionSheet previewPhotos:items index:indexPath.row hideToolBar:YES complete:^(NSArray * _Nonnull photos) {
            
        }];
    }
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString : UICollectionElementKindSectionHeader]){
        RCSearchTagHeader * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SearchTagHeader forIndexPath:indexPath];
        headerView.locationBtn.hidden = YES;
        RCShowPic *showPic = self.showResult[indexPath.section];
        if (showPic.pics && showPic.pics.count) {
            /**1:封面图 2:规划图 3:效果图 4:实景图 5:配套图 6:户型图 7:样板间图 8:视频 9:VR*/
            if ([showPic.type isEqualToString:@"1"]) {
                headerView.tabText.text = @"封面图";
            }else if ([showPic.type isEqualToString:@"2"]) {
                headerView.tabText.text = @"规划图";
            }else if ([showPic.type isEqualToString:@"3"]) {
                headerView.tabText.text = @"效果图";
            }else if ([showPic.type isEqualToString:@"4"]) {
                headerView.tabText.text = @"实景图";
            }else if ([showPic.type isEqualToString:@"5"]) {
                headerView.tabText.text = @"配套图";
            }else if ([showPic.type isEqualToString:@"6"]) {
                headerView.tabText.text = @"户型图";
            }else if ([showPic.type isEqualToString:@"7"]) {
                headerView.tabText.text = @"样板间图";
            }else if ([showPic.type isEqualToString:@"8"]) {
                headerView.tabText.text = @"视频";
            }else{
                headerView.tabText.text = @"VR";
            }
            return headerView;
        }else{
            return nil;
        }
        
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    RCShowPic *showPic = self.showResult[section];
    if (showPic.pics && showPic.pics.count) {
        return CGSizeMake(collectionView.frame.size.width, 44);
    }else{
        return CGSizeZero;
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (HX_SCREEN_WIDTH-10.f*4)/3.0;
    CGFloat height = width*3/4.0;
    return CGSizeMake(width, height);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10.f;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return  UIEdgeInsetsMake(10, 10, 10, 10);
}

@end
