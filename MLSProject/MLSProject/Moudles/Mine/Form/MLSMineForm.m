//
//  MLSMineForm.m
//  MLSProject
//
//  Created by MinLison on 2017/12/8.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "MLSMineForm.h"
NSString *const LNMineFormRowDescriptorTypeCustom = @"LNMineFormRowDescriptorTypeCustom";
NSString *const LNMineFormOptionsObjectControllerKey = @"LNMineFormOptionsObjectControllerKey";
NSString *const LNMineFormOptionsObjectImageKey = @"LNMineFormOptionsObjectImageKey";
NSString *const LNMineFormOptionsObjectTitleKey = @"LNMineFormOptionsObjectTitleKey";
@implementation MLSMineForm
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
//        // 顶部四个视图
//        section = [XLFormSectionDescriptor formSectionWithTitle:@"Order"];
//        [self addFormSection:section];
//        row = [XLFormRowDescriptor formRowDescriptorWithTag:@"order" rowType:LNMineFormRowDescriptorTypeCustom];
//        row.cellClass = [MLSMineOrderCell class];
//        row.height = __WGHeight(87);
//        [section addFormRow:row];
        
        section = [XLFormSectionDescriptor formSectionWithTitle:nil];
        [self addFormSection:section];
        NSArray <NSString *>*normalCellTitles = @[
                                                  @"设置"
                                                  ];
        NSArray <Class>*normalCellTargetClass = @[
                                                  [MLSMineSettingViewController class]
                                                  ];
        [normalCellTitles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:LNMineFormRowDescriptorTypeCustom title:obj];
                row.cellClass = [MLSMineNormalCell class];
                row.height = __WGHeight(51);
                row.action.viewControllerPresentationMode = XLFormPresentationModePush;
                [row.cellConfig setObject:@(UITableViewCellSelectionStyleNone) forKey:@keypath(cell,selectionStyle)];
                row.action.viewControllerClass = normalCellTargetClass[idx];
                [section addFormRow:row];
        }];
}
@end
