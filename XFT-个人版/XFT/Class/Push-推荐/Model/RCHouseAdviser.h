//
//  RCHouseAdviser.h
//  XFT
//
//  Created by 夏增明 on 2019/11/27.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCHouseAdviser : NSObject
@property(nonatomic,copy) NSString *uuid;
@property(nonatomic,copy) NSString *accUuid;
@property(nonatomic,copy) NSString *accName;
@property(nonatomic,copy) NSString *regPhone;
@property(nonatomic,copy) NSString *proUuid;
@property(nonatomic,copy) NSString *proName;
@property(nonatomic,copy) NSString *teamUuid;
@property(nonatomic,copy) NSString *teamName;
@property(nonatomic,copy) NSString *groupUuid;
@property(nonatomic,copy) NSString *groupName;
@property(nonatomic,copy) NSString *type;
@property(nonatomic,copy) NSString *createTime;
@property(nonatomic,copy) NSString *editTime;
@property(nonatomic,copy) NSString *headpic;
/* 是否选中 */
@property(nonatomic,assign) BOOL isSelected;
/* 无职业顾问 */
@property(nonatomic,assign) BOOL isNotAdviser;
@end

NS_ASSUME_NONNULL_END
