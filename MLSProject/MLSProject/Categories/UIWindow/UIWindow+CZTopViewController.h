//
//  UIWindow+CZTopViewController.h
//  minlison
//
//  Created by MinLison on 16/1/20.
//  Copyright © 2016年 orgz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWindow (CZTopViewController)

/** 调用时有性能开销 */
@property (nonatomic, readonly, strong) UIViewController *topViewController;

@end

@interface UIViewController (CZTopViewController)

/** 调用时有性能开销 */
@property (nonatomic, readonly, strong) UIViewController *topViewController;

@end
