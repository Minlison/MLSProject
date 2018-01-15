//
//  MLSRegisterNotNewUserView.h
//  MLSProject
//
//  Created by MinLison on 2017/12/12.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "BaseControllerView.h"

typedef NS_ENUM(NSInteger,LNRegisterNotNewUserViewClickType)
{
        LNRegisterNotNewUserViewClickTypeMineLoginRightNow,
        LNRegisterNotNewUserViewClickTypeForgetPwdAndReset,
        LNRegisterNotNewUserViewClickTypeChangePhoneToRegister,
};
typedef void (^LNRegisterNotNewUserViewActionBlock)(LNRegisterNotNewUserViewClickType type);
@interface MLSRegisterNotNewUserView : BaseControllerView
@property(nonatomic, copy) LNRegisterNotNewUserViewActionBlock actionBlock;
@end
