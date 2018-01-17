//
//  BaseTabBarViewController.m
//  MinLison
//
//  Created by MinLison on 2017/10/26.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseTabBarViewController.h"

@interface BaseTabBarViewController ()

@end

@implementation BaseTabBarViewController
- (instancetype)init
{
        self = [super init];
        if (self) {
                self.tabBar.translucent = NO;
        }
        return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)didInitialized
{
        [super didInitialized];
        self.tabBar.translucent = NO;
}

// 把statusBar的控制权交给栈顶控制器
- (UIStatusBarStyle)preferredStatusBarStyle
{
        return self.selectedViewController.preferredStatusBarStyle;
}
- (nullable UIViewController *)childViewControllerForStatusBarStyle
{
        return self.selectedViewController;
}
- (nullable UIViewController *)childViewControllerForStatusBarHidden
{
        return self.selectedViewController;
}
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
        return self.selectedViewController.preferredStatusBarUpdateAnimation;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
        return self.selectedViewController.supportedInterfaceOrientations;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
        return UIInterfaceOrientationPortrait;
}
- (BOOL)shouldAutorotate
{
        return self.selectedViewController.shouldAutorotate;
}
- (BOOL)prefersStatusBarHidden
{
        return self.selectedViewController.prefersStatusBarHidden;
}
@end
