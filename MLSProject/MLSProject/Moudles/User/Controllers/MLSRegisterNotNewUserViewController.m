//
//  MLSRegisterNotNewUserViewController.m
//  MLSProject
//
//  Created by MinLison on 2017/12/12.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "MLSRegisterNotNewUserViewController.h"
#import "MLSFormLoginViewController.h"
#import "MLSFindPwdViewController.h"
#import "MLSRegisterViewController.h"
@interface MLSRegisterNotNewUserViewController ()

@end

@implementation MLSRegisterNotNewUserViewController
- (void)viewDidLoad
{
        [super viewDidLoad];
        
        @weakify(self);
        self.controllerView.actionBlock = ^(MLSRegisterNotNewUserViewClickType type) {
                @strongify(self);
                switch (type)
                {
                        case MLSRegisterNotNewUserViewClickTypeMineLoginRightNow:
                        {
                                [self loginRightNow];
                        }
                                break;
                                
                        case MLSRegisterNotNewUserViewClickTypeForgetPwdAndReset:
                        {
                                [self forgetPwdAndReset];
                        }
                                break;
                                
                        case MLSRegisterNotNewUserViewClickTypeChangePhoneToRegister:
                        {
                                [self changePhoneToRegister];
                        }
                                break;
                                
                        default:
                                break;
                }
        };
}
- (void)loginRightNow
{
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:self.navigationController.viewControllers.firstObject];
        
        if (self.navigationController.viewControllers.count > 2 && [self.navigationController.viewControllers[1] isKindOfClass:[MLSFormLoginViewController class]])
        {
                [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
        }
        else
        {
                [array addObject:[[MLSFormLoginViewController alloc] init]];
                [self.navigationController setViewControllers:array animated:YES];
        }
        
}
- (void)forgetPwdAndReset
{
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:self.navigationController.viewControllers.firstObject];
        
        if (self.navigationController.viewControllers.count > 2 && [self.navigationController.viewControllers[1] isKindOfClass:[MLSFindPwdViewController class]])
        {
                [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
        }
        else
        {
                [array addObject:[[MLSFormLoginViewController alloc] init]];
                [array addObject:[[MLSFindPwdViewController alloc] init]];
                [self.navigationController setViewControllers:array animated:YES];
        }
}
- (void)changePhoneToRegister
{
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:self.navigationController.viewControllers.firstObject];
        
        if (self.navigationController.viewControllers.count > 3 && [self.navigationController.viewControllers[2] isKindOfClass:[MLSRegisterViewController class]])
        {
                [self.navigationController popToViewController:self.navigationController.viewControllers[2] animated:YES];
        }
        else
        {
                [array addObject:[[MLSFormLoginViewController alloc] init]];
                [array addObject:[[MLSRegisterViewController alloc] init]];
                [self.navigationController setViewControllers:array animated:YES];
        }
}
- (void)configNavigationBar:(BaseNavigationBar *)navigationBar
{
        [super configNavigationBar:navigationBar];
        self.title = @"注册";
        self.titleView.titleLabel.textColor = [UIColor whiteColor];
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
