//
//  RCClientCount.h
//  XFT
//
//  Created by 夏增明 on 2019/11/26.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCClientCount : NSObject
/** 重要客户数量 */
@property (nonatomic, strong) NSString * importReport;
/** 已发展数量 */
@property (nonatomic, strong) NSString * developReport;
/** 已报备数量 */
@property (nonatomic, strong) NSString * hasReport;
/** 已到访数量 */
@property (nonatomic, strong) NSString * hasVisited;
/** 已认筹数量 */
@property (nonatomic, strong) NSString * hasRecognition;
/** 已认购数量 */
@property (nonatomic, strong) NSString * hasBuy;
/** 已签约数量 */
@property (nonatomic, strong) NSString * hasSign;
/** 已退房数量 */
@property (nonatomic, strong) NSString * hasCheckOut;
/** 已失效数量 */
@property (nonatomic, strong) NSString * hasInvalid;

@end

NS_ASSUME_NONNULL_END
