//
//  MLSCommentTableViewCell.h
//  MinLison
//
//  Created by minlison on 2017/10/26.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLSCommentModel.h"
#import "BaseTableViewCell.h"
typedef NS_ENUM(NSInteger, WGCommentActionType)
{
        /// 服务器定义（不喜欢，传参为0）
        WGCommentActionTypeUnLike = 0,
        /// 服务器定义（喜欢，传参为1）
        WGCommentActionTypeLike = 1,
};
typedef void (^WGCommentActionSuccessBlock)(BOOL isSuccess);
typedef void (^WGCommentActionBlock)( WGCommentActionType actionType, MLSCommentModel *model, WGCommentActionSuccessBlock successBlock);

@interface MLSCommentTableViewCell : BaseTableViewCell <NICell>

/**
 模型数据
 */
@property (nonatomic,strong) MLSCommentModel *model;

/**
 内部按钮点击事件
 
 @param actionBlock 事件回调
 */
- (void)setCommentCellActionBlock:(WGCommentActionBlock)actionBlock;
@end
