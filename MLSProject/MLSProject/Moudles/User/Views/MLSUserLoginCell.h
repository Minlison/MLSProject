//
//  MLSUserLoginCell.h
//  ChengziZdd
//
//  Created by MinLison on 2017/11/3.
//  Copyright © 2017年 chengzivr. All rights reserved.
//

#import "BaseTableViewCell.h"

typedef NS_ENUM(NSInteger, WGUserLoginCellRightViewType)
{
        WGUserLoginCellRightTypeNone,
        WGUserLoginCellRightTypeCountDown,
        WGUserLoginCellRightTypeImg,
};

@interface MLSUserLoginCell : BaseTableViewCell
/**
 文本框
 */
@property(nonatomic, assign) UIKeyboardType keyboardType;

/**
 是否显示倒计时
 */
@property(nonatomic, assign) WGUserLoginCellRightViewType rightType;

/**
 左侧图片
 */
@property(nonatomic, copy) NSString *leftImg;

/**
 右侧图片
 rightType == WGUserLoginCellRightTypeImg 时使用
 */
@property(nonatomic, copy) NSString *rightImg;

/**
 占位文字
 */
@property(nonatomic, copy) NSString *placeHolder;

/**
 是否显示底部线条
 */
@property(nonatomic, assign) BOOL showBootomLine;

/**
 校验
 */
@property(nonatomic, copy) NSString *validatorClass;

@end
