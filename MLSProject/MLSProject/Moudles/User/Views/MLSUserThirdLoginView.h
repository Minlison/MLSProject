//
//  MLSUserThirdLoginView.h
//  MinLison
//
//  Created by MinLison on 2017/11/2.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseView.h"

@interface MLSUserThirdLoginView : BaseView

/**
 点击事件

 @param action 事件
 */
- (void)setThirdLoginAction:(void (^)(MLSLoginType type))action;
@end
