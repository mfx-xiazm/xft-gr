//
//  RCSearchResultHeader.h
//  XFT
//
//  Created by 夏增明 on 2019/11/22.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^moreClickedCall)(void);
@interface RCSearchResultHeader : UIView
@property (weak, nonatomic) IBOutlet UILabel *title_txt;
@property (weak, nonatomic) IBOutlet UILabel *more_txt;
/* 点击 */
@property(nonatomic,copy) moreClickedCall moreClickedCall;
@end

NS_ASSUME_NONNULL_END
