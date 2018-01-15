//
// Created by yizhuolin on 14-5-15.
// Copyright 2013 {Company} Inc. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , EFAnimationDirection) {
    EFAnimationDirectionIn,
    EFAnimationDirectionOut,
};

typedef void (^EFAnimationConfigBlock)(CAAnimation *animation);

@interface UIView (EFAnimation)

- (void)ef_shake:(CGFloat)distance vertically:(BOOL)vertically configBlock:(EFAnimationConfigBlock)configBlock;

- (void)ef_scaleIn:(EFAnimationDirection)direction bounce:(BOOL)bounce configBlock:(EFAnimationConfigBlock)configBlock;

- (void)ef_scaleOut:(EFAnimationDirection)direction configBlock:(EFAnimationConfigBlock)configBlock;

@end