//
//  UIWindow+CZTopViewController.m
//  minlison
//
//  Created by MinLison on 16/1/20.
//  Copyright © 2016年 orgz. All rights reserved.
//

#import "UIWindow+CZTopViewController.h"

@implementation UIWindow (CZTopViewController)

- ( UIViewController * )topViewController
{
        return [self __topViewControllerWithRootViewController:self.rootViewController];
}

- ( UIViewController * )__topViewControllerWithRootViewController:(UIViewController *)rootViewController
{
        // Handling UITabBarController
        if ( [rootViewController isKindOfClass:[UITabBarController class]] )
        {
                UITabBarController *tabBarController = (UITabBarController *) rootViewController;
                return [self __topViewControllerWithRootViewController:tabBarController.selectedViewController];
        }
        else if ( [rootViewController isKindOfClass:[UINavigationController class]] )
        {
                UINavigationController *navigationController = ( UINavigationController * ) rootViewController;
                return [self __topViewControllerWithRootViewController:navigationController.visibleViewController];
        }
        else if ( rootViewController.presentedViewController )
        {
                UIViewController *presentedViewController = rootViewController.presentedViewController;
                return [self __topViewControllerWithRootViewController:presentedViewController];
        }
        else
        {
                // 暂时不需要管不是push或者present进的控制器
                
//                for ( UIView *view in [rootViewController.view subviews] )
//                {
//                        id subViewController = [view nextResponder];    // Key property which most of us are unaware of / rarely use.
//                        if ( subViewController && [subViewController isKindOfClass:[UIViewController class]] )
//                        {
//                                return [self __topViewControllerWithRootViewController:subViewController];
//                        }
//                }
                return rootViewController;
        }
}

@end
@implementation UIViewController (CZTopViewController)

- ( UIViewController * )topViewController
{
	return [self __topViewControllerWithRootViewController:self];
}

- ( UIViewController * )__topViewControllerWithRootViewController:(UIViewController *)rootViewController
{
	// Handling UITabBarController
	if ( [rootViewController isKindOfClass:[UITabBarController class]] )
	{
		UITabBarController *tabBarController = (UITabBarController *) rootViewController;
		return [self __topViewControllerWithRootViewController:tabBarController.selectedViewController];
	}
	else if ( [rootViewController isKindOfClass:[UINavigationController class]] )
	{
		UINavigationController *navigationController = ( UINavigationController * ) rootViewController;
		return [self __topViewControllerWithRootViewController:navigationController.visibleViewController];
	}
	else if ( rootViewController.presentedViewController )
	{
		UIViewController *presentedViewController = rootViewController.presentedViewController;
		return [self __topViewControllerWithRootViewController:presentedViewController];
	}
	else
	{
		
		//                if ([rootViewController isKindOfClass:[CZVideoViewController class]])
		//                {
		//                        return rootViewController;
		//                }
		// 暂时不需要管不是push或者present进的控制器
		
		//                for ( UIView *view in [rootViewController.view subviews] )
		//                {
		//                        id subViewController = [view nextResponder];    // Key property which most of us are unaware of / rarely use.
		//                        if ( subViewController && [subViewController isKindOfClass:[UIViewController class]] )
		//                        {
		//                                return [self __topViewControllerWithRootViewController:subViewController];
		//                        }
		//                }
		return rootViewController;
	}
}

@end
