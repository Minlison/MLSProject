//
//  MLSTransition.h
//  MinLison
//
//  Created by MinLison on 2017/4/24.
//  Copyright © 2017年 MinLison. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,WGControllerAnimationType)
{
        WGControllerAnimationTypeNone,
        WGControllerAnimationTypeDefault,
};

typedef NS_ENUM(NSInteger,WGControllerInteractionType)
{
        WGControllerInteractionTypeNone,
};

@protocol WGTransitionProtocol <NSObject>

@optional
/**
 转场动画效果

 @return 转场动画效果 默认为 WGControllerAnimationTypeNone
 */
+ (WGControllerAnimationType)transitionAnimationType;

/**
  手势效果
  暂未实现
 @return 手势 WGControllerInteractionTypeNone
 */
+ (WGControllerInteractionType)interactionType;

@end

/**
 全局过度动画管理工具
 */
@interface MLSTransition : NSObject <UIViewControllerTransitioningDelegate, UINavigationControllerDelegate>

/**
 全局过度动画管理工具

 @return 单例
 */
+ (instancetype)shared;

@end
