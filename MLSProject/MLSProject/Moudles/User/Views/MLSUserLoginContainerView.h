//
//  MLSUserLoginContainerView.h
//  ChengziZdd
//
//  Created by MinLison on 2017/11/2.
//  Copyright © 2017年 chengzivr. All rights reserved.
//

#import "BaseView.h"

@interface MLSUserLoginContainerView : BaseView

/**
 文本框
 */
@property(nonatomic, assign) UIKeyboardType keyboardType;

/**
 是否显示倒计时
 */
@property(nonatomic, assign) BOOL showCountDownButton;

/**
 左侧图片
 */
@property(nonatomic, copy) UIImage *leftViewImg;

/**
 占位文字
 */
@property(nonatomic, copy) NSString *placeHolder;

/**
 是否显示底部线条
 */
@property(nonatomic, assign) BOOL showBootomLine;

/**
 倒计时

 @param action 事件回调
 */
- (void)setCountDownAction:(void (^)(void))action;
@end
