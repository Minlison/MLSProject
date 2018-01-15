//
//  MLSFormLoginView.h
//  MinLison
//
//  Created by MinLison on 2017/11/3.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseTableControllerView.h"

typedef NS_ENUM(NSInteger, LNFormLoginViewClickType)
{
        LNFormLoginViewClickTypeGetSmsCode,
        LNFormLoginViewClickTypeLoginClick,
        LNFormLoginViewClickTypeThirdLoginClick,
        LNFormLoginViewClickTypeGetCountryCode,
        LNFormLoginViewClickTypeFindPwd,
};
typedef void (^LNUserStringActionBlock)(NSString * _Nullable str);
typedef void (^LNFormLoginViewClickActionBlock)(LNFormLoginViewClickType clickType, LNLoginType type, NSDictionary * _Nullable param, LNUserStringActionBlock _Nullable contryCode);

@interface MLSFormLoginView : BaseTableControllerView
@property (nonatomic, strong, readonly) FXFormController *formController;
/**
 事件点击回调
 */
@property(nonatomic, copy, nullable) LNFormLoginViewClickActionBlock actionBlock;
@end
