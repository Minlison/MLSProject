//
//  MLSFormLoginView.h
//  MinLison
//
//  Created by MinLison on 2017/11/3.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseTableControllerView.h"

typedef NS_ENUM(NSInteger, MLSFormLoginViewClickType)
{
        MLSFormLoginViewClickTypeGetSmsCode,
        MLSFormLoginViewClickTypeLoginClick,
        MLSFormLoginViewClickTypeThirdLoginClick,
        MLSFormLoginViewClickTypeGetCountryCode,
        MLSFormLoginViewClickTypeFindPwd,
};
typedef void (^MLSUserStringActionBlock)(NSString * _Nullable str);
typedef void (^MLSFormLoginViewClickActionBlock)(MLSFormLoginViewClickType clickType, MLSLoginType type, NSDictionary * _Nullable param, MLSUserStringActionBlock _Nullable contryCode);

@interface MLSFormLoginView : BaseTableControllerView
@property (nonatomic, strong, readonly) FXFormController *formController;
/**
 事件点击回调
 */
@property(nonatomic, copy, nullable) MLSFormLoginViewClickActionBlock actionBlock;
@end
