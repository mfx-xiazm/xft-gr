//
//  RCMyCollectNews.h
//  XFT
//
//  Created by 夏增明 on 2019/11/25.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCMyCollectNews : NSObject
@property (nonatomic, strong) NSString * uuid;
@property (nonatomic, strong) NSString * proUuid;
@property (nonatomic, strong) NSString * proName;
@property (nonatomic, strong) NSString * clickNum;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * publishTime;
@property (nonatomic, strong) NSString * headPic;
@property (nonatomic, strong) NSString * context;
@property (nonatomic, strong) NSString * viewType;
@end

NS_ASSUME_NONNULL_END
