//
//  UIViewController+QMUIKit.h
//  MinLison
//
//  Created by MinLison on 2017/11/6.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface UIViewController (QMUIKit)
- (nullable UIImage *)navigationBarBackgroundImage;
- (nullable UIImage *)navigationBarShadowImage;
- (nullable UIColor *)navigationBarTintColor;
- (BOOL)preferredNavigationBarHidden;
- (BOOL)forceEnableInteractivePopGestureRecognizer;
- (BOOL)shouldCustomNavigationBarTransitionIfBarHiddenable;
- (BOOL)shouldCustomNavigationBarTransitionWhenPushAppearing;
- (BOOL)shouldCustomNavigationBarTransitionWhenPushDisappearing;
- (BOOL)shouldCustomNavigationBarTransitionWhenPopAppearing;
- (BOOL)shouldCustomNavigationBarTransitionWhenPopDisappearing;
- (void)configNavigationBar:(BaseNavigationBar *)navigationBar;
- (void)backButtonDidClick:(nullable UIButton *)button;
+ (nullable __kindof BaseControllerView *)controllerView;
+ (WGControllerAnimationType)transitionAnimationType;
+ (WGControllerInteractionType)interactionType;
+ (nullable UIViewController <JLRRouteDefinitionTargetController> *)targetControllerWithParams:(nullable NSDictionary *)parameters;
@end
NS_ASSUME_NONNULL_END
