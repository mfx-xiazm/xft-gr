//
//  JXHouseCategoryView.m
//  XFT
//
//  Created by 夏增明 on 2019/9/6.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCHouseCategoryView.h"
#import <JXCategoryView.h>

@interface RCHouseCategoryView ()<JXCategoryViewDelegate>
@property (weak, nonatomic) IBOutlet JXCategoryTitleView *categoryView;

@end
@implementation RCHouseCategoryView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    _categoryView.backgroundColor = [UIColor whiteColor];
    _categoryView.averageCellSpacingEnabled = NO;
    _categoryView.titleLabelZoomEnabled = YES;
    _categoryView.titles = @[@"热售项目", @"文旅项目"];
    _categoryView.titleFont = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    _categoryView.cellSpacing = 45.f;
    _categoryView.contentEdgeInsetLeft = 20.f;
    _categoryView.titleColor = UIColorFromRGB(0x666666);
    _categoryView.titleSelectedColor = UIColorFromRGB(0x333333);
    _categoryView.delegate = self;
    
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.verticalMargin = 18.f;
    lineView.indicatorCornerRadius = 0.f;
    lineView.indicatorHeight = 6.f;
    lineView.indicatorWidthIncrement = 8.f;
    lineView.indicatorColor = HXRGBAColor(255, 159, 8, 0.6);
    _categoryView.indicators = @[lineView];
}
-(void)setScrollView:(UIScrollView *)scrollView
{
    _scrollView = scrollView;
    _categoryView.contentScrollView = self.scrollView;
}
- (IBAction)mapBtnClicked:(id)sender {
    if (self.mapToHouseCall) {
        self.mapToHouseCall();
    }
}
#pragma mark - JXCategoryViewDelegate
// 滚动和点击选中
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index
{
    if (self.childVCs.count <= index) {return;}
    
    UIViewController *targetViewController = self.childVCs[index];
    // 如果已经加载过，就不再加载
    if ([targetViewController isViewLoaded]) return;
    
    targetViewController.view.frame = CGRectMake(HX_SCREEN_WIDTH * index, 0, HX_SCREEN_WIDTH, self.scrollView.hxn_height);
    
    [self.scrollView addSubview:targetViewController.view];
}
@end
