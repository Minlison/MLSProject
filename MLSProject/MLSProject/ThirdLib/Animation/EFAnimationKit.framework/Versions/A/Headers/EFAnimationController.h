//
// Created by yizhuolin on 14-4-18.
// Copyright 2013 {Company} Inc. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface EFAnimationController : NSObject <UIViewControllerAnimatedTransitioning>

@property(nonatomic, assign) BOOL           reverse;
@property(nonatomic, assign) NSTimeInterval duration;

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
       fromViewController:(UIViewController *)fromViewController
         toViewController:(UIViewController *)toViewController;
@end