//
//  BaseViewController.h
//  MLSProject
//
//  Created by MinLison on 2017/8/31.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationBar.h"
#import "RouterHandleProtocol.h"
#import "BaseViewModel.h"
#import "BaseView.h"
#import "UIViewController+ControllerUnits.h"

NS_ASSUME_NONNULL_BEGIN
@interface BaseViewController<__covariant ViewType : UIView <BaseViewProtocol> * >  : QMUICommonViewController <JLRRouteDefinitionTargetController>

/**
 是否正在显示
 viewWillAppear YES
 viewDidDisAppear NO
 */
@property(nonatomic, readonly) BOOL isInDisplay;

/**
 是否正在加载内容
 内部根据 ViewModel 处理,如果没有 ViewModel 则需要自己处理
 Use method - setLoading: animation:
 */
@property(nonatomic, assign, readonly, getter=isLoading) BOOL loading;

/**
 最小加载时间（防止加载过快，动画闪屏）
 默认 0.5
 */
@property(nonatomic, assign) NSTimeInterval minLoadingTime;

/**
 控制器视图
 等价于 self.view
 */
@property(nonatomic, strong) ViewType controllerView;

/**
 设置是否正在加载内容
 如果 返回的 viewModel 为空的情况下, 需要主动调用
 @param loading 是否正在加载内容
 @param animation 是否显示动画
 */
- (void)setLoading:(BOOL)loading animation:(BOOL)animation;

/**
 表示加载失败
 设置错误信息
 会 隐藏 loading 视图
 
 @param error 错误信息
 */
- (void)setError:(NSError *)error;

/**
 表示加载成功
 会 隐藏 loading 视图
 */
- (void)setSuccess;

/// SubClass holder
/**
 重新加载数据
 */
- (void)reloadData;

/**
 配置导航栏

 @param navigationBar 导航栏
 */
- (void)configNavigationBar:(BaseNavigationBar *)navigationBar;

/**
 返回按钮点击

 @param button 返回按钮点击
 */
- (void)backButtonDidClick:(nullable UIButton *)button;

/**
  控制器视图的 View
  默认是 把 Controller 去掉的 Class 创建一个 View
 
 @return Class
 */
+ (nullable __kindof ViewType)controllerView;

/**
 ViewModel
 用来进行网络访问
 @return ViewModel
 */
+ (nullable __kindof BaseViewModel *)viewModel;
@end
NS_ASSUME_NONNULL_END
