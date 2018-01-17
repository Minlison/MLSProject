//
//  MLSTabBarViewController.h
//  MinLison
//
//  Created by MinLison on 2017/10/26.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseTabBarViewController.h"

@interface MLSTabBarViewController : BaseTabBarViewController
/**
 注册控制器
 添加到 tabbarController 上面
 @param vc 控制器
 @param index 位置索引
 */
- (void)addTabBarController:(__kindof UIViewController *)vc atIndex:(NSInteger)index;
@end
