//
//  UIViewController+QMUIKit.m
//  MinLison
//
//  Created by MinLison on 2017/11/6.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "UIViewController+QMUIKit.h"
YYSYNTH_DUMMY_CLASS(UIViewController_QMUIKit)
@implementation UIViewController (QMUIKit)
- (UIImage *)navigationBarBackgroundImage
{
        return [UIImage imageWithColor:QMUICMI.whiteColor];
}
- (UIImage *)navigationBarShadowImage
{
        return [UIImage nav_bar_shadows];
}
- (UIColor *)navigationBarTintColor
{
        return QMUICMI.blackColor;
}
- (BOOL)preferredNavigationBarHidden
{
        return self.prefersNavigationBarHidden || self.fd_prefersNavigationBarHidden;
}
- (BOOL)forceEnableInteractivePopGestureRecognizer
{
        return YES;
}
- (BOOL)shouldCustomNavigationBarTransitionIfBarHiddenable
{
        return YES;
}
//- (BOOL)shouldCustomNavigationBarTransitionWhenPushAppearing
//{
//        return YES;
//}
//- (BOOL)shouldCustomNavigationBarTransitionWhenPushDisappearing
//{
//        return YES;
//}
//- (BOOL)shouldCustomNavigationBarTransitionWhenPopAppearing
//{
//        return YES;
//}
//- (BOOL)shouldCustomNavigationBarTransitionWhenPopDisappearing
//{
//        return YES;
//}
- (void)configNavigationBar:(BaseNavigationBar *)navigationBar
{
        if ([self.navigationController.viewControllers count] > 1)
        {
                UIBarButtonItem *backItem =[QMUINavigationButton barButtonItemWithImage:[UIImage nav_ic_back_blackRenderingMode:(UIImageRenderingModeAlwaysOriginal)] position:(QMUINavigationButtonPositionLeft) target:self action:@selector(backButtonDidClick:)];
                if ( @available(iOS 11.0, *) )
                {
                        backItem.landscapeImagePhoneInsets = UIEdgeInsetsMake(0, -15, 0, 0);
                        backItem.imageInsets = UIEdgeInsetsMake(0, -10, 0, 0);
                        self.navigationItem.leftBarButtonItems = @[backItem];
                }
                else
                {
                        UIBarButtonItem *negativeSeparator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
                        negativeSeparator.width                = IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0") ? -25 : -25;
                        self.navigationItem.leftBarButtonItems = @[negativeSeparator,backItem];
                }
        }
        else
        {
                self.navigationItem.leftBarButtonItems = nil;
                self.navigationItem.leftBarButtonItem = nil;
        }
}

- (void)backButtonDidClick:(UIButton *)button
{
        if ([self isKindOfClass:[UINavigationController class]])
        {
                UINavigationController *selfVC = (UINavigationController *)self;
                if (selfVC.viewControllers.count > 1)
                {
                        [selfVC popViewControllerAnimated:YES];
                }
                else
                {
                        if (self.isPresentedByOther)
                        {
                                [self dismissViewControllerAnimated:YES completion:nil];
                        }
                }
        }
        else
        {
                if (self.navigationController.viewControllers.count > 0)
                {
                        [self.navigationController popViewControllerAnimated:YES];
                }
                else if (self.isPresentedByOther)
                {
                        [self dismissViewControllerAnimated:YES completion:nil];
                }
                else
                {
                        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                }
        }
}

+ (__kindof BaseControllerView * _Nullable)controllerView
{
        return nil;
}

+ (WGControllerAnimationType)transitionAnimationType
{
        return WGControllerAnimationTypeNone;
}
+ (WGControllerInteractionType)interactionType
{
        return WGControllerInteractionTypeNone;
}
/// RouterHandleProtocol method
+ (nullable UIViewController <JLRRouteDefinitionTargetController> *)targetControllerWithParams:(nullable NSDictionary *)parameters
{
        return nil;
}
@end
