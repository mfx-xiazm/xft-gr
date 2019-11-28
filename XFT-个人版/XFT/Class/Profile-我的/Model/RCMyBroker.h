//
//  RCMyBroker.h
//  XFT
//
//  Created by 夏增明 on 2019/11/25.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCMyBroker : NSObject
@property (nonatomic, strong) NSString * uuid;
@property (nonatomic, strong) NSString * accRole;
@property (nonatomic, strong) NSString * creaTime;
@property (nonatomic, strong) NSString * accPhone;
@property (nonatomic, strong) NSString * reportNum;
@property (nonatomic, strong) NSString * headPic;
@property (nonatomic, strong) NSString * name;
@end

NS_ASSUME_NONNULL_END
