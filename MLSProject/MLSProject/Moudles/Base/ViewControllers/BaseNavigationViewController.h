//
//  BaseNavigationViewController.h
//  MinLison
//
//  Created by MinLison on 2017/8/31.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseNavigationViewController : QMUINavigationController <WGTransitionProtocol>

/**
 动画效果
 
 @return 动画效果，默认 WGControllerAnimationTypeDefault
 */
+ (WGControllerAnimationType)animationType;
@end
