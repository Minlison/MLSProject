//
//  MLSUpdateUserInfoViewController.h
//  MinLison
//
//  Created by MinLison on 2017/11/5.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseViewController.h"
#import "MLSUpdateUserInfoView.h"
@interface MLSUpdateUserInfoViewController : XLFormViewController <MLSUpdateUserInfoView *>

/**
 弹出
 
 @param viewController 在哪个控制器里弹出
 @param dismiss 退出回调，当 push 的时候，不会调用
 */
- (void)presentOrPushInViewController:(UIViewController *)viewController dismiss:(void (^)(void))dismiss;
@end
