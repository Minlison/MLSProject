//
//  MLSFeedBackCommentContentModel.h
//  MinLison
//
//  Created by MinLison on 2017/11/20.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseModel.h"

@interface MLSFeedBackCommentContentModel : BaseModel <NICellObject>
/**
 评论的视图
 */
@property(nonatomic, weak) UIView *commentContentView;

/**
 tableView 的偏移量 observer
 */
@property(nonatomic, assign) CGFloat offset;

/**
 内容大小
 */
@property(nonatomic, assign) CGSize contentSize;
@end
