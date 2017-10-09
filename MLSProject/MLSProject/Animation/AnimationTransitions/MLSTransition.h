//
//  MLSTransition.h
//  minlison
//
//  Created by MinLison on 2017/4/24.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import <Foundation/Foundation.h>

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
