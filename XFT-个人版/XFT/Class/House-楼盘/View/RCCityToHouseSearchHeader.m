//
//  RCCityToHouseSearchHeader.m
//  XFT
//
//  Created by 夏增明 on 2019/8/31.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCCityToHouseSearchHeader.h"

@interface RCCityToHouseSearchHeader ()
@property (weak, nonatomic) IBOutlet UIView *searchView;

@end
@implementation RCCityToHouseSearchHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.searchBar = [[HXSearchBar alloc] initWithFrame:self.searchView.bounds];
    self.searchBar.backgroundColor = UIColorFromRGB(0xf5f5f5);
    self.searchBar.layer.cornerRadius = 36/2.f;
    self.searchBar.layer.masksToBounds = YES;
    [self.searchView addSubview:self.searchBar];
    hx_weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.searchBar.frame = weakSelf.searchView.bounds;
    });
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
}
@end
