//
//  RCCustomAnnotationView.h
//  XFT
//
//  Created by 夏增明 on 2019/9/9.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "RCCustomCalloutView.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^callOutViewClicked)(void);
@interface RCCustomAnnotationView : MAAnnotationView
@property (nonatomic, readonly) RCCustomCalloutView *calloutView;
/* 被点击 */
@property(nonatomic,copy) callOutViewClicked callOutViewClicked;
@end

NS_ASSUME_NONNULL_END
