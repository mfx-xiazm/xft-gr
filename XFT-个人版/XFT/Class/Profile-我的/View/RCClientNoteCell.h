//
//  RCClientNoteCell.h
//  XFT
//
//  Created by 夏增明 on 2019/8/31.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RCMyClientNote;
@interface RCClientNoteCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *buttomLine;
@property (weak, nonatomic) IBOutlet UILabel *num;
@property (weak, nonatomic) IBOutlet UIImageView *tabImg;
@property (weak, nonatomic) IBOutlet UIView *bgView;
/* 轨迹 */
@property(nonatomic,strong) RCMyClientNote *note;
@end

NS_ASSUME_NONNULL_END
