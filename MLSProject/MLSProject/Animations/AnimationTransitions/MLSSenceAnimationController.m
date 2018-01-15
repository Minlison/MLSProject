//
//  MLSSenceAnimationController.m
//  MinLison
//
//  Created by MinLison on 2017/4/24.
//  Copyright © 2017年 MinLison. All rights reserved.
//

#import "MLSSenceAnimationController.h"

@interface MLSSenceAnimationController()<CAAnimationDelegate>
@property (weak, nonatomic) id<UIViewControllerContextTransitioning> transitionContext;
@end

@implementation MLSSenceAnimationController
+ (instancetype)container
{
	return [[self alloc] init];
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView {
        
	self.transitionContext = transitionContext;
	
	self.duration = 0.4;
	CGFloat width = 1.0;
	
	UIView* containerView = [transitionContext containerView];
	toView.frame = [transitionContext finalFrameForViewController:toVC];
	
	[containerView addSubview:fromView];
	[containerView addSubview:toView];
	
	
	self.reverse ? [containerView sendSubviewToBack:toView] : [containerView bringSubviewToFront:toView];
	
//	CGRect fromRect = CGRectMake((fromView.frame.size.width - width) * 0.5 , fromView.frame.size.height - width * 0.5, width, width);
	CGRect fromRect = CGRectMake((fromView.frame.size.width - width) * 0.5 , 217.5, width, width);
	CGPoint extremePoint = CGPointMake(fromRect.origin.x + width * 0.5, fromRect.origin.y + width * 0.5);
	UIBezierPath *circlePathInitial = [UIBezierPath bezierPathWithOvalInRect:fromRect];
	CGFloat radius = sqrt(extremePoint.x * extremePoint.x + extremePoint.y * extremePoint.y);
	radius = MAX(CGRectGetHeight(toView.frame), CGRectGetWidth(toView.frame));
	UIBezierPath *circlePathFinal = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(fromRect, -radius, -radius)];
	//create shape layer
	CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
	shapeLayer.path = self.reverse ? circlePathInitial.CGPath : circlePathFinal.CGPath;
	
	// animate
	NSTimeInterval duration = self.reverse ? 0.3 : 0.4;
	
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
	animation.delegate = self;
	
	animation.fromValue = self.reverse ? (__bridge id _Nullable)(circlePathFinal.CGPath) : (__bridge id _Nullable)(circlePathInitial.CGPath);
	animation.toValue = self.reverse ? (__bridge id _Nullable)(circlePathInitial.CGPath) : (__bridge id _Nullable)(circlePathFinal.CGPath);
	animation.duration = duration;
	animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	[shapeLayer addAnimation:animation forKey:@"pushpath"];
	
	if (self.reverse) {
		fromView.layer.mask = shapeLayer;
	} else {
		toView.layer.mask = shapeLayer;
	}
}
- (void)animationDidStop:(CABasicAnimation *)anim finished:(BOOL)flag
{
	
	UIViewController *fromVC = [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
	UIViewController *toVC = [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
	UIView *toView = toVC.view;
	UIView *fromView = fromVC.view;
	
	
	BOOL transitionFinished = ![self.transitionContext transitionWasCancelled];
	if (transitionFinished) {
		[fromView removeFromSuperview];
		fromView.layer.mask = nil;
		toView.layer.mask = nil;
	}
	else {
		[toView removeFromSuperview];
		fromView.layer.mask = nil;
		toView.layer.mask = nil;
	}
	[self.transitionContext completeTransition:![self.transitionContext transitionWasCancelled]];
}
@end
