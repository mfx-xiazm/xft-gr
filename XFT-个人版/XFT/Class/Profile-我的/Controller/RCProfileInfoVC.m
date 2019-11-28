//
//  RCProfileInfoVC.m
//  XFT
//
//  Created by 夏增明 on 2019/8/28.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCProfileInfoVC.h"
#import "RCChangeInfoVC.h"
#import "FSActionSheet.h"
#import "zhAlertView.h"
#import <zhPopupController.h>
#import "RCChangePwdVC.h"
#import "RCLoginVC.h"
#import "HXNavigationController.h"
#import "HXTabBarController.h"

@interface RCProfileInfoVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,FSActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headPic;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UIButton *woman;
@property (weak, nonatomic) IBOutlet UIButton *man;

/* 上一次选择的性别 */
@property(nonatomic,strong) UIButton *sexBtn;
@end

@implementation RCProfileInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"我的信息"];
    
    [self.headPic sd_setImageWithURL:[NSURL URLWithString:[MSUserManager sharedInstance].curUserInfo.userinfo.headpic]];
    self.nickName.text = [MSUserManager sharedInstance].curUserInfo.userinfo.nick;
    if ([MSUserManager sharedInstance].curUserInfo.userinfo.regPhone && [MSUserManager sharedInstance].curUserInfo.userinfo.regPhone.length) {
        self.phone.text = [NSString stringWithFormat:@"%@****%@",[[MSUserManager sharedInstance].curUserInfo.userinfo.regPhone substringToIndex:3],[[MSUserManager sharedInstance].curUserInfo.userinfo.regPhone substringFromIndex:[MSUserManager sharedInstance].curUserInfo.userinfo.regPhone.length-4]];
    }else{
        self.phone.text = [MSUserManager sharedInstance].curUserInfo.userinfo.regPhone;
    }
    
    if ([[MSUserManager sharedInstance].curUserInfo.userinfo.sex isEqualToString:@"1"]) {
        self.man.selected = YES;
    }else{
        self.woman.selected = YES;
    }
}
- (IBAction)clientSexClicked:(UIButton *)sender {
    self.sexBtn.selected = NO;
    self.sexBtn.boderColor = UIColorFromRGB(0xCCCCCC);
    sender.selected = YES;
    sender.boderColor = UIColorFromRGB(0x666666);
    self.sexBtn = sender;
}
- (IBAction)infoBtnClicked:(UIButton *)sender {
    if (sender.tag == 1) {
        FSActionSheet *as = [[FSActionSheet alloc] initWithTitle:nil delegate:self currentButtonTitle:@"" cancelButtonTitle:@"取消" highlightedButtonTitle:nil otherButtonTitles:@[@"拍照",@"从手机相册选择"]];
        hx_weakify(self);
        [as showWithSelectedCompletion:^(NSInteger selectedIndex) {
            hx_strongify(weakSelf);
            if (selectedIndex == 0) {
                [strongSelf awakeImagePickerController:@"1"];
            }else{
                [strongSelf awakeImagePickerController:@"2"];
            }
        }];
    }else if (sender.tag == 2) {
        RCChangeInfoVC *cvc = [RCChangeInfoVC new];
        hx_weakify(self);
        cvc.changeNickCall = ^{
            hx_strongify(weakSelf);
            strongSelf.nickName.text = [MSUserManager sharedInstance].curUserInfo.userinfo.nick;
        };
        [self.navigationController pushViewController:cvc animated:YES];
    }else if (sender.tag == 3) {
        
    }else if (sender.tag == 4) {
        
    }else if (sender.tag == 5) {
        RCChangePwdVC *pvc = [RCChangePwdVC new];
        [self.navigationController pushViewController:pvc animated:YES];
    }else {
        FSActionSheet *as = [[FSActionSheet alloc] initWithTitle:@"确定要退出登录吗" delegate:self currentButtonTitle:@"" cancelButtonTitle:@"取消" highlightedButtonTitle:nil otherButtonTitles:@[@"退出"]];
        [as showWithSelectedCompletion:^(NSInteger selectedIndex) {
            if (selectedIndex == 0) {
                [[MSUserManager sharedInstance] logout:nil];
                
                RCLoginVC *lvc = [RCLoginVC new];
                HXNavigationController *nav = [[HXNavigationController alloc] initWithRootViewController:lvc];
                [UIApplication sharedApplication].keyWindow.rootViewController = nav;
                
                //推出主界面出来
                CATransition *ca = [CATransition animation];
                ca.type = @"movein";
                ca.duration = 0.5;
                [[UIApplication sharedApplication].keyWindow.layer addAnimation:ca forKey:nil];
            }
        }];
    }
}
#pragma mark -- 唤起相机
- (void)awakeImagePickerController:(NSString *)pickerType {
    if ([pickerType isEqualToString:@"1"]) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            if ([self isCanUseCamera]) {
                UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                imagePickerController.delegate = self;
                imagePickerController.allowsEditing = YES;
                
                imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                //前后摄像头是否可用
                [UIImagePickerController isCameraDeviceAvailable:YES];
                //相机闪光灯是否OK
                [UIImagePickerController isFlashAvailableForCameraDevice:YES];
                if (@available(iOS 13.0, *)) {
                    imagePickerController.modalPresentationStyle = UIModalPresentationFullScreen;
                    /*当该属性为 false 时，用户下拉可以 dismiss 控制器，为 true 时，下拉不可以 dismiss控制器*/
                    imagePickerController.modalInPresentation = YES;
                }
                [self presentViewController:imagePickerController animated:YES completion:nil];
            }else{
                hx_weakify(self);
                zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"请打开相机权限" message:@"设置-隐私-相机" constantWidth:HX_SCREEN_WIDTH - 50*2];
                zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"知道了" handler:^(zhAlertButton * _Nonnull button) {
                    hx_strongify(weakSelf);
                    [strongSelf.zh_popupController dismiss];
                }];
                okButton.lineColor = UIColorFromRGB(0xDDDDDD);
                [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
                [alert addAction:okButton];
                self.zh_popupController = [[zhPopupController alloc] init];
                [self.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
            }
        }else{
            [MBProgressHUD showTitleToView:self.view postion:NHHUDPostionTop title:@"相机不可用"];
            return;
        }
    }else{
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
            if ([self isCanUsePhotos]) {
                UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                imagePickerController.delegate = self;
                imagePickerController.allowsEditing = YES;
                
                imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                //前后摄像头是否可用
                [UIImagePickerController isCameraDeviceAvailable:YES];
                //相机闪光灯是否OK
                [UIImagePickerController isFlashAvailableForCameraDevice:YES];
                if (@available(iOS 13.0, *)) {
                    imagePickerController.modalPresentationStyle = UIModalPresentationFullScreen;
                    /*当该属性为 false 时，用户下拉可以 dismiss 控制器，为 true 时，下拉不可以 dismiss控制器*/
                    imagePickerController.modalInPresentation = YES;
                }
                [self presentViewController:imagePickerController animated:YES completion:nil];
            }else{
                hx_weakify(self);
                zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"请打开相册权限" message:@"设置-隐私-相册" constantWidth:HX_SCREEN_WIDTH - 50*2];
                zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"知道了" handler:^(zhAlertButton * _Nonnull button) {
                    hx_strongify(weakSelf);
                    [strongSelf.zh_popupController dismiss];
                }];
                okButton.lineColor = UIColorFromRGB(0xDDDDDD);
                [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
                [alert addAction:okButton];
                self.zh_popupController = [[zhPopupController alloc] init];
                [self.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
            }
        }else{
            [MBProgressHUD showTitleToView:self.view postion:NHHUDPostionTop title:@"相册不可用"];
            return;
        }
    }
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    hx_weakify(self);
    [picker dismissViewControllerAnimated:YES completion:^{
        hx_strongify(weakSelf);
        // 显示保存图片
        strongSelf.headPic.contentMode = UIViewContentModeScaleAspectFill;
        [strongSelf.headPic setImage:info[UIImagePickerControllerEditedImage]];
        [strongSelf upImageRequestWithImage:info[UIImagePickerControllerEditedImage] completedCall:^(NSString *imageUrl) {
            // 修改头像
            [strongSelf updateUserPhotoRequest:imageUrl];
        }];
    }];
}
-(void)upImageRequestWithImage:(UIImage *)image completedCall:(void(^)(NSString * imageUrl))completedCall
{
    [HXNetworkTool uploadImagesWithURL:HXRC_M_URL action:@"sys/sys/dict/getUploadImgReturnUrl.do" parameters:@{} name:@"file" images:@[image] fileNames:nil imageScale:0.8 imageType:@"png" progress:nil success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            completedCall(responseObject[@"data"][@"url"]);
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)updateUserPhotoRequest:(NSString *)imageUrl
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"phoneUrl"] = imageUrl;
    
    parameters[@"data"] = data;
    
    [HXNetworkTool POST:HXRC_M_URL action:@"sys/sys/personalReg/personalUpdatePhone" parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            [MSUserManager sharedInstance].curUserInfo.userinfo.headpic = imageUrl;
            [[MSUserManager sharedInstance] saveUserInfo];
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
@end
