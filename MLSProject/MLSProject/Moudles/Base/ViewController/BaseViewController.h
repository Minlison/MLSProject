//
//  BaseViewController.h
//  MinLison
//
//  Created by MinLison on 2017/8/31.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationBar.h"
#import "BaseViewModel.h"
#import "BaseControllerView.h"
#import "UIViewController+CZControllerUnits.h"
#import "BaseControllerProtocol.h"
#import "BaseControllerCommentProtocol.h"


NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN NSString *WGViewControllerReloadDataNotifaction;


@interface BaseViewController <__covariant ViewType : UIView <BaseControllerViewProtocol> * >  : QMUICommonViewController <BaseControllerProtocol>
/**
 控制器视图
 等价于 self.view
 */
@property(nonatomic, strong) ViewType controllerView;

/**
 block
 */
@property(nonatomic, copy) BaseControllerDismissBlock dismissBlock;

/**
  控制器视图的 View
  默认是 把 Controller 去掉的 Class 创建一个 View
 
 @return Class
 */
+ (nullable __kindof ViewType)controllerView;

/**
 配置空状页
 */
- (void)configEmptyView NS_REQUIRES_SUPER;

/**
 发送全局 reloadata 的通知
 */
- (void)postReloadDataNotifaction;
@end

@interface BaseViewController <__covariant ViewType : UIView <BaseControllerViewProtocol> * > (Comment) <BaseControllerCommentProtocol,BaseCommentToolBarDelegate,QMUIKeyboardManagerDelegate>

/**
 初始化评论视图
 */
- (void)initCommentView;
@end

NS_ASSUME_NONNULL_END
