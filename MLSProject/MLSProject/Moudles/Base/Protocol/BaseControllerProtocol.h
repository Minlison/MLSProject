//
//  BaseControllerProtocol.h
//  MinLison
//
//  Created by MinLison on 2017/10/27.
//  Copyright © 2017年 minlison. All rights reserved.
//

#ifndef BaseControllerProtocol_h
#define BaseControllerProtocol_h
#import <UIKit/UIKit.h>
#import "BaseNavigationBar.h"
#import "RouterHandleProtocol.h"
#import "RouterServiceProtocol.h"
NS_ASSUME_NONNULL_BEGIN
typedef void (^BaseControllerDismissBlock)(void);
@protocol BaseControllerProtocol <JLRRouteDefinitionTargetController,WGTransitionProtocol>

/**
 控制器视图
 等价于 self.view
 */
@property(nonatomic, strong) __kindof UIView * controllerView;

/**
 是否正在显示
 viewWillAppear YES
 viewDidDisAppear NO
 */
@property(nonatomic, readonly, getter=isInDisplay) BOOL inDisplay;

/**
 是否是第一次显示
 viewDidDisAppear 设置为 NO
 */
@property(nonatomic, readonly, getter=isFirstAppear) BOOL firstAppear;

/**
 是否正在加载内容
 内部根据 ViewModel 处理,如果没有 ViewModel 则需要自己处理
 Use method - setLoading: animation:
 */
@property(nonatomic, assign, readonly, getter=isLoading) BOOL loading;


/**
 数据是否加载完毕
 */
@property(nonatomic, assign, readonly, getter=isDataLoaded) BOOL dataLoaded;

/**
 最小加载时间（防止加载过快，动画闪屏）
 默认 0.5
 */
@property(nonatomic, assign) NSTimeInterval minLoadingTime;

/**
 回调，在 被 pop 或者 dismiss 的时候回调 中回调
 */
@property(nonatomic, copy) BaseControllerDismissBlock dismissBlock;

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
 表示加载失败
 设置错误信息
 会 隐藏 loading 视图
 
 @param error  错误信息
 @param completion 状态设置成功回调
 */
- (void)setError:(NSError *)error completion:(nullable void (^)(void))completion;
/**
 表示加载成功
 会 隐藏 loading 视图
 */
- (void)setSuccess;

/**
 表示加载成功
 会 隐藏 loading 视图
 
 @param completion 状态设置成功回调
 */
- (void)setSuccessCompletion:(nullable void (^)(void))completion;

/// SubClass holder
/**
 重新加载数据
 */
- (void)reloadData;

/**
 加载数据
 */
- (void)loadData;

/**
 配置导航栏
 
 @param navigationBar 导航栏
 */
- (void)configNavigationBar:(BaseNavigationBar *)navigationBar;

/**
 强制开启返回按钮
 如果返回 YES， 当当前控制器的导航控制器只剩下该控制器的时候，也会显示导航按钮，点击后会尝试退出 modal 导航控制器
 默认为 NO
 @return
 */
- (BOOL)forceEnableNavigationBarBackItem;

/**
 返回按钮的图片

 */
- (UIImage *)navigationBarBackItemImage;

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
+ (nullable __kindof UIView *)controllerView;

/**
 配置口空状页
 self.emptyView
 */
- (void)configEmptyView;

/**
 路由

 @param url 路由端口地址
 @param param 参数
 */
- (void)routeUrl:(NSString *)url param:(nullable NSDictionary *)param;
- (void)routeUrl:(NSString *)url param:(nullable NSDictionary *)param handler:(__nullable RouterServiceCallBackBlock)handlerBlock;
@end
NS_ASSUME_NONNULL_END
#endif /* BaseControllerProtocol_h */
