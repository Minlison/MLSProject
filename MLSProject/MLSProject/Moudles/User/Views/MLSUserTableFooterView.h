//
//  MLSUserTableFooterView.h
//  MinLison
//
//  Created by MinLison on 2017/11/1.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseView.h"

@interface MLSUserTableFooterView : BaseView

/**
 点击意见反馈事件

 @param action 事件
 */
- (void)setFeedBackAction:(void (^)(void))action;
@end
