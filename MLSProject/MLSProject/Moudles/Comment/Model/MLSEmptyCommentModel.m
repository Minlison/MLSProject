//
//  MLSEmptyCommentModel.m
//  MinLison
//
//  Created by MinLison on 2017/11/16.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSEmptyCommentModel.h"
#import "MLSEmptyCommentTableViewCell.h"
@interface MLSEmptyCommentModel ()
@end
@implementation MLSEmptyCommentModel
+ (instancetype)emptyModel
{
        MLSEmptyCommentModel *model = [[MLSEmptyCommentModel alloc] init];
        model.emptyContent = [NSString aPP_MoreSupportAndMoreWonderful];
        return model;
}
- (Class)cellClass
{
        return [MLSEmptyCommentTableViewCell class];
}
@end

