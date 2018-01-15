//
//  BaseNavigationViewController.m
//  MinLison
//
//  Created by MinLison on 2017/8/31.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseNavigationViewController.h"
#import "MLSTransition.h"
#import "BaseNavigationBar.h"
#import "ViewDeck.h"
#import "UIViewController+QMUIKit.h"
@interface BaseNavigationViewController ()

@end

@implementation BaseNavigationViewController
- (void)didInitialized
{
        [super didInitialized];
        self.transitioningDelegate = [MLSTransition shared];
        self.delegate = [MLSTransition shared];
        [self setValue:[[BaseNavigationBar alloc] init] forKey:@"navigationBar"];
        self.navigationBar.shadowImage = [UIImage imageWithColor:QMUICMI.whiteColor];
        self.navigationBar.backgroundColor = QMUICMI.whiteColor;
        self.navigationBar.translucent = NO;
}
+ (WGControllerAnimationType)animationType
{
        return WGControllerAnimationTypeDefault;
}

- (void)willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
        [super willShowViewController:viewController animated:animated];
        if ([viewController respondsToSelector:@selector(configNavigationBar:)]) {
                [viewController configNavigationBar:(BaseNavigationBar *)self.navigationBar];
        }
}
- (void)didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
        [super didShowViewController:viewController animated:animated];
}
//- (BOOL)shouldCustomNavigationBarTransitionWhenPushAppearing
//{
//        return YES;
//}
//
//- (BOOL)shouldCustomNavigationBarTransitionWhenPushDisappearing
//{
//        return YES;
//}
//- (BOOL)shouldCustomNavigationBarTransitionWhenPopAppearing
//{
//        return YES;
//}
//
//- (BOOL)shouldCustomNavigationBarTransitionWhenPopDisappearing
//{
//        return YES;
//}
//- (BOOL)shouldCustomNavigationBarTransitionIfBarHiddenable
//{
//        return YES;
//}

/// MARK: - 把statusBar的控制权交给栈顶控制器
- (UIStatusBarStyle)preferredStatusBarStyle
{
        return self.topViewController.preferredStatusBarStyle;
}

- (nullable UIViewController *)childViewControllerForStatusBarStyle
{
        return self.topViewController;
}
- (nullable UIViewController *)childViewControllerForStatusBarHidden
{
        return self.topViewController;
}
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
        return self.topViewController.preferredStatusBarUpdateAnimation;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
        return self.topViewController.supportedInterfaceOrientations;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
        return UIInterfaceOrientationPortrait;
}
- (BOOL)shouldAutorotate
{
        return self.topViewController.shouldAutorotate;
}
- (BOOL)prefersStatusBarHidden
{
        return self.topViewController.prefersStatusBarHidden;
}

@end
