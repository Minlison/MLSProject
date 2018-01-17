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
NSString *const MLSUpdateUserInfoFormCustomCell = @"MLSUpdateUserInfoFormCustomCell";
//NSString *const MLSUpdateUserInfoRowDescriptorTypeNickName = @"MLSUpdateUserInfoRowDescriptorTypeNickName";
//NSString *const MLSUpdateUserInfoRowDescriptorTypeRealName = @"MLSUpdateUserInfoRowDescriptorTypeRealName";
//NSString *const MLSUpdateUserInfoRowDescriptorTypePhone = @"MLSUpdateUserInfoRowDescriptorTypePhone";
//NSString *const MLSUpdateUserInfoRowDescriptorTypeIDNumber = @"MLSUpdateUserInfoRowDescriptorTypeIDNumber";
//NSString *const MLSUpdateUserInfoRowDescriptorTypeGender = @"MLSUpdateUserInfoRowDescriptorTypeGender";
//NSString *const MLSUpdateUserInfoRowDescriptorTypeBirthday = @"MLSUpdateUserInfoRowDescriptorTypeBirthday";
//NSString *const MLSUpdateUserInfoRowDescriptorTypeAddress = @"MLSUpdateUserInfoRowDescriptorTypeAddress";
//NSString *const MLSUpdateUserInfoRowDescriptorTypeEmail = @"MLSUpdateUserInfoRowDescriptorTypeEmail";

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
        row.value = MLSUserManager.img;
        row.title = @"头像";
        row.cellClass = [MLSUpdateUserInfoHeadImgCell class];
        [section addFormRow:row];
        
        // 底部视图
        NSArray <NSString *>*titlesArr = @[@"昵称",@"真实姓名",@"手机号码",@"身份证号码",@"性别",@"出生日期",@"联系地址",@"邮箱"];
        NSArray <NSString *>*tags = @[
                                      @keypath(MLSUserManager,nickname),
                                       @keypath(MLSUserManager,name),
                                       @keypath(MLSUserManager,mobile),
                                       @keypath(MLSUserManager,id_number),
                                       @keypath(MLSUserManager,gender),
                                       @keypath(MLSUserManager,date),
                                       @keypath(MLSUserManager,address),
                                       @keypath(MLSUserManager,email)
                                       ];
        section = [XLFormSectionDescriptor formSectionWithTitle:@"Other"];
        [self addFormSection:section];
        
        for (int i = 0; i < MLSUpdateUserInfoTypeMax; i++)
        {
                row = [XLFormRowDescriptor formRowDescriptorWithTag:tags[i] rowType:@(i).stringValue title:titlesArr[i]];
                row.value = NOT_NULL_STRING([MLSUserManager valueForKey:tags[i]],@"");
                row.subTitle = NOT_NULL_STRING([MLSUserManager valueForKey:tags[i]],@"未设置");
                row.cellClass = [MLSUpdateUserInfoCell class];
                row.action.viewControllerClass = [MLSModifyInfoViewController class];
                [section addFormRow:row];
        }
}
@end
