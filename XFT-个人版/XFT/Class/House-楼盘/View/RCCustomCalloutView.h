//
//  RCCustomCalloutView.h
//  XFT
//
//  Created by 夏增明 on 2019/9/9.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class RCCustomCalloutView;
@protocol RCCustomCalloutViewDelegate <NSObject>

-(void)callOutViewDidClicked:(RCCustomCalloutView *)outView;//被点击

@end
@interface RCCustomCalloutView : UIView
@property (nonatomic, strong) UIImage *image; //商户图
@property (nonatomic, copy) NSString *title; //商户名
@property (nonatomic, copy) NSString *subtitle; //地址
@property(nonatomic,copy) NSString *area;
@property(nonatomic,copy) NSString *contentId;
@property (nonatomic, strong) UIButton *clickBtn;
@property(nonatomic,weak) id<RCCustomCalloutViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
