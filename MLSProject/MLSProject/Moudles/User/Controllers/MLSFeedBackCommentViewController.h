//
//  MLSFeedBackCommentViewController.h
//  MinLison
//
//  Created by MinLison on 2017/11/8.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseTableViewController.h"
#import "MLSFeedBackCommentView.h"

/**
 反馈评论类型

 - WGFeedBackCommentTypeTop: 顶置
 - WGFeedBackCommentTypeNew: 最新
 */
typedef NS_ENUM(NSInteger, WGFeedBackCommentType)
{
        WGFeedBackCommentTypeTop = WGCommentListTypeStickTop,
        WGFeedBackCommentTypeNew = WGCommentListTypeNormal,
};

@interface MLSFeedBackCommentViewController : BaseTableViewController <MLSFeedBackCommentView *>

/**
 创建控制器

 @param commentType 评论类型
 @param itemID 评论的 ID
 @return  控制器
 */
- (instancetype)initWithCommentType:(WGFeedBackCommentType)commentType itemID:(NSString *)itemID NS_DESIGNATED_INITIALIZER;

/**
 use - initWithCommentType:itemID:
 */
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithStyle:(UITableViewStyle)style NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
@end
