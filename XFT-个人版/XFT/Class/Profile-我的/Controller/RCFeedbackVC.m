//
//  RCFeedbackVC.m
//  XFT
//
//  Created by 夏增明 on 2019/8/29.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCFeedbackVC.h"
#import "HXPlaceholderTextView.h"
#import "HCSStarRatingView.h"

@interface RCFeedbackVC ()
@property (weak, nonatomic) IBOutlet HXPlaceholderTextView *remark;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *starView;

@end

@implementation RCFeedbackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"意见反馈"];
    self.remark.placeholder = @"请输入意见和建议";
}
- (IBAction)hiddenSubmitClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
}

@end
