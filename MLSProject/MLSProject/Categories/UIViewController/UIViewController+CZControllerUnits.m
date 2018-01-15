//
//  UIViewController+CZControllerUnits.m
//  minlison
//
//  Created by MinLison on 16/1/20.
//  Copyright © 2016年 orgz. All rights reserved.
//

#import "UIViewController+CZControllerUnits.h"
#import <objc/runtime.h>

static int64_t identifier = 0;

@implementation UIViewController (CZControllerUnits)
@dynamic identifier;
@dynamic isPresentingOther;
@dynamic isPresentedByOther;
@dynamic allowPushIn;
@dynamic allowChoseToTabbar;
@dynamic mobclick_name;
- (void)setMobclick_name:(NSString *)mobclick_name
{
        objc_setAssociatedObject(self, @selector(mobclick_name), mobclick_name, OBJC_ASSOCIATION_COPY);
}
- (NSString *)mobclick_name
{
        id mobclick_name = objc_getAssociatedObject(self, _cmd);
        if (!mobclick_name)
        {
                NSString *controllerName = [[NSStringFromClass([self class]) stringByReplacingOccurrencesOfString:@"WG" withString:@""] stringByReplacingOccurrencesOfString:@"ViewController" withString:@""];
                [self setMobclick_name:controllerName];
        }
        return mobclick_name;
}
- (NSString *)identifier
{
        id private_identifier = objc_getAssociatedObject(self, @selector(identifier));
        if (!private_identifier || ![private_identifier isKindOfClass:[NSString class]]) {
                private_identifier = [NSString stringWithFormat:@"%@_%lld",[self class], identifier++];
                objc_setAssociatedObject(self, @selector(identifier), private_identifier, OBJC_ASSOCIATION_COPY);
        }
        return private_identifier;
}

- ( void )setAllowsArbitraryPresenting:( BOOL )allowsArbitraryPresenting
{
        objc_setAssociatedObject( self, @selector(allowsArbitraryPresenting), @(allowsArbitraryPresenting), OBJC_ASSOCIATION_ASSIGN );
}

- (BOOL)allowPushIn
{
        if ([self isKindOfClass:[UINavigationController class]])
        {
                return YES;
        }
        
        return self.navigationController != nil && self.allowsArbitraryPresenting;
}
- (BOOL)allowChoseToTabbar
{
        if ([self isKindOfClass:[UITabBarController class]])
        {
                return YES;
        }
        
        if ([self.parentViewController isKindOfClass:[UITabBarController class]])
        {
                return YES;
        }
        
        if ([self isKindOfClass:[UINavigationController class]] && [self.parentViewController isKindOfClass:[UITabBarController class]] && [(UINavigationController *)self viewControllers].count == 1)
        {
                return YES;
        }
        // 普通控制器
        if (self.navigationController != nil && self.navigationController.viewControllers.count == 1 && [self.navigationController.parentViewController isKindOfClass:[UITabBarController class]])
        {
                return YES;
        }
        return NO;
}
- ( BOOL )allowsArbitraryPresenting
{
        id resultObj = objc_getAssociatedObject( self, @selector(allowsArbitraryPresenting) );
        
        // 没设置过的默认为YES
        return resultObj ? [resultObj boolValue] : YES;
}

- ( BOOL )arbitraryPresentingEnabled
{
        BOOL             result          = self.allowsArbitraryPresenting;
        UIViewController *viewController = self;
        
        // 如果有任意一级不能被打断,则返回 NO
        while ( result )
        {
                if ( viewController.parentViewController )
                {
                        viewController = viewController.parentViewController;
                }
                else if ( viewController.presentingViewController )
                {
                        viewController = viewController.presentingViewController;
                }
                else
                {
                        return YES;
                }
                
                result = viewController.allowsArbitraryPresenting;
        }
        return result;
}
- (BOOL)isPresentingOther
{
        return self.presentedViewController != nil;
}
- (BOOL)isPresentedByOther
{
        return self.presentingViewController != nil;
}
- ( BOOL )isShowing
{
        UIView *view = self.view;
        
        while ( view && ( view.superview.subviews.lastObject == view || ![self __hasFullScreenViewAboveView:view] ) )
        {
                view = view.superview;
                
                if ( [view isKindOfClass:[UIWindow class]] && view == [UIApplication sharedApplication].keyWindow )
                {
                        return YES;
                }
        }
        
        return NO;
}
// 如果有全屏的View
- ( BOOL )__hasFullScreenViewAboveView:(UIView *)view
{
        __block BOOL result = NO;
        
        [view.superview.subviews enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:
         ^(UIView *obj, NSUInteger idx, BOOL *stop)
         {
                 if ( obj != view )
                 {
                         //  需要判断这个View是否是响应者，或者视图是否可见
                         if ( CGRectEqualToRect( CGRectIntersection( obj.frame, [UIScreen mainScreen].bounds ), [UIScreen mainScreen].bounds ) && obj.isUserInteractionEnabled && obj.alpha != 0 )
                         {
                                 *stop = result = YES;
                                 return;
                         }
                 }
                 else
                 {
                         *stop = YES;
                         return;
                 }
         }];
        
        return result;
}

- (BOOL)isPresented
{
        return self.presentingViewController.presentedViewController == self
        || self.navigationController.presentingViewController.presentedViewController == self.navigationController
        || [self.tabBarController.presentingViewController isKindOfClass:[UITabBarController class]];
}

- (void)setEnableGesturePop:(BOOL)enableGesturePop
{
        objc_setAssociatedObject(self, @selector(enableGesturePop), @(enableGesturePop), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)enableGesturePop
{
        return [objc_getAssociatedObject(self, @selector(enableGesturePop)) boolValue];
}

- (void)setPrefersNavigationBarHidden:(BOOL)prefersNavigationBarHidden
{
        objc_setAssociatedObject(self, @selector(prefersNavigationBarHidden), @(prefersNavigationBarHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)prefersNavigationBarHidden
{
        return [objc_getAssociatedObject(self, @selector(prefersNavigationBarHidden)) boolValue];
}
@end
