//
//  RCShowPic.h
//  XFT
//
//  Created by 夏增明 on 2019/12/3.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCShowPic : NSObject
/* 类型 图片类别: 1:封面图 2:规划图 3:效果图 4:实景图 5:配套图 6:户型图 7:样板间图 8:视频 9:VR' */
@property(nonatomic,copy) NSString *type;
/* 图片数组 */
@property(nonatomic,strong) NSArray *pics;
@end

NS_ASSUME_NONNULL_END
