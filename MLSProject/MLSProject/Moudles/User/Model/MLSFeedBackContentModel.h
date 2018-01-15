//
//  MLSFeedBackContentModel.h
//  MinLison
//
//  Created by MinLison on 2017/11/8.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseModel.h"

@interface MLSFeedBackContentModel : BaseModel <NICellObject>

/**
 id
 */
@property(nonatomic, copy) NSString *id;

/**
 标题
 */
@property(nonatomic, copy) NSString *title;

/**
 内容
 */
@property(nonatomic, copy) NSString *content;

/**
 时间
 */
@property(nonatomic, copy) NSString *time;

/**
 用户 ID
 */
@property(nonatomic, copy) NSString *uid;

/**
 用户昵称
 */
@property(nonatomic, copy) NSString *nickname;

/**
 用户头像
 */
@property(nonatomic, copy) NSString *img;
@end
