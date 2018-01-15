//
//  MLSNormalAnimationController.m
//  MinLison
//
//  Created by MinLison on 2017/10/13.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSNormalAnimationController.h"
#import "MZTimerLabel.h"
@interface MLSNormalAnimationController ()<CAAnimationDelegate>
@property (weak, nonatomic) id<UIViewControllerContextTransitioning> transitionContext;
@end

@implementation MLSNormalAnimationController
+ (instancetype)container
{
        return [[self alloc] init];
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView {
        
        self.transitionContext = transitionContext;
        self.reverse ? [self popAnimation:transitionContext fromVC:fromVC toVC:toVC fromView:fromView toView:toView] : [self pushAnimation:transitionContext fromVC:fromVC toVC:toVC fromView:fromView toView:toView];
}
- (POPBasicAnimation *)getScaleAnimationStart:(void (^)(void))start completion:(void (^)(BOOL finished))completion
{
        POPBasicAnimation *anim = [POPBasicAnimation easeInEaseOutAnimation];
        anim.property = [POPAnimatableProperty propertyWithName:kPOPLayerScaleXY];
        anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(0.3, 0.3)];
        anim.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
        anim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
                if (completion) {
                        completion(finished);
                }
        };
        anim.animationDidStartBlock = ^(POPAnimation *anim) {
                if (start) {
                        start();
                }
        };
        anim.duration = self.duration;
        anim.removedOnCompletion = YES;
        return anim;
}
- (POPBasicAnimation *)getTranslationAnimationStart:(void (^)(void))start completion:(void (^)(BOOL finished))completion
{
        POPBasicAnimation *anim = [POPBasicAnimation easeInEaseOutAnimation];
        anim.property = [POPAnimatableProperty propertyWithName:kPOPLayerTranslationY];
        anim.fromValue = @(-15);
        anim.toValue = @(0);
        anim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
                if (completion) {
                        completion(finished);
                }
        };
        anim.animationDidStartBlock = ^(POPAnimation *anim) {
                if (start) {
                        start();
                }
        };
        anim.duration = self.duration;
        anim.removedOnCompletion = YES;
        return anim;
}
- (void)pushAnimation:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView
{
        self.duration = 0.35; // 系统动画时长是 0.349999999
        UIView* containerView = [transitionContext containerView];
        containerView.layer.masksToBounds = YES;
        containerView.clipsToBounds = YES;
        CGRect fromViewInitRect = [transitionContext initialFrameForViewController:fromVC];
        CGRect fromViewEndRect = [transitionContext finalFrameForViewController:fromVC];
        
        CGRect toViewInitRect = [transitionContext initialFrameForViewController:toVC];
        CGRect toViewEndRect = [transitionContext finalFrameForViewController:toVC];
        
        toView.frame = toViewEndRect;
        fromView.frame = fromViewInitRect;
        
        [containerView addSubview:fromView];
        [containerView addSubview:toView];
        
        BOOL disablePop = toVC.fd_interactivePopDisabled;
        toVC.fd_interactivePopDisabled = YES;
        toView.alpha = 0;
        [toView.layer pop_addAnimation:[self getScaleAnimationStart:^{
                toView.alpha = 1;
        } completion:^(BOOL finished) {
                if (!transitionContext.transitionWasCancelled && finished)
                {
                        [fromView removeFromSuperview];
                        fromView.frame = fromViewEndRect;
                        toView.frame = toViewEndRect;
                }
                else
                {
                        [toView removeFromSuperview];
                        toView.frame = toViewInitRect;
                        fromView.frame = fromViewInitRect;
                }
                [transitionContext completeTransition:(!transitionContext.transitionWasCancelled && finished)];
                [transitionContext finishInteractiveTransition];
                toVC.fd_interactivePopDisabled = disablePop;
        }] forKey:@"scaleKey"];
        [toView.layer pop_addAnimation:[self getTranslationAnimationStart:nil completion:nil] forKey:@"TranslationKey"];
}
- (void)popAnimation:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView
{
        self.duration = 0.35; // 系统动画时长是 0.349999999
        // Add the toView to the container
        UIView* containerView = [transitionContext containerView];
        CGRect fromViewInitRect = [transitionContext initialFrameForViewController:fromVC];
        CGRect fromViewEndRect = [transitionContext finalFrameForViewController:fromVC];
        
        CGRect toViewInitRect = [transitionContext initialFrameForViewController:toVC];
        CGRect toViewEndRect = [transitionContext finalFrameForViewController:toVC];
        
        [containerView addSubview:toView];
        [containerView addSubview:fromView];
        
        
        toView.frame = CGRectMake(-toViewEndRect.size.width * 0.5, toViewEndRect.origin.y, toViewEndRect.size.width, toViewEndRect.size.height);
        fromView.frame = fromViewInitRect;
        
        // animate
        NSTimeInterval duration = [self transitionDuration:transitionContext];
        
        [UIView animateWithDuration:duration animations:^{
                fromView.frame = CGRectMake(CGRectGetMaxX(toViewEndRect), fromViewInitRect.origin.y, fromViewInitRect.size.width, fromViewInitRect.size.height);
                toView.frame = toViewEndRect;
        } completion:^(BOOL finished) {
                if (!transitionContext.transitionWasCancelled && finished)
                {
                        [fromView removeFromSuperview];
                        fromView.frame = fromViewEndRect;
                        toView.frame = toViewEndRect;
                }
                else
                {
                        // cancel
                        [toView removeFromSuperview];
                        toView.frame = toViewInitRect;
                        fromView.frame = fromViewInitRect;
                }
                [transitionContext completeTransition:(!transitionContext.transitionWasCancelled && finished)];
        }];
}
@end
