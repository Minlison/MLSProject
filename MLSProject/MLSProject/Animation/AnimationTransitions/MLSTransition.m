//
//  MLSTransition.m
//  minlison
//
//  Created by MinLison on 2017/4/24.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSTransition.h"
#import "CEBaseInteractionController.h"
#import "CEReversibleAnimationController.h"
#import "CEVerticalSwipeInteractionController.h"
#import "BaseNavigationViewController.h"

static NSMutableDictionary *registerControllers;

typedef CEReversibleAnimationController *(^TransitionBlock)(void);
typedef CEBaseInteractionController *(^InteractionBlock)(void);
void(^RegisterTransition)(Class VCClass, TransitionBlock transition, InteractionBlock interaction) = ^(Class VCClass, TransitionBlock transition, InteractionBlock interaction)
{
	if (registerControllers == nil) {
		registerControllers = [NSMutableDictionary dictionary];
	}
	NSObject *transitioner = transition();
	if (transitioner != nil) {
		
		[registerControllers setObject:transitioner forKey:[NSString stringWithFormat:@"trans_%@",NSStringFromClass(VCClass)]];
		NSObject *inter = interaction();
		if (inter != nil) {
			[registerControllers setObject:inter forKey:[NSString stringWithFormat:@"inter_%@",[transitioner className]]];
		}
	}
};

@interface MLSTransition()

@end

@implementation MLSTransition
+ (instancetype)shared
{
	static MLSTransition *instance;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		if (registerControllers == nil) {
			registerControllers = [NSMutableDictionary dictionary];
		}
		instance = [[self alloc] init];
	});
	return instance;
}
- (instancetype)init{
	if (self = [super init]) {
		[self registerAllAnimations];
	}
	return  self;
}
- (void)registerAllAnimations
{
//	RegisterTransition([**NavViewController class],  ^CEReversibleAnimationController *(){
//		return [**AnimationController container];
//	}, ^CEBaseInteractionController *() {
//		return nil; // 会导致内存泄露, 暂时没有解决
//	});
}
- (CEBaseInteractionController *)interaction:(Class)obj
{
	NSString *key = [NSString stringWithFormat:@"inter_%@",NSStringFromClass(obj)];
	return [registerControllers objectForKey:key];
}
- (CEReversibleAnimationController *)animation:(Class)obj
{
	NSString *key = [NSString stringWithFormat:@"trans_%@",NSStringFromClass(obj)];
	return [registerControllers objectForKey:key];
}
/// View Controller
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
	CEReversibleAnimationController *animation = [self animation:[presented class]];
	if ([presented isKindOfClass:[BaseNavigationViewController class]])
	{
		animation = [self animation:[[(BaseNavigationViewController *)presented topViewController] class]];
	}
	CEBaseInteractionController *interaction = [self interaction:[animation class]];
	
	if (interaction != nil)
	{
		if ([presented isKindOfClass:[BaseNavigationViewController class]])
		{
			[interaction wireToViewController:[(BaseNavigationViewController *)presented topViewController] forOperation:(CEInteractionOperationDismiss)];
		}
		else {
			[interaction wireToViewController:presented forOperation:(CEInteractionOperationDismiss)];
		}
	}
	
	animation.reverse = NO;
	return animation;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
	CEReversibleAnimationController *animation = [self animation:[dismissed class]];
	if ([dismissed isKindOfClass:[BaseNavigationViewController class]])
	{
		animation = [self animation:[[(BaseNavigationViewController *)dismissed topViewController] class]];
	}
	animation.reverse = YES;
	return animation;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator
{
	CEBaseInteractionController *interaction = [self interaction:[animator class]];
	if (interaction.interactionInProgress) {
		return interaction;
	}
	return nil;
}

/// Nav ViewController
- (void)wirePopInteractionControllerTo:(UIViewController *)viewController
{
	
	CEReversibleAnimationController *animation = [self animation:[viewController class]];
	CEBaseInteractionController *interaction = [self interaction:[animation class]];
	
	[interaction wireToViewController:viewController forOperation:(CEInteractionOperationPop)];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	if (navigationController.childViewControllers.firstObject == viewController)
        {
		return;
	}
	[self wirePopInteractionControllerTo:viewController];
}


- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
				   interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController
{
	CEBaseInteractionController *interaction = [self interaction:[animationController class]];
	if (interaction.interactionInProgress) {
		return interaction;
	}
	return nil;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
					    animationControllerForOperation:(UINavigationControllerOperation)operation
							 fromViewController:(UIViewController *)fromVC
							   toViewController:(UIViewController *)toVC
{
	CEReversibleAnimationController *animation = nil;
	if (operation == UINavigationControllerOperationPush) {
		animation = [self animation:[toVC class]];
		animation.reverse = NO;
	} else if (operation == UINavigationControllerOperationPop)
	{
		animation = [self animation:[fromVC class]];
		animation.reverse = YES;
	}
	return animation;
}
@end
