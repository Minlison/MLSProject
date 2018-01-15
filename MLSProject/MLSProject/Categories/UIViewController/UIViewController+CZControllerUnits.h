//
//  UIViewController+CZControllerUnits.h
//  minlison
//
//  Created by MinLison on 16/1/20.
//  Copyright © 2016年 orgz. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface UIViewController (CZControllerUnits)

/**
 控制器的唯一标识符
 */
@property (nonatomic, copy, readonly) NSString *identifier;

/**
 友盟统计名称
 */
@property (nonatomic, copy, readonly) NSString *mobclick_name;

/**
  正在显示时,允许当前操作流程被打断,被任意ViewController覆盖, 默认为YES
 */
@property (nonatomic, assign) BOOL allowsArbitraryPresenting;

/**
 * 正在显示时,允许当前操作流程被打断,被任意ViewController覆盖,
 * arbitraryPresentingEnabled会受到parentViewController或者
 * presentingViewController影响,只要在显示链中有任意一ViewController
 * 不允许被覆盖,则其子ViewController都不允许被覆盖
 */
@property (nonatomic, assign, readonly) BOOL arbitraryPresentingEnabled;

/**
 是否正在被显示
 */
@property (nonatomic, assign, readonly) BOOL isShowing;


/**
  是否正在弹出别的控制器
 */
@property (assign, nonatomic, readonly) BOOL isPresentingOther;

/**
 是否是被别的控制器弹出
 */
@property (assign, nonatomic, readonly) BOOL isPresentedByOther;

/**
 判断是否是present出来的

 @return 判断是否是present出来的
 */
- (BOOL)isPresented;

/**
 是否允许直接退出到tabbar 默认为NO
 */
@property (assign, nonatomic, readonly) BOOL allowChoseToTabbar;

/**
 是否允许 push 控制器
 */
@property (assign, nonatomic, readonly) BOOL allowPushIn;

/**
 是否允许手势返回
 */
@property (assign, nonatomic) BOOL enableGesturePop;

/**
 是否显示导航栏
 必须在  view 加载 之前赋值
 也可子类重写 -(BOOL)preferredNavigationBarHidden 控制
 */
@property(nonatomic, assign) BOOL prefersNavigationBarHidden;

@end
NS_ASSUME_NONNULL_END
