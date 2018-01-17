//
//  MLSMineView.h
//  MLSProject
//
//  Created by MinLison on 2017/11/30.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "BaseTableControllerView.h"
#import "MLSMineHeaderView.h"
/**
 事件

 - MLSMineViewClickTypeUpdateUserInfo: 更新用户信息
 */
typedef NS_ENUM(NSInteger, MLSMineViewClickType)
{
        MLSMineViewClickTypeUpdateUserInfo = MLSMineHeaderViewClickTypeUpdateUserInfo,
        MLSMineViewClickTypeHeadImgClick = MLSMineHeaderViewClickTypeHeadImgClick,
};

typedef void (^MLSMineViewClickBlock)(MLSMineViewClickType type);

@interface MLSMineView : BaseTableControllerView

/**
 事件回调
 */
@property(nonatomic, copy) MLSMineViewClickBlock actionBlock;
@end
