//
//  RCReportTarget.h
//  XFT
//
//  Created by 夏增明 on 2019/11/27.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class RCReportPhone;
@interface RCReportTarget : NSObject
/* 客户姓名 */
@property(nonatomic,copy) NSString *cusName;
/* 客户电话 */
@property(nonatomic,copy) NSString *cusPhone;
/* 更多客户电话 */
@property(nonatomic,strong) NSMutableArray<RCReportPhone *> *morePhones;
/* 预约看房日期 */
@property(nonatomic,copy) NSString *appointDate;
/* 置业顾问 */
@property(nonatomic,copy) NSString *sealMan;
/* 物业类型 */
@property(nonatomic,copy) NSString *wuyeType;
/* 客户备注 */
@property(nonatomic,copy) NSString *remark;

@property(nonatomic,copy) NSString *baoBeiState;
@property(nonatomic,copy) NSString *msg;
@property(nonatomic,copy) NSString *proName;
@property(nonatomic,copy) NSString *proUuid;
@end

@interface RCReportPhone : NSObject
/* 客户电话 */
@property(nonatomic,copy) NSString *cusPhone;
@end

NS_ASSUME_NONNULL_END
