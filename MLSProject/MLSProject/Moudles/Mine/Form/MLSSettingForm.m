//
//  MLSSettingForm.m
//  MLSProject
//
//  Created by MinLison on 2017/12/12.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "MLSSettingForm.h"
#import "MLSMineNormalCell.h"
#import "MLSMineForm.h"
#import "MLSMineSwitchCell.h"
#import "MLSFindPwdViewController.h"
@implementation MLSSettingForm
- (instancetype)init
{
        self = [super init];
        if (self) {
                [self initializeForm];
        }
        return self;
}
- (void)initializeForm
{
        __block XLFormSectionDescriptor * section;
        __block XLFormRowDescriptor * row;
        UITableViewCell *cell;
        // 修改密码，消息通知，广告招商
        section = [XLFormSectionDescriptor formSectionWithTitle:@""];
        [self addFormSection:section];
        
        // 修改密码
        row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:LNMineFormRowDescriptorTypeCustom title:@"修改密码"];
        row.cellClass = [MLSMineNormalCell class];
        row.height = __WGHeight(51);
        [row.cellConfig setObject:@(UITableViewCellSelectionStyleNone) forKey:@keypath(cell,selectionStyle)];
        row.action.viewControllerClass = [MLSFindPwdViewController class];
        [section addFormRow:row];
        
        // 消息通知
        row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:LNMineFormRowDescriptorTypeCustom title:@"消息通知"];
        row.cellClass = [MLSMineSwitchCell class];
        row.height = __WGHeight(51);
        row.value = @(LNUserManager.userSetting.enablePushNotifaction);
        [row.cellConfig setObject:@(UITableViewCellSelectionStyleNone) forKey:@keypath(cell,selectionStyle)];
        row.action.viewControllerClass = nil;
        [section addFormRow:row];
        
        // 广告招商
        row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:LNMineFormRowDescriptorTypeCustom title:@"广告招商"];
        row.cellClass = [MLSMineNormalCell class];
        row.height = __WGHeight(51);
        [row.cellConfig setObject:@(UITableViewCellSelectionStyleNone) forKey:@keypath(cell,selectionStyle)];
        row.action.viewControllerClass = nil;
        [section addFormRow:row];
        
        section = [XLFormSectionDescriptor formSectionWithTitle:@""];
        [self addFormSection:section];
}
@end
