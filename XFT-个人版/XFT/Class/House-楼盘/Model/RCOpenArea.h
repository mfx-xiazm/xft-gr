//
//  RCOpenArea.h
//  XFT
//
//  Created by 夏增明 on 2019/11/21.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class RCOpenCity;
@interface RCOpenArea : NSObject
@property (nonatomic, strong) NSString * aname;
@property (nonatomic, strong) NSArray<RCOpenCity *> * list;
@end

@interface RCOpenCity : NSObject
@property (nonatomic, strong) NSString * aid;
@property (nonatomic, strong) NSString * aname;
@property (nonatomic, strong) NSString * cid;
@property (nonatomic, strong) NSString * cname;
@property (nonatomic, strong) NSString * num;
@end

NS_ASSUME_NONNULL_END
