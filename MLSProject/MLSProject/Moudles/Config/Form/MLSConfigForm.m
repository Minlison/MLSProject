//
//  MLSConfigForm.m
//  MinLison
//
//  Created by MinLison on 2017/11/17.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSConfigForm.h"
#import "MLSConfigService.h"
@implementation MLSConfigForm
- (NSArray *)fields
{
        
        return @[
                 @{FXFormFieldKey : @"serverAddress25", FXFormFieldTitle : @"25测试服务器", FXFormFieldAction: @"serverAddress25", FXFormFieldType : FXFormFieldTypeOption,FXFormFieldDefaultValue : @([[MLSConfigService serverAddress] isEqualToString:kRequestUrlBase25])},
                 @{FXFormFieldKey : @"serverAddress40", FXFormFieldTitle : @"40测试服务器", FXFormFieldAction: @"serverAddress40", FXFormFieldType : FXFormFieldTypeOption,FXFormFieldDefaultValue : @([[MLSConfigService serverAddress] isEqualToString:kRequestUrlBase40])},
                 @{FXFormFieldKey : @"serverAddressTest", FXFormFieldTitle : @"Test测试服务器", FXFormFieldAction: @"serverAddressTest", FXFormFieldType : FXFormFieldTypeOption,FXFormFieldDefaultValue : @([[MLSConfigService serverAddress] isEqualToString:kRequestUrlBaseTest])},
                 @{FXFormFieldKey : @"serverAddressPreProduct", FXFormFieldTitle : @"预发布测试服务器", FXFormFieldAction: @"serverAddressPreProduct", FXFormFieldType : FXFormFieldTypeOption,FXFormFieldDefaultValue : @([[MLSConfigService serverAddress] isEqualToString:kRequestUrlBasePreProduct])},
                 @{FXFormFieldKey : @"serverAddressOnline", FXFormFieldTitle : @"正式服务器", FXFormFieldAction: @"serverAddressOnline", FXFormFieldType : FXFormFieldTypeOption,FXFormFieldDefaultValue : @([[MLSConfigService serverAddress] isEqualToString:kRequestUrlBaseOnline])},
                 @{FXFormFieldKey : @"showDebugView", FXFormFieldTitle : @"显示日志信息", FXFormFieldAction: @"showDebugView"},
                 @{FXFormFieldKey : @"logout", FXFormFieldTitle : @"退出登录", FXFormFieldAction: @"logout", FXFormFieldType : FXFormFieldTypeLabel},
                 @{FXFormFieldKey : @"clearCache", FXFormFieldTitle : @"清理缓存", FXFormFieldAction: @"clearCache", FXFormFieldType : FXFormFieldTypeLabel},
                 @{FXFormFieldKey : @"gotoOnlineApp", FXFormFieldTitle : @"跳转到正式应用", FXFormFieldAction: @"gotoOnlineApp", FXFormFieldType : FXFormFieldTypeLabel}
                 ];
}
- (NSArray *)extraFields
{
        return @[
                 @{FXFormFieldTitle: @"该功能仅适用于内测版本，如果要测试全部功能，请跳转到正式APP进行测试",
                 FXFormFieldType : FXFormFieldTypeLabel},
                 ];
}
@end
