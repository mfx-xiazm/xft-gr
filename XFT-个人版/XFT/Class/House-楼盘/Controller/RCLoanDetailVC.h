//
//  RCLoanDetailVC.h
//  XFT
//
//  Created by 夏增明 on 2019/8/30.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCLoanDetailVC : HXBaseViewController
/* 贷款方式 (1:商业,2:基金,3:混合) */
@property(nonatomic,assign) NSInteger loanType;

/** 商业贷款 */
@property (copy, nonatomic)  NSString *b_total;
@property (copy, nonatomic)  NSString *b_scale;
@property (copy, nonatomic)  NSString *b_year;
@property(nonatomic,assign) NSInteger b_yearNum;//还款年限
@property (copy, nonatomic)  NSString *b_rate;
@property (copy, nonatomic)  NSString *b_type;
@property(nonatomic,assign) NSInteger b_typeNum;//还款方式
/** 公积金贷款 */
@property (copy, nonatomic)  NSString *f_total;
@property (copy, nonatomic)  NSString *f_scale;
@property (copy, nonatomic)  NSString *f_year;
@property(nonatomic,assign) NSInteger f_yearNum;//还款年限
@property (copy, nonatomic)  NSString *f_rate;
@property (copy, nonatomic)  NSString *f_type;
@property(nonatomic,assign) NSInteger f_typeNum;//还款方式
/** 混合贷款 */
@property (copy, nonatomic)  NSString *mb_total;
@property (copy, nonatomic)  NSString *mb_year;
@property(nonatomic,assign) NSInteger mb_yearNum;//还款年限
@property (copy, nonatomic)  NSString *mb_rate;
@property (copy, nonatomic)  NSString *mf_total;
@property (copy, nonatomic)  NSString *mf_year;
@property(nonatomic,assign) NSInteger mf_yearNum;//还款年限
@property (copy, nonatomic)  NSString *mf_rate;
@property (copy, nonatomic)  NSString *m_type;
@property(nonatomic,assign) NSInteger m_typeNum;//还款方式

/* 楼盘信息 */
@property(nonatomic,copy) NSString *proName;
@property(nonatomic,copy) NSString *hxName;
@property(nonatomic,copy) NSString *buldArea;
@property(nonatomic,copy) NSString *roomArea;
/* HU型uuid */
@property(nonatomic,copy) NSString *hxUuid;
@end

NS_ASSUME_NONNULL_END
