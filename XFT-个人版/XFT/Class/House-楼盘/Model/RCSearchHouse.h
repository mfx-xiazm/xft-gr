//
//  RCSearchHouse.h
//  XFT
//
//  Created by 夏增明 on 2019/11/22.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCSearchHouse : NSObject
@property (nonatomic, strong) NSString * uuid;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * price;
@property (nonatomic, strong) NSString * headPic;
@property (nonatomic, strong) NSString * mainHuxingName;
@property (nonatomic, strong) NSString * huxingName;
@property (nonatomic, strong) NSString * roomArea;
@property (nonatomic, strong) NSString * areaInterval;
@property (nonatomic, strong) NSString * commissionRules;
@property (nonatomic, strong) NSString * decorate;
@property (nonatomic, strong) NSString * collectionCount;
@property (nonatomic, strong) NSString * geoAreaName;
@property (nonatomic, strong) NSString * tag;
/* 头像 */
@property(nonatomic,strong) NSArray *headpicList;

@end

NS_ASSUME_NONNULL_END
