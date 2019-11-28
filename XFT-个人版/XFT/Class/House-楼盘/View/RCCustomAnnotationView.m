//
//  RCCustomAnnotationView.m
//  XFT
//
//  Created by 夏增明 on 2019/9/9.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCCustomAnnotationView.h"
#import "RCCustomAnnotation.h"

#define kCalloutWidth       160.0
#define kCalloutHeight      90.0

@interface RCCustomAnnotationView ()<RCCustomCalloutViewDelegate>
@property (nonatomic, strong, readwrite) RCCustomCalloutView *calloutView;
@end

@implementation RCCustomAnnotationView

// 重写选中方法setSelected。选中时新建并添加calloutView，传入数据；非选中时删除calloutView。
- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    
    if (self.selected == selected){
        return;
    }
    
    if (selected){
        if (self.calloutView == nil){
            self.calloutView = [[RCCustomCalloutView alloc] initWithFrame:CGRectMake(0, 0, kCalloutWidth, kCalloutHeight)];
            self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,-CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
            self.calloutView.delegate = self;
        }
        self.calloutView.image = [UIImage imageNamed:@"icon_logo"];
        RCCustomAnnotation *annotation = (RCCustomAnnotation *)self.annotation;
        self.calloutView.title = annotation.title;
        self.calloutView.subtitle = annotation.subtitle;
        self.calloutView.area = annotation.otherMsg;
        [self addSubview:self.calloutView];
    }else{
        [self.calloutView removeFromSuperview];
    }
    
    [super setSelected:selected animated:animated];
}
-(void)callOutViewDidClicked:(RCCustomCalloutView *)outView
{
    if (self.callOutViewClicked) {
        self.callOutViewClicked();
    }
}
/**
 以下两个方法处理弹框的点击响应范围
 */

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    UIView *view = [super hitTest:point withEvent:event];
//    if (view == nil) {
//        CGPoint tempoint = [self.calloutView.btn convertPoint:point fromView:self];
//        if (CGRectContainsPoint(self.calloutView.btn.bounds, tempoint)){
//            view = self.calloutView.btn;
//        }
//    }
//    return view;
//}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL inside = [super pointInside:point withEvent:event];
    if (!inside && self.selected) {
        inside = [self.calloutView pointInside:[self convertPoint:point toView:self.calloutView] withEvent:event];
    }
    
    return inside;
}
@end
