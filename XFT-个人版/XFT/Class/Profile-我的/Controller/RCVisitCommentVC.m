//
//  RCVisitCommentVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/7.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCVisitCommentVC.h"
#import "HXPlaceholderTextView.h"

@interface RCVisitCommentVC ()
@property (weak, nonatomic) IBOutlet HXPlaceholderTextView *remark;

@end

@implementation RCVisitCommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"回访调查表"];
    self.remark.placeholder = @"请输入意见和建议";
}


@end
