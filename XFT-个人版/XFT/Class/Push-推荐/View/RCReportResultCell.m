//
//  RCReportResultCell.m
//  XFT
//
//  Created by 夏增明 on 2019/9/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCReportResultCell.h"
#import "RCReportTarget.h"

@interface RCReportResultCell ()
@property (weak, nonatomic) IBOutlet UILabel *anme;
@property (weak, nonatomic) IBOutlet UILabel *mag;

@end
@implementation RCReportResultCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setPerson:(RCReportTarget *)person
{
    _person = person;
    [self.anme setFontAndColorAttributedText:[NSString stringWithFormat:@"%@-%@\n推荐项目：%@",_person.cusName,_person.cusPhone,_person.proName] andChangeStr:[NSString stringWithFormat:@"推荐项目：%@",_person.proName] andColor:UIColorFromRGB(0x666666) andFont:[UIFont systemFontOfSize:13]];
    //self.anme.text = [NSString stringWithFormat:@"%@-%@\n推荐项目：%@",_person.cusName,_person.cusPhone,_person.proName];
    if (self.isSuccess) {
        self.mag.text = @"";
    }else{
        self.mag.text = [NSString stringWithFormat:@"原因：%@",_person.msg];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
