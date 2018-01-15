//
//  MainServiceProtocol.h
//  MinLison
//
//  Created by MinLison on 2017/8/31.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseServiceProtocol.h"
NS_ASSUME_NONNULL_BEGIN
@protocol MainServiceProtocol <BaseServiceProtocol>
/**
 注册控制器
 添加到 tabbarController 上面
 @param vc 控制器
 @param index 位置索引
 */
- (void)addTabBarController:(__kindof UINavigationController *)vc atIndex:(NSInteger)index;

/**
 添加左侧 menu 菜单控制器

 @param vc 左侧菜单控制器
 */
- (void)setLeftMenuController:(__kindof UIViewController *)vc;

/**
 添加右侧 menu 菜单控制器
 
 @param vc 右侧菜单控制器
 */
- (void)setRightMenuController:(__kindof UIViewController *)vc;

/**
 打开左侧菜单

 @param animation 是否动画
 @param completion 完成回调
 */
- (void)openLeftMenu:(BOOL)animation completion:(void (^ __nullable )(BOOL canceled))completion;

/**
 关闭菜单并压入视图

 @param vc 视图控制器
 */
- (void)closeMenu:(BOOL)animation andPushViewController:(__kindof UIViewController *)vc;

/**
 关闭菜单并弹出视图
 
 @param vc 视图控制器
 */
- (void)closeMenu:(BOOL)animation andPresentViewController:(__kindof UIViewController *)vc completion:(void (^ __nullable)(void))completion;

/**
 关闭菜单
 @param animation 是否动画
 @param completion 完成回调
 */
- (void)closeMenu:(BOOL)animation completion:(void (^ __nullable)(BOOL cancelled))completion;
@end
NS_ASSUME_NONNULL_END
