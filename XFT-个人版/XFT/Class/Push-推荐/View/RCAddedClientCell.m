//
//  RCAddedClientCell.m
//  XFT
//
//  Created by 夏增明 on 2019/9/7.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCAddedClientCell.h"
#import "RCReportTarget.h"

@interface RCAddedClientCell ()
@property (weak, nonatomic) IBOutlet UILabel *name;

@end
@implementation RCAddedClientCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setClient:(RCReportTarget *)client
{
    _client = client;
    self.name.text = [NSString stringWithFormat:@"%@-%@",_client.cusName,_client.cusPhone];
}
- (IBAction)cutClicked:(UIButton *)sender {
    if (self.cutBtnCall) {
        self.cutBtnCall();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
