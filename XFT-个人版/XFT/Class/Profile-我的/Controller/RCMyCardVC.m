//
//  RCMyCardVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCMyCardVC.h"
#import <ZLPhotoBrowser.h>

@interface RCMyCardVC ()
@property (weak, nonatomic) IBOutlet UIImageView *codeImg;
@property (weak, nonatomic) IBOutlet UIImageView *headPic;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *name;
/* 要分享的内容 */
@property(nonatomic,strong) NSDictionary *shareInfo;
@end

@implementation RCMyCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"我的名片"];
    
    [self getShareInfoRequest];
}
-(void)getShareInfoRequest
{
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"sys/sys/agent/agentBusinessCard" parameters:@{} success:^(id responseObject) {
        hx_strongify(weakSelf);
        if ([responseObject[@"code"] integerValue] == 0) {
            strongSelf.shareInfo = [NSDictionary dictionaryWithDictionary:responseObject[@"data"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf handleInfo];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)handleInfo
{
    [self.headPic sd_setImageWithURL:[NSURL URLWithString:self.shareInfo[@"headpic"]]];
    self.name.text = self.shareInfo[@"name"];
    self.phone.text = self.shareInfo[@"regPhone"];
    
    [self.codeImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"data:image/png;base64,%@",self.shareInfo[@"wxcode"]]]];
}
-(IBAction)saveSnapshotCart
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(HX_SCREEN_WIDTH, 220),NO,0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    for(UIWindow*window in [[UIApplication sharedApplication] windows]) {
        if(![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen]) {
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            CGContextConcatCTM(context, [window transform]);
     
            CGContextTranslateCTM(context,
                                  -[window bounds].size.width* [[window layer]anchorPoint].x,
                                  -([window bounds].size.height)* [[window layer]anchorPoint].y-110);
            [[window layer]renderInContext:context];
            
            CGContextRestoreGState(context);
        }
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    [ZLPhotoManager saveImageToAblum:image completion:^(BOOL suc, PHAsset * _Nonnull asset) {
        if (suc) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"保存成功"];
            });
        }
    }];
}
@end
