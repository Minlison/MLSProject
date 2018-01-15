//
//  MLSCommentModel.h
//  MinLison
//
//  Created by minlison on 2017/10/26.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseModel.h"

@interface MLSCommentModel : BaseModel <NICellObject>
/**
 评论 ID
 */
@property (nonatomic,copy) NSString *id;
/**
 评论内容
 */
@property (nonatomic,copy) NSString *content;
/**
 评论时间（unix时间戳）
 */
@property (nonatomic,copy) NSString *time;
/**
 点赞数量
 */
@property (nonatomic,copy) NSString *like;
/**
 评论者用户ID
 */
@property (nonatomic,copy) NSString *uid;
/**
 评论者的呢称
 */
@property (nonatomic,copy) NSString *nickname;
/**
 评论者的头像
 */
@property (nonatomic,copy) NSString *img;
/**
 被回复的用户 ID（没有时为空）
 */
@property (nonatomic,copy) NSString *reply_user_id;
/**
 被回复的用户呢称（没有时为空）
 */
@property (nonatomic,copy) NSString *reply_nickname;
/**
 被回复的内容（没有时为空）
 */
@property (nonatomic,copy) NSString *reply_content;
/**
 是否点赞
 */
@property (nonatomic,assign) BOOL islike;
@end
