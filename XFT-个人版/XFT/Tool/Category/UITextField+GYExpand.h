//
//  UITextField+GYExpand.h
//  GY
//
//  Created by 夏增明 on 2019/11/13.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^LimitBlock)(void);

@interface UITextField (GYExpand)

@property (nonatomic , copy)LimitBlock limitBlock;

- (void)lengthLimit:(void (^)(void))limit;

@end

NS_ASSUME_NONNULL_END
