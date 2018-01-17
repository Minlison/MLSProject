//
//  MainViewController.h
//  MinLison
//
//  Created by MinLison on 2017/8/31.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "IIViewDeckController.h"

@interface MainViewController : IIViewDeckController
/**
 添加控制器到 tabbar controller 上

 @param vc 控制器
 @param index 位置索引
 */
- (void)addTabbarController:(__kindof UINavigationController *)vc atIndex:(NSInteger)index;

/**
 获取当前主控制器正在显示的导航控制器

 @return  Nav
 */
- (UINavigationController *)getShowingNavitagionController;
@end
