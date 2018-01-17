//
//  MLSRegisterNotNewUserView.h
//  MLSProject
//
//  Created by MinLison on 2017/12/12.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "BaseControllerView.h"

typedef NS_ENUM(NSInteger,MLSRegisterNotNewUserViewClickType)
{
        MLSRegisterNotNewUserViewClickTypeMineLoginRightNow,
        MLSRegisterNotNewUserViewClickTypeForgetPwdAndReset,
        MLSRegisterNotNewUserViewClickTypeChangePhoneToRegister,
};
typedef void (^MLSRegisterNotNewUserViewActionBlock)(MLSRegisterNotNewUserViewClickType type);
@interface MLSRegisterNotNewUserView : BaseControllerView
@property(nonatomic, copy) MLSRegisterNotNewUserViewActionBlock actionBlock;
@end
