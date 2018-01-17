//
//  MLSUserSetPwdForm.m
//  MLSProject
//
//  Created by MinLison on 2017/12/12.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "MLSUserSetPwdForm.h"
#import "MLSUserFormButtonCell.h"
#import "MLSUserAgreementCell.h"
#import "MLSUserFormPhoneCell.h"
#import "MLSUserFormSMSCell.h"
#import "MLSUserNextCell.h"
#import "MLSUserPwdCell.h"
#import "MLSSetPwdCompleteCell.h"
@implementation MLSUserSetPwdForm
- (instancetype)initWithType:(MLSSetPwdType)type
{
        if (self = [super init]) {
                self.type = type;
        }
        return self;
}
- (NSArray *)fields
{
        return @[
                 @{FXFormFieldKey : @keypath(self,password), FXFormFieldTitle : @"", FXFormFieldCell : [MLSUserPwdCell class], FXFormFieldPlaceholder : @"请输入6位数字密码"},
                 @{FXFormFieldKey : @keypath(self,repeatPassword), FXFormFieldTitle : @"", FXFormFieldCell : [MLSUserPwdCell class], FXFormFieldPlaceholder : @"确认密码"},
                 ];
}
- (void)setPassword:(NSString *)password
{
        _password = password;
        MLSUserManager.password = password;
}
- (void)setRepeatPassword:(NSString *)repeatPassword
{
        _repeatPassword = repeatPassword;
        MLSUserManager.repeat_password = repeatPassword;
}

- (NSArray *)extraFields
{
        NSString *title = @"";
        switch (self.type) {
                case MLSSetPwdTypeRegister:
                {
                        title = @"完成注册";
                }
                        break;
                case MLSSetPwdTypeFindPwd:
                {
                        title = @"完成修改";
                }
                        break;
                
                        
                default:
                        break;
        }
        return @[
                 @{FXFormFieldTitle : title, FXFormFieldCell : [MLSSetPwdCompleteCell class], FXFormFieldAction: @"next"}
                 ];
}

- (void)dealloc
{
        MLSUserManager.password = nil;
}
@end
