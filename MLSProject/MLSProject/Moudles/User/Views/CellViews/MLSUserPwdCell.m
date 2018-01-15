//
//  MLSUserPwdCell.m
//  MLSProject
//
//  Created by MinLison on 2017/12/12.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "MLSUserPwdCell.h"
#import "MLSPwdValidator.h"
@interface MLSUserPwdCell ()
@property(nonatomic, strong) QMUIButton *rightView;
@end

@implementation MLSUserPwdCell

- (void)setUp
{
        [super setUp];
        //        [self.leftView setImage:[UIImage login_code] forState:(UIControlStateNormal)];
        //        [self.leftView setImage:[UIImage login_code] forState:(UIControlStateSelected)];
        @weakify(self);
        [self.rightView jk_addActionHandler:^(NSInteger tag) {
                @strongify(self);
                self.rightView.selected = !self.rightView.isSelected;
                self.textField.secureTextEntry = self.rightView.isSelected;
        }];
        self.textField.validator = [[MLSPwdValidator alloc] init];
        [self.contentView addSubview:self.rightView];
}
- (void)update
{
        [super update];
        self.textField.keyboardType = UIKeyboardTypeNumberPad;
        self.textField.secureTextEntry = YES;
}
- (void)layout
{
        [self.leftView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(__WGWidth(UserFormLeftMargin));
                make.size.mas_equalTo(CGSizeMake(__WGWidth(UserFormleftViewSize.width), __WGHeight(UserFormleftViewSize.height)));
                make.bottom.equalTo(self.contentView);
        }];

        [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.leftView.mas_right).offset(__WGWidth(UserFormTextFieldInsets.left));
                make.right.equalTo(self.rightView.mas_left).offset(-__WGWidth(UserFormTextFieldInsets.right));
                make.centerY.equalTo(self.leftView);
                make.top.greaterThanOrEqualTo(self.contentView).offset(__WGWidth(UserFormTextFieldInsets.top));
                make.bottom.lessThanOrEqualTo(self.contentView).offset(-__WGWidth(UserFormTextFieldInsets.bottom));
        }];

        [self.rightView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.leftView);
                make.right.equalTo(self.contentView.mas_right).offset(-__WGWidth(UserFormRightMargin));
        }];

        [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.leftView.imageView.mas_left);
                make.right.equalTo(self.rightView.mas_right);
                make.bottom.equalTo(self.contentView);
                make.height.mas_equalTo(__WGWidth(UserFormBootomLineHeight));
        }];
}

- (void)textFieldValid:(BOOL)valid
{
        if (valid)
        {
                self.field.value = self.textField.validatableText;
        }
}
- (QMUIButton *)rightView
{
        if (_rightView == nil) {
                _rightView = [[QMUIButton alloc] init];
                _rightView.titleLabel.font = WGSystem14Font;
                _rightView.adjustsTitleTintColorAutomatically = NO;
                _rightView.adjustsButtonWhenHighlighted = NO;
                _rightView.adjustsButtonWhenDisabled = NO;
                [_rightView setImage:[UIImage account_btn_show_nor] forState:(UIControlStateNormal)];
                [_rightView setImage:[UIImage account_btn_show_sel] forState:(UIControlStateSelected)];
                _rightView.selected = YES;
        }
        return _rightView;
}
@end
