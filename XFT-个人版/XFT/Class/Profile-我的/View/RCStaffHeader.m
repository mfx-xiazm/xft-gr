//
//  RCStaffHeader.m
//  XFT
//
//  Created by 夏增明 on 2019/8/29.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCStaffHeader.h"

@interface RCStaffHeader ()
@property (weak, nonatomic) IBOutlet UILabel *totalSalary;
@property (weak, nonatomic) IBOutlet UILabel *canCashSalary;
@property (weak, nonatomic) IBOutlet UILabel *cashIngSalary;

@end
@implementation RCStaffHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
}
- (IBAction)hiddenSalaryClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.isSelected) {
        self.totalSalary.text = @"5900";
        self.canCashSalary.text = @"3833";
        self.cashIngSalary.text = @"1990";
    }else{
        self.totalSalary.text = @"***";
        self.canCashSalary.text = @"***";
        self.cashIngSalary.text = @"***";
    }
}

- (IBAction)staffBtnClicked:(UIButton *)sender {
    if (self.staffHeaderBtnCall) {
        self.staffHeaderBtnCall(sender.tag);
    }
}

@end
