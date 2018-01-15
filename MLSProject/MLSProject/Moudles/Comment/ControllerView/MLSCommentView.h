//
//  MLSCommentView.h
//  MinLison
//
//  Created by minlison on 2017/10/26.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseControllerView.h"
#import "MLSCommentModel.h"
#import "MLSCommentTableViewCell.h"
#import "BaseTableControllerView.h"


@interface MLSCommentView : BaseTableControllerView  <QMUITableViewDelegate>

/**
 设置对应评论类型的个数
 
 @param count 个数
 @param type 类型
 */
- (void)setCommentCount:(NSUInteger)count type:(WGCommentListType)type;
/**
 增加对应评论类型的个数
 
 @param count 个数
 @param type 类型
 */
- (void)addCommentCount:(NSUInteger)count type:(WGCommentListType)type;
@end
