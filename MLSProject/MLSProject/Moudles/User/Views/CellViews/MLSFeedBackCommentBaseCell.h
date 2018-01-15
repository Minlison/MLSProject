//
//  MLSFeedBackCommentBaseCell.h
//  MinLison
//
//  Created by MinLison on 2017/11/20.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "MLSFeedBackCommentModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, WGFeedBackCommentActionType)
{
        /// 服务器定义（不喜欢，传参为0）
        WGFeedBackCommentActionTypeUnLike = 0,
        /// 服务器定义（喜欢，传参为1）
        WGFeedBackCommentActionTypeLike = 1,
};

typedef void (^WGFeedBackCommentActionSuccessBlock)(BOOL isSuccess);
typedef void (^WGFeedBackCommentActionBlock)( WGFeedBackCommentActionType actionType, MLSFeedBackCommentModel *model, WGFeedBackCommentActionSuccessBlock successBlock);

@interface MLSFeedBackCommentBaseCell : BaseTableViewCell  <NICell>

/**
 中间内容视图
 */
@property(nonatomic, strong, readonly) UIView *centerContentView;

/**
 内部按钮点击事件
 
 @param actionBlock 事件回调
 */
- (void)setCommentCellActionBlock:(WGFeedBackCommentActionBlock)actionBlock;

/**
 回复评论的属性字符串

 @param comment 评论内容
 @param userName 昵称
 @return 属性字符串
 */
- (NSAttributedString *)getAttributeCommentFormComment:(NSString *)comment userName:(NSString *)userName;

/**
 更新内容

 @param model 模型数据
 */
- (void)updateContentWithModel:(MLSFeedBackCommentModel *)model NS_REQUIRES_SUPER; 
@end


NS_ASSUME_NONNULL_END
