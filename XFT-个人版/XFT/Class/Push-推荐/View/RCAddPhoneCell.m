//
//  RCAddPhoneCell.m
//  XFT
//
//  Created by 夏增明 on 2019/8/28.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCAddPhoneCell.h"
#import "RCReportTarget.h"
#import "UITextField+GYExpand.h"

@interface RCAddPhoneCell ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;

@end
@implementation RCAddPhoneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.phoneNum.delegate = self;
    hx_weakify(self);
    [self.phoneNum lengthLimit:^{
        hx_strongify(weakSelf);
        if ([strongSelf.phoneNum.text hasPrefix:@"1"]){//如果以”1“开头就限制11位
            if (strongSelf.phoneNum.text.length > 11) {
                strongSelf.phoneNum.text = [strongSelf.phoneNum.text substringToIndex:11];
            }
        }
    }];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    _phone.cusPhone = [textField hasText]?textField.text:@"";
}
-(void)setPhone:(RCReportPhone *)phone
{
    _phone = phone;
    self.phoneNum.text = _phone.cusPhone;
}
- (IBAction)cutBtnClicked:(UIButton *)sender {
    if (self.cutBtnCall) {
        self.cutBtnCall();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
