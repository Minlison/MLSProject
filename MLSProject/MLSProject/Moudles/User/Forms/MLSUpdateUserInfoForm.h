//
//  MLSUpdateUserInfoForm.h
//  MLSProject
//
//  Created by 袁航 on 2017/12/9.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "BaseModel.h"
typedef NS_ENUM(NSInteger, LNUpdateUserInfoType)
{
        LNUpdateUserInfoTypeNickName,
        LNUpdateUserInfoTypeRealName,
        LNUpdateUserInfoTypePhone,
        LNUpdateUserInfoTypeIDNumber,
        LNUpdateUserInfoTypeGender,
        LNUpdateUserInfoTypeBirthday,
        LNUpdateUserInfoTypeAddress,
        LNUpdateUserInfoTypeEmail,
        LNUpdateUserInfoTypeMax
};

//FOUNDATION_EXTERN NSString *const LNUpdateUserInfoRowDescriptorTypeNickName;
//FOUNDATION_EXTERN NSString *const LNUpdateUserInfoRowDescriptorTypeRealName;
//FOUNDATION_EXTERN NSString *const LNUpdateUserInfoRowDescriptorTypePhone;
//FOUNDATION_EXTERN NSString *const LNUpdateUserInfoRowDescriptorTypeIDNumber;
//FOUNDATION_EXTERN NSString *const LNUpdateUserInfoRowDescriptorTypeGender;
//FOUNDATION_EXTERN NSString *const LNUpdateUserInfoRowDescriptorTypeBirthday;
//FOUNDATION_EXTERN NSString *const LNUpdateUserInfoRowDescriptorTypeAddress;
//FOUNDATION_EXTERN NSString *const LNUpdateUserInfoRowDescriptorTypeEmail;

@interface MLSUpdateUserInfoForm : XLFormDescriptor
@end
