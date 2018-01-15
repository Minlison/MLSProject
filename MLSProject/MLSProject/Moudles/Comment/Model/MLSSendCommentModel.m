//
//  MLSSendCommentModel.m
//  MinLison
//
//  Created by minlison on 2017/10/26.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSSendCommentModel.h"

@implementation MLSSendCommentModel



+ (instancetype)commentModelWith:(LNArticleContentType)type pId:(NSString *)pid itemID:(NSString *)itemid;
{
        MLSSendCommentModel *model = [[self alloc] init];
        model.type       = type;
        model.pid        = pid;
        model.item_id    = itemid;
        return model;
}


@end
