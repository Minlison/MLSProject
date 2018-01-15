//
//  MLSUserView.h
//  MinLison
//
//  Created by MinLison on 2017/10/26.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseTableControllerView.h"

/**
 事件类型

 - WGUserViewActionTypeHeadClick: 头像点击
 - WGUserViewActionTypeFeedBackClick: 反馈按钮点击
 */
typedef NS_ENUM(NSInteger, WGUserViewActionType)
{
        WGUserViewActionTypeHeadClick,
        WGUserViewActionTypeFeedBackClick,
};

typedef void (^WGUserViewActionBlock)(WGUserViewActionType type);

@interface MLSUserView : BaseTableControllerView
/**
 头像点击

 @param clickBlock 头像点击
 */
- (void)setUserViewActionBlock:(WGUserViewActionBlock)clickBlock;
@end
