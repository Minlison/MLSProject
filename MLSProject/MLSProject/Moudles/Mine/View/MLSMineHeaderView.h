//
//  MLSMineHeaderView.h
//  MLSProject
//
//  Created by MinLison on 2017/12/8.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "BaseView.h"

typedef NS_ENUM(NSInteger, LNMineHeaderViewClickType)
{
        LNMineHeaderViewClickTypeUpdateUserInfo,
        LNMineHeaderViewClickTypeHeadImgClick,
};

typedef void (^LNMineHeaderViewClickBlock)(LNMineHeaderViewClickType type);

@interface MLSMineHeaderView : BaseView
@property(nonatomic, strong, readonly) UIImageView *backGroundView;

@property(nonatomic, copy) LNMineHeaderViewClickBlock actionBlock;
@end
