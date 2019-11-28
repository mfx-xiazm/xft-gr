//
//  RCHouseHeader.m
//  XFT
//
//  Created by 夏增明 on 2019/8/27.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCHouseHeader.h"
#import "RCBannerCell.h"
#import <TYCyclePagerView/TYCyclePagerView.h>
#import <TYCyclePagerView/TYPageControl.h>
#import "LMJHorizontalScrollText.h"
#import "RCHouseBanner.h"
#import "RCHouseNotice.h"

@interface RCHouseHeader ()<TYCyclePagerViewDataSource, TYCyclePagerViewDelegate>
@property (weak, nonatomic) IBOutlet TYCyclePagerView *cycleView;
/** page */
@property (nonatomic,strong) TYPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIView *scrollTextView;
@property (strong, nonatomic) LMJHorizontalScrollText *scrollText;

@end
@implementation RCHouseHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.cycleView.isInfiniteLoop = YES;
    self.cycleView.autoScrollInterval = 3.0;
    self.cycleView.dataSource = self;
    self.cycleView.delegate = self;
    // registerClass or registerNib
    [self.cycleView registerNib:[UINib nibWithNibName:NSStringFromClass([RCBannerCell class]) bundle:nil] forCellWithReuseIdentifier:@"BannerCell"];
    
    TYPageControl *pageControl = [[TYPageControl alloc] init];
    pageControl.hidesForSinglePage = YES;
    pageControl.numberOfPages = 3;
    pageControl.currentPageIndicatorSize = CGSizeMake(12, 6);
    pageControl.pageIndicatorSize = CGSizeMake(6, 6);
    pageControl.pageIndicatorImage = [UIImage imageNamed:@"dot_h"];
    pageControl.currentPageIndicatorImage = [UIImage imageNamed:@"dot_l"];
    pageControl.frame = CGRectMake(0, CGRectGetHeight(self.cycleView.frame) - 20, CGRectGetWidth(self.cycleView.frame), 15);
    self.pageControl = pageControl;
    [self.cycleView addSubview:pageControl];
    
    self.scrollText = [[LMJHorizontalScrollText alloc] initWithFrame:self.scrollTextView.bounds];
    self.scrollText.layer.cornerRadius = 2;
    self.scrollText.layer.masksToBounds = YES;
    self.scrollText.backgroundColor    = [UIColor whiteColor];
    self.scrollText.textColor          = [UIColor lightGrayColor];
    self.scrollText.textFont           = [UIFont systemFontOfSize:15];
    self.scrollText.speed              = 0.07;
    
    [self.scrollTextView addSubview:self.scrollText];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.pageControl.frame = CGRectMake(0, CGRectGetHeight(self.cycleView.frame) - 20, CGRectGetWidth(self.cycleView.frame), 15);
    hx_weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.scrollText.frame = weakSelf.scrollTextView.bounds;
    });
}
-(void)setBanners:(NSArray *)banners
{
    _banners = banners;
    self.pageControl.numberOfPages = _banners.count;
    [self.cycleView reloadData];
}
-(void)setNotices:(NSArray *)notices
{
    _notices = notices;
    if (_notices && _notices.count) {
        RCHouseNotice *notice = _notices.firstObject;
        self.scrollText.text = notice.title;
    }else{
        self.scrollText.text = @"";
    }
    self.scrollText.moveDirection      = LMJTextScrollMoveLeft;
    self.scrollText.moveMode           = LMJTextScrollContinuous;
    [self.scrollText move];
}
- (IBAction)noticeClicked:(UIButton *)sender {
    if (self.houseHeaderBtnClicked) {
        self.houseHeaderBtnClicked(0,0);
    }
}

#pragma mark -- TYCyclePagerView代理
- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    return _banners.count;
}

- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    RCBannerCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"BannerCell" forIndex:index];
    cell.contentImg.layer.cornerRadius = 6.f;
    cell.contentImg.layer.masksToBounds = YES;
    RCHouseBanner *banner = _banners[index];
    cell.banner = banner;
    return cell;
}

- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView {
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc]init];
    layout.itemSize = CGSizeMake(HX_SCREEN_WIDTH-30.f, CGRectGetHeight(pageView.frame));
    layout.itemSpacing = 15.f;
    layout.itemHorizontalCenter = YES;
    return layout;
}

- (void)pagerView:(TYCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    _pageControl.currentPage = toIndex;
    //[_pageControl setCurrentPage:newIndex animate:YES];
}

- (void)pagerView:(TYCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index
{
    if (self.houseHeaderBtnClicked) {
        self.houseHeaderBtnClicked(1,index);
    }
}
@end
