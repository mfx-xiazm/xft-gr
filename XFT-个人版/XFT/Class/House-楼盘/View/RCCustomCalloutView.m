//
//  RCCustomCalloutView.m
//  XFT
//
//  Created by 夏增明 on 2019/9/9.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCCustomCalloutView.h"

#define kPortraitMargin     10
#define PortraitMargin     10

#define kTitleWidth         160
#define kTitleHeight        20
#define kArrorHeight        20
#define ArrorHeight        10

@interface RCCustomCalloutView ()
@property (nonatomic, strong) UIImageView *portraitView;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *areaLabel;

@end
@implementation RCCustomCalloutView

- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

- (void)setSubtitle:(NSString *)subtitle
{
    self.subtitleLabel.text = subtitle;
}

- (void)setImage:(UIImage *)image
{
    self.portraitView.image = image;
}
- (void)setArea:(NSString *)area{
    self.areaLabel.text = area;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    // 添加图片，即定位小图标的图片
//    self.portraitView = [[UIImageView alloc] initWithFrame:CGRectMake(kPortraitMargin-5, 40+PortraitMargin, kArrorHeight, kArrorHeight)];
//    [self addSubview:self.portraitView];
    
    // 添加标题，即商户名
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, PortraitMargin, kTitleWidth, kTitleHeight)];
    self.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = @"商户名";
    [self addSubview:self.titleLabel];
    
    // 添加副标题，即商户地址
    self.subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kTitleHeight+PortraitMargin, kTitleWidth, kTitleHeight)];
    self.subtitleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    self.subtitleLabel.textColor = [UIColor redColor];
    self.subtitleLabel.textAlignment = NSTextAlignmentCenter;
    self.subtitleLabel.text = @"副标题";
    [self addSubview:self.subtitleLabel];
    
    //添加距离，即距离中心点的距离
    self.areaLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kTitleHeight*2+PortraitMargin, kTitleWidth, kTitleHeight)];
    self.areaLabel.font = [UIFont systemFontOfSize:12];
    self.areaLabel.textColor = [UIColor lightGrayColor];
    self.areaLabel.textAlignment = NSTextAlignmentCenter;
    self.areaLabel.text = @"78-128m";
    [self addSubview:self.areaLabel];
    
    //加油btn
    UIButton *clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    clickBtn.frame = self.bounds;
    [self addSubview:clickBtn];
    [clickBtn addTarget:self action:@selector(outViewClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.clickBtn = clickBtn;
}
- (void)outViewClicked:(UIButton *)btn{

    if ([self.delegate respondsToSelector:@selector(callOutViewDidClicked:)]) {
        [self.delegate callOutViewDidClicked:self];
    }
}
#pragma mark - draw rect

- (void)drawRect:(CGRect)rect{
    [self drawInContext:UIGraphicsGetCurrentContext()];
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOpacity = 0.2;
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
}

- (void)drawInContext:(CGContextRef)context{
    
    CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    [self getDrawPath:context];
    CGContextFillPath(context);
    
}

- (void)getDrawPath:(CGContextRef)context{
    
    CGRect rrect = self.bounds;
    CGFloat radius = 6.0;
    CGFloat minx = CGRectGetMinX(rrect),
    midx = CGRectGetMidX(rrect),
    maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect),
    maxy = CGRectGetMaxY(rrect)-ArrorHeight;
    
    CGContextMoveToPoint(context, midx+ArrorHeight, maxy);
    CGContextAddLineToPoint(context,midx, maxy+ArrorHeight);
    CGContextAddLineToPoint(context,midx-ArrorHeight, maxy);
    
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextClosePath(context);
}
@end
