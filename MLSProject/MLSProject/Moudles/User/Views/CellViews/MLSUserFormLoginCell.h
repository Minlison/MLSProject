//
//  MLSUserFormLoginCell.h
//  MinLison
//
//  Created by MinLison on 2017/11/3.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "FXForms.h"
UIKIT_EXTERN const CGFloat UserFormBootomLineHeight;
UIKIT_EXTERN const CGFloat UserFormLeftMargin;
UIKIT_EXTERN const CGFloat UserFormRightMargin;
UIKIT_EXTERN const UIEdgeInsets UserFormTextFieldInsets; // top, left, bottom, right
UIKIT_EXTERN const CGSize UserFormleftViewSize;
UIKIT_EXTERN const CGSize UserFormrightViewSize;


@interface MLSUserFormLoginCell : FXFormTextFieldCell

/**
 是否显示底部线条
 */
@property(nonatomic, assign) BOOL showBootomLine;

/**
 左侧图片视图
 */
@property(nonatomic, strong, readonly) QMUIButton *leftView;

/**
 底部线条
 */
@property(nonatomic, strong, readonly) UIView *lineView;

/**
 布局子视图
 */
- (void)layout;

@end
