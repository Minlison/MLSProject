//
// Created by yizhuolin on 14-6-9.
// Copyright 2013 {Company} Inc. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

typedef void (^updatingBlock)(id tweenValue);
typedef void (^completionBlock)(BOOL finished);

@interface NSObject (EFAnimation)

- (void)ef_addAnimation:(CAPropertyAnimation *)animation forKey:(NSString *)key updating:(updatingBlock)updating completion:(completionBlock)completion;

- (void)ef_removeAllAnimations;

- (void)ef_removeAnimationForKey:(NSString *)key;

- (NSArray *)ef_animationKeys;

- (CAAnimation *)ef_animationForKey:(NSString *)key;
@end