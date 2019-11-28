//
//  RCHouseList.h
//  XFT
//
//  Created by 夏增明 on 2019/11/21.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCHouseList : NSObject
@property (nonatomic, strong) NSString * uuid;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * headpic;
@property (nonatomic, strong) NSString * geoAreaName;
@property (nonatomic, strong) NSString * price;
@property (nonatomic, strong) NSString * tag;
@property (nonatomic, strong) NSString * commissionRules;
@property (nonatomic, strong) NSString * watchCount;
@property (nonatomic, strong) NSString * huXingName;
@property (nonatomic, strong) NSString * roomArea;
@property (nonatomic, strong) NSString * buldType;
@property (nonatomic, assign) CGFloat  longitude;
@property (nonatomic, assign) CGFloat  dimension;
@property (nonatomic, strong) NSString * vrStatus;
@property (nonatomic, strong) NSString * buldTypeIsShows;
@property (nonatomic, strong) NSArray * headpicList;

/* 是否选中 */
@property(nonatomic,assign) BOOL isSelected;
@end

NS_ASSUME_NONNULL_END
