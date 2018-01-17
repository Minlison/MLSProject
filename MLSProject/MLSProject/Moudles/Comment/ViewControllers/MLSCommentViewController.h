//
//  MLSCommentViewController.h
//  MinLison
//
//  Created by minlison on 2017/10/26.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseTableViewController.h"
#import "MLSCommentView.h"
#import "MLSCommentModel.h"

typedef void (^WGSendCommentCallBackBlock)(NSArray <MLSCommentModel *> *models);

@interface MLSCommentViewController : BaseTableViewController <MLSCommentView *>

/**
 评论控制器

 @param itemID 内容 ID
 @param contentType  内容类型
 @return MLSCommentViewController
 */
+ (instancetype)commentViewControllerWithItemID:(NSString *)itemID contentType:(MLSArticleContentType)contentType;

/**
 评论回调

 @param callBack 回调
 */
- (void)setSendCommentCallBackBlock:(WGSendCommentCallBackBlock)callBack;

/**
 设置对应评论类型的个数

 @param count 个数
 @param type 类型
 */
- (void)setCommentCount:(NSUInteger)count type:(WGCommentListType)type;
@end
