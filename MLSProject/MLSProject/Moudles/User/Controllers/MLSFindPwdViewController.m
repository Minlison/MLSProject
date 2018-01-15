//
//  MLSFindPwdViewController.m
//  MLSProject
//
//  Created by MinLison on 2017/12/12.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "MLSFindPwdViewController.h"
#import "MLSSetPwdViewController.h"
@interface MLSFindPwdViewController ()

@end
@implementation MLSFindPwdViewController
- (void)configNavigationBar:(BaseNavigationBar *)navigationBar
{
        [super configNavigationBar:navigationBar];
        self.titleView.titleLabel.textColor = [UIColor whiteColor];
        self.title = @"找回密码";
}
- (void)next
{
        /// 跳转到设置密码
        MLSSetPwdViewController *vc = [[MLSSetPwdViewController alloc] init];
        vc.type = LNSetPwdTypeFindPwd;
        [self.navigationController pushViewController:vc animated:YES];
        
}
- (void)getSmsCode
{
        @weakify(self);
        [LNUserManager getSMSWithParam:nil success:^(NSString * _Nonnull sms) {
                @strongify(self);
                [MLSTipClass showText:sms inView:self.view];
        } failed:^(NSError * _Nonnull error) {
                @strongify(self);
                [MLSTipClass showText:error.localizedDescription inView:self.view];
        }];
}
/// MARK: - 导航栏 SubClassHolder
- (BOOL)forceEnableNavigationBarBackItem
{
        return YES;
}
- (UIImage *)navigationBarBackItemImage
{
        return [UIImage nav_ic_back_whiteRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
}
- (UIImage *)navigationBarBackgroundImage
{
        return [UIImage imageWithColor:UIColorHex(0x0190D4)];
}
- (UIColor *)navigationBarTintColor
{
        return [UIColor whiteColor];
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
        return UIStatusBarStyleLightContent;
}

@end
