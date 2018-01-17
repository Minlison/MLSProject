//
//  MLSUpdateUserInfoForm.h
//  MLSProject
//
//  Created by 袁航 on 2017/12/9.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "BaseModel.h"
typedef NS_ENUM(NSInteger, MLSUpdateUserInfoType)
{
        MLSUpdateUserInfoTypeNickName,
        MLSUpdateUserInfoTypeRealName,
        MLSUpdateUserInfoTypePhone,
        MLSUpdateUserInfoTypeIDNumber,
        MLSUpdateUserInfoTypeGender,
        MLSUpdateUserInfoTypeBirthday,
        MLSUpdateUserInfoTypeAddress,
        MLSUpdateUserInfoTypeEmail,
        MLSUpdateUserInfoTypeMax
};

//FOUNDATION_EXTERN NSString *const MLSUpdateUserInfoRowDescriptorTypeNickName;
//FOUNDATION_EXTERN NSString *const MLSUpdateUserInfoRowDescriptorTypeRealName;
//FOUNDATION_EXTERN NSString *const MLSUpdateUserInfoRowDescriptorTypePhone;
//FOUNDATION_EXTERN NSString *const MLSUpdateUserInfoRowDescriptorTypeIDNumber;
//FOUNDATION_EXTERN NSString *const MLSUpdateUserInfoRowDescriptorTypeGender;
//FOUNDATION_EXTERN NSString *const MLSUpdateUserInfoRowDescriptorTypeBirthday;
//FOUNDATION_EXTERN NSString *const MLSUpdateUserInfoRowDescriptorTypeAddress;
//FOUNDATION_EXTERN NSString *const MLSUpdateUserInfoRowDescriptorTypeEmail;

@interface MLSUpdateUserInfoForm : XLFormDescriptor
@end
