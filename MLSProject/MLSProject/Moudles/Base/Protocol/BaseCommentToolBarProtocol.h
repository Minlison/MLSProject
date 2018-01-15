//
//  BaseCommentToolBarProtocol.h
//  MinLison
//
//  Created by MinLison on 2017/11/7.
//  Copyright © 2017年 minlison. All rights reserved.
//

#ifndef BaseCommentToolBarProtocol_h
#define BaseCommentToolBarProtocol_h

#import <UIKit/UIKit.h>
@protocol BaseCommentToolBarProtocol;
typedef NS_ENUM(NSInteger,BaseCommentToolBarActionType )
{
        /// 发送
        BaseCommentToolBarActionTypeSend,
        /// 表情符号键盘显示
        BaseCommentToolBarActionTypeShowEmotion,
        /// 表情符号键盘隐藏
        BaseCommentToolBarActionTypeHideEmotion,
        /// 文字无效
        BaseCommentToolBarActionTypeTextNotValid,
};

typedef void (^BaseCommentToolBarActionBlock)(BaseCommentToolBarActionType type, id <BaseCommentToolBarProtocol> tooBar);

@protocol BaseCommentToolBarDelegate <NSObject>

/**
 将要弹出

 @param commentTooBar  commentToolBar
 @return  是否允许弹出
 */
- (BOOL)commentToolBarWillShow:(UIView <BaseCommentToolBarProtocol>*)commentTooBar;

/**
 将要隐藏

 @param commentTooBar commentToolBar
 @return  是否允许隐藏
 */
- (BOOL)commentToolBarWillHide:(UIView <BaseCommentToolBarProtocol>*)commentTooBar;

@end


@protocol BaseCommentToolBarProtocol <NSObject>

/**
 显示文字的视图
 */
@property(nonatomic, strong, readonly) UIView <US2ValidatorUIProtocol,UITextInput, UIContentSizeCategoryAdjusting>* realTextView;

/**
 代理
 */
@property(nonatomic, weak) id <BaseCommentToolBarDelegate> delegate;

/**
 文字
 */
@property(nonatomic, copy, readonly) NSString *text;

/**
 是否正在显示表情
 */
@property(nonatomic, assign, getter=isShowingEmotion, readonly) BOOL showingEmotion;

/**
 点击事件
 */
- (void)setToolBarActionBlock:(BaseCommentToolBarActionBlock)actionBlock;

/**
 是否可自动增加高度
 */
- (void)setAutoResizable:(BOOL)autoResizable;

/**
 设置占位字符

 @param placeHolder 占位字符 可以是 NSString，或者是 NSAttributeString
 */
- (void)setPlaceHolder:(id)placeHolder;

/**
 表情管理

 @param emotionManager 表情
 */
- (void)setEmotionManager:(QMUIQQEmotionManager *)emotionManager;

/**
 设置最大的高度（自增高的时候才会使用）

 @param maxExpandHeight 最大的高度
 */
- (void)setMaxExpandHeight:(CGFloat)maxExpandHeight;

@end

#endif /* BaseCommentToolBarProtocol_h */
