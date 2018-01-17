//
//  MLSPopLoginViewController.h
//  MinLison
//
//  Created by MinLison on 2017/11/1.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseViewController.h"

/**
 弹出视图的方式

 - WGPopLoginTypeFormSheet: 中间
 - WGPopLoginTypeBottomSheet: 底部
 */
typedef NS_ENUM(NSInteger, WGPopLoginType)
{
        WGPopLoginTypeFormSheet = STPopupStyleFormSheet,
        WGPopLoginTypeBottomSheet = STPopupStyleBottomSheet,
};

@interface MLSPopLoginViewController : BaseViewController
- (instancetype)init NS_UNAVAILABLE;

/**
 初始化

 @param type 类型
 @return MLSPopLoginViewController
 */
- (instancetype)initWithType:(WGPopLoginType)type;

/**
  弹出

 @param viewController 在哪个控制器里弹出
 @param completion 弹出完成回调
 @param dismiss 登录完成回调
 */
- (void)presentInViewController:(UIViewController *)viewController completion:(void (^)(void))completion dismiss:(void (^)(void))dismiss;
@end
