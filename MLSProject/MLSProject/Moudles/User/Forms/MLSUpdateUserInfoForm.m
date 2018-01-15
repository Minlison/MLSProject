//
//  MLSUpdateUserInfoForm.m
//  MLSProject
//
//  Created by 袁航 on 2017/12/9.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "MLSUpdateUserInfoForm.h"
#import "MLSUpdateUserInfoCell.h"
#import "MLSUpdateUserInfoHeadImgCell.h"
#import "MLSModifyInfoViewController.h"
NSString *const LNUpdateUserInfoFormCustomCell = @"LNUpdateUserInfoFormCustomCell";
//NSString *const LNUpdateUserInfoRowDescriptorTypeNickName = @"LNUpdateUserInfoRowDescriptorTypeNickName";
//NSString *const LNUpdateUserInfoRowDescriptorTypeRealName = @"LNUpdateUserInfoRowDescriptorTypeRealName";
//NSString *const LNUpdateUserInfoRowDescriptorTypePhone = @"LNUpdateUserInfoRowDescriptorTypePhone";
//NSString *const LNUpdateUserInfoRowDescriptorTypeIDNumber = @"LNUpdateUserInfoRowDescriptorTypeIDNumber";
//NSString *const LNUpdateUserInfoRowDescriptorTypeGender = @"LNUpdateUserInfoRowDescriptorTypeGender";
//NSString *const LNUpdateUserInfoRowDescriptorTypeBirthday = @"LNUpdateUserInfoRowDescriptorTypeBirthday";
//NSString *const LNUpdateUserInfoRowDescriptorTypeAddress = @"LNUpdateUserInfoRowDescriptorTypeAddress";
//NSString *const LNUpdateUserInfoRowDescriptorTypeEmail = @"LNUpdateUserInfoRowDescriptorTypeEmail";

@implementation MLSUpdateUserInfoForm
- (instancetype)init
{
        self = [super init];
        if (self)
        {
                [self initializeForm];
        }
        return self;
}

- (void)initializeForm
{
        __block XLFormSectionDescriptor * section;
        __block XLFormRowDescriptor * row;
        
        // 头像
        section = [XLFormSectionDescriptor formSectionWithTitle:@"HeadImg"];
        [self addFormSection:section];
        row = [XLFormRowDescriptor formRowDescriptorWithTag:@"order" rowType:XLFormRowDescriptorTypeImage];
        row.value = LNUserManager.img;
        row.title = @"头像";
        row.cellClass = [MLSUpdateUserInfoHeadImgCell class];
        [section addFormRow:row];
        
        // 底部视图
        NSArray <NSString *>*titlesArr = @[@"昵称",@"真实姓名",@"手机号码",@"身份证号码",@"性别",@"出生日期",@"联系地址",@"邮箱"];
        NSArray <NSString *>*tags = @[
                                      @keypath(LNUserManager,nickname),
                                       @keypath(LNUserManager,name),
                                       @keypath(LNUserManager,mobile),
                                       @keypath(LNUserManager,id_number),
                                       @keypath(LNUserManager,gender),
                                       @keypath(LNUserManager,date),
                                       @keypath(LNUserManager,address),
                                       @keypath(LNUserManager,email)
                                       ];
        section = [XLFormSectionDescriptor formSectionWithTitle:@"Other"];
        [self addFormSection:section];
        
        for (int i = 0; i < LNUpdateUserInfoTypeMax; i++)
        {
                row = [XLFormRowDescriptor formRowDescriptorWithTag:tags[i] rowType:@(i).stringValue title:titlesArr[i]];
                row.value = NOT_NULL_STRING([LNUserManager valueForKey:tags[i]],@"");
                row.subTitle = NOT_NULL_STRING([LNUserManager valueForKey:tags[i]],@"未设置");
                row.cellClass = [MLSUpdateUserInfoCell class];
                row.action.viewControllerClass = [MLSModifyInfoViewController class];
                [section addFormRow:row];
        }
}
@end
