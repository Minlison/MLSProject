//
//  BaseCommentToolBar.h
//  MinLison
//
//  Created by MinLison on 2017/11/7.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseView.h"
#import "BaseCommentToolBarProtocol.h"

@interface BaseCommentToolBar : BaseView <BaseCommentToolBarProtocol>

/**
 代理
 */
@property(nonatomic, weak) id <BaseCommentToolBarDelegate> delegate;
/**
 创建
 
 @param emotion 是否有表情符号
 @return  toolBar
 */
- (instancetype)initWithEmotion:(BOOL)emotion NS_DESIGNATED_INITIALIZER;
@end
