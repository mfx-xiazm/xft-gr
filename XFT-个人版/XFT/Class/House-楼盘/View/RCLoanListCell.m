//
//  RCLoanListCell.m
//  XFT
//
//  Created by 夏增明 on 2019/11/27.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCLoanListCell.h"
#import "RCHouseLoan.h"

@interface RCLoanListCell ()
@property (weak, nonatomic) IBOutlet UIView *huIXingView;
@property (weak, nonatomic) IBOutlet UILabel *huXingName;
@property (weak, nonatomic) IBOutlet UILabel *total;
@property (weak, nonatomic) IBOutlet UILabel *buidArea;
@property (weak, nonatomic) IBOutlet UILabel *loanType;

@property (weak, nonatomic) IBOutlet UIView *singleView;
@property (weak, nonatomic) IBOutlet UILabel *total1;
@property (weak, nonatomic) IBOutlet UILabel *loanType1;

@end
@implementation RCLoanListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setLoan:(RCHouseLoan *)loan
{
    _loan = loan;
    if (_loan.hxUuid  && _loan.hxUuid.length) {
        self.huIXingView.hidden = NO;
        self.singleView.hidden = YES;
        self.huXingName.text = [NSString stringWithFormat:@"%@%@",_loan.proName,_loan.hxName];
        if ([_loan.loanType isEqualToString:@"1"]) {// 商业贷款
            [self.total setColorAttributedText:[NSString stringWithFormat:@"合同总价：%@万",_loan.totalPrice] andChangeStr:[NSString stringWithFormat:@"%@万",_loan.totalPrice] andColor:[UIColor blackColor]];
            [self.loanType setColorAttributedText:@"贷款方式：商业贷款" andChangeStr:@"商业贷款" andColor:[UIColor blackColor]];
        }else if ([_loan.loanType isEqualToString:@"2"]) {// 公积金贷
            [self.total setColorAttributedText:[NSString stringWithFormat:@"合同总价：%@万",_loan.totalPrice] andChangeStr:[NSString stringWithFormat:@"%@万",_loan.totalPrice] andColor:[UIColor blackColor]];
            [self.loanType setColorAttributedText:@"贷款方式：公积金贷款" andChangeStr:@"公积金贷款" andColor:[UIColor blackColor]];
        }else{
            [self.total setColorAttributedText:[NSString stringWithFormat:@"贷款总价：%@万",_loan.totalPrice] andChangeStr:[NSString stringWithFormat:@"%@万",_loan.totalPrice] andColor:[UIColor blackColor]];
            [self.loanType setColorAttributedText:@"贷款方式：混合贷款" andChangeStr:@"混合贷款" andColor:[UIColor blackColor]];
        }
        [self.buidArea setColorAttributedText:[NSString stringWithFormat:@"建筑面积：%@㎡",_loan.buldArea] andChangeStr:[NSString stringWithFormat:@"%@㎡",_loan.buldArea] andColor:[UIColor blackColor]];
    }else{
        self.huIXingView.hidden = YES;
        self.singleView.hidden = NO;
        
        if ([_loan.loanType isEqualToString:@"1"]) {// 商业贷款
            [self.total1 setColorAttributedText:[NSString stringWithFormat:@"合同总价：%@万",_loan.totalPrice] andChangeStr:[NSString stringWithFormat:@"%@万",_loan.totalPrice] andColor:[UIColor blackColor]];
            [self.loanType1 setColorAttributedText:@"贷款方式：商业贷款" andChangeStr:@"商业贷款" andColor:[UIColor blackColor]];
        }else if ([_loan.loanType isEqualToString:@"2"]) {// 公积金贷
            [self.total1 setColorAttributedText:[NSString stringWithFormat:@"合同总价：%@万",_loan.totalPrice] andChangeStr:[NSString stringWithFormat:@"%@万",_loan.totalPrice] andColor:[UIColor blackColor]];
            [self.loanType1 setColorAttributedText:@"贷款方式：公积金贷款" andChangeStr:@"公积金贷款" andColor:[UIColor blackColor]];
        }else{
            [self.total1 setColorAttributedText:[NSString stringWithFormat:@"贷款总价：%@万",_loan.totalPrice] andChangeStr:[NSString stringWithFormat:@"%@万",_loan.totalPrice] andColor:[UIColor blackColor]];
            [self.loanType1 setColorAttributedText:@"贷款方式：混合贷款" andChangeStr:@"混合贷款" andColor:[UIColor blackColor]];
        }
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
