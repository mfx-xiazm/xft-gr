//
//  RCNoticeDetialVC.m
//  XFT
//
//  Created by 夏增明 on 2019/11/21.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCNoticeDetialVC.h"
#import "RCHouseNotice.h"

@interface RCNoticeDetialVC ()
@property (weak, nonatomic) IBOutlet UILabel *notice_title;
@property (weak, nonatomic) IBOutlet UILabel *notice_txt;
@property (weak, nonatomic) IBOutlet UILabel *notice_time;
/* 公告 */
@property(nonatomic,strong) RCHouseNotice *notice;
@end

@implementation RCNoticeDetialVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"公告"];
    [self getNoticeDetailRequest];
}
-(void)getNoticeDetailRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"uuid"] = self.uuid;
    parameters[@"data"] = data;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"pro/pro/notice/noticeInfo" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if ([responseObject[@"code"] integerValue] == 0) {
            strongSelf.notice = [RCHouseNotice yy_modelWithDictionary:responseObject[@"data"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.notice_title setTextWithLineSpace:5.f withString:strongSelf.notice.title withFont:[UIFont systemFontOfSize:17]];
                [strongSelf.notice_txt setTextWithLineSpace:5.f withString:strongSelf.notice.context withFont:[UIFont systemFontOfSize:15]];
                strongSelf.notice_time.text = strongSelf.notice.publishTime;
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
@end
