//
//  RCCustomAnnotation.h
//  XFT
//
//  Created by 夏增明 on 2019/9/10.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QMapKit/QMapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCCustomAnnotation : NSObject <QAnnotation>///遵守协议
/**
 *  @brief  经纬度
 */
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

/**
 *  @brief  标题
 */
@property (copy) NSString *title;

/**
 *  @brief  副标题
 */
@property (copy) NSString *subtitle;

///annotation图片
@property (nonatomic, strong) UIImage *image;

///annotation其他信息
@property (nonatomic, copy) NSString *otherMsg;

///annotation的承载内容的id
@property (nonatomic, copy) NSString *contentId;//可以是区域id 也可以是小区id

@end

NS_ASSUME_NONNULL_END
