//
//  MLSUserLoginView.h
//  ChengziZdd
//
//  Created by MinLison on 2017/11/1.
//  Copyright © 2017年 chengzivr. All rights reserved.
//

#import "BaseTableControllerView.h"

@interface MLSUserLoginView : BaseControllerView
/**
 点击事件
 
 @param action 事件
 */
- (void)setLoginAction:(void (^)(WGThirdLoginType type))action;


/**
 获取验证码

 @param action 事件
 */
- (void)setGetSMSAction:(void (^)(void))action;
@end
