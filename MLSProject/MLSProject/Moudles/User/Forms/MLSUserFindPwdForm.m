//
//  MLSUserFindPwdForm.m
//  MLSProject
//
//  Created by MinLison on 2017/12/12.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "MLSUserFindPwdForm.h"
#import "MLSUserFormButtonCell.h"
#import "MLSUserAgreementCell.h"
#import "MLSUserFormPhoneCell.h"
#import "MLSUserFormSMSCell.h"
#import "MLSUserNextCell.h"
#import "MLSUserPwdCell.h"
#import "MLSUserFindPwdNextCell.h"
@implementation MLSUserFindPwdForm

- (NSArray *)fields
{
        return @[
                 @{FXFormFieldKey : @keypath(self,mobile),FXFormFieldDefaultValue : NOT_NULL_STRING_DEFAULT_EMPTY(MLSUserManager.mobile), FXFormFieldTitle : @"", FXFormFieldCell : [MLSUserFormPhoneCell class], FXFormFieldPlaceholder : @"注册手机号"},
                 @{FXFormFieldKey : @keypath(self,sms_code), FXFormFieldTitle : @"", FXFormFieldCell : [MLSUserFormSMSCell class], FXFormFieldPlaceholder : @"验证码",FXFormFieldAction: @"getSmsCode"},
                 ];
}
- (void)setMobile:(NSString *)mobile
{
        _mobile = mobile;
        MLSUserManager.mobile = mobile;
}
- (void)setSms_code:(NSString *)sms_code
{
        _sms_code = sms_code;
        MLSUserManager.sms_code = sms_code;
}

- (NSArray *)extraFields
{
        return @[
                 @{FXFormFieldTitle : @"下一步", FXFormFieldCell : [MLSUserFindPwdNextCell class], FXFormFieldAction: @"next"}
                 ];
}

- (void)dealloc
{
        MLSUserManager.repeat_password = nil;
}
@end
