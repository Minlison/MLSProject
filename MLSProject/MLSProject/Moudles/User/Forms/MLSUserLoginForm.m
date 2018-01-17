//
//  MLSUserLoginForm.m
//  MinLison
//
//  Created by MinLison on 2017/11/3.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSUserLoginForm.h"
#import "MLSUserFormSMSCell.h"
#import "MLSUserFormSubmitCell.h"
#import "MLSUserFormPhoneCell.h"
#import "ISO3166CountryValueTransformer.h"
#import "MLSUserPwdCell.h"
#import "MLSUserFindPwdCell.h"
#import "MLSUserWebCatLoginCell.h"
@implementation MLSUserLoginForm
- (NSArray *)fields
{
        return @[
                 @{FXFormFieldKey : @keypath(self,mobile), FXFormFieldTitle : @"", FXFormFieldCell : [MLSUserFormPhoneCell class], FXFormFieldPlaceholder : [NSString aPP_PhoneNum]},
                 @{FXFormFieldKey : @keypath(self,password), FXFormFieldTitle : @"", FXFormFieldCell : [MLSUserPwdCell class], FXFormFieldPlaceholder : @"密码"},
                 ];
}
- (void)setCountry_code:(NSString *)country_code
{
        _country_code = country_code;
        MLSUserManager.country_code = country_code;
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
- (void)setPassword:(NSString *)password
{
        _password = password;
        MLSUserManager.password = password;
}
- (NSArray *)extraFields
{
        return @[
                 @{FXFormFieldTitle : @"findPwd", FXFormFieldCell : [MLSUserFindPwdCell class], FXFormFieldAction: @"findPwd"},
                 @{FXFormFieldKey : @"login", FXFormFieldTitle : @"登录", FXFormFieldCell : [MLSUserFormSubmitCell class], FXFormFieldAction: @"phoneLogin"},
                 @{FXFormFieldKey : @"webcatlogin", FXFormFieldTitle : @"微信登录", FXFormFieldCell : [MLSUserWebCatLoginCell class], FXFormFieldAction: @"webCatLogin"}
                 ];
}
@end
