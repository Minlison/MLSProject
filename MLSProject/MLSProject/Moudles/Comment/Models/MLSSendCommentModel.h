//
//  MLSSendCommentModel.h
//  MinLison
//
//  Created by minlison on 2017/10/26.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseModel.h"

@interface MLSSendCommentModel : BaseModel
/**
  内容 ID
 */
@property (nonatomic,copy) NSString *item_id;
/**
 被回复的评论 ID
 */
@property (nonatomic,copy) NSString *pid;
/**
 评论内容
 */
@property (nonatomic,copy) NSString *content;
/**
 内容类型
 */
@property (nonatomic,assign) MLSArticleContentType type;


+ (instancetype)commentModelWith:(MLSArticleContentType)type pId:(NSString *)pid itemID:(NSString *)itemid ;
@end
