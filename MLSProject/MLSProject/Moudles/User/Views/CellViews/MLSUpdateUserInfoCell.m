//
//  MLSUpdateUserInfoCell.m
//  MLSProject
//
//  Created by 袁航 on 2017/12/9.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "MLSUpdateUserInfoCell.h"
#import "MLSUpdateUserInfoForm.h"
#import "MLSModifyInfoViewController.h"
#import "MLSUpdateUserInfoRequest.h"
@interface MLSUpdateUserInfoCell ()
@property(nonatomic, strong) TTTAttributedLabel *titleLabel;
@property(nonatomic, strong) TTTAttributedLabel *textLabelView;
@property(nonatomic, strong) US2ValidatorTextField *textField;
@property(nonatomic, strong) UIDatePicker *datePicker;
@property(nonatomic, strong) UIView *textFieldDateAccessoryView;
@property(nonatomic, copy) id oldValue;
@end

@implementation MLSUpdateUserInfoCell
- (void)configure
{
        [super configure];
        self.accessoryType = UITableViewCellAccessoryNone;
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.textField];
        [self.contentView addSubview:self.textLabelView];
        
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.left.equalTo(self.contentView).offset(__WGWidth(11));
                make.top.equalTo(self.contentView).offset(__WGHeight(18));
                make.bottom.equalTo(self.contentView).offset(-__WGHeight(18));
        }];
        
        [self.textLabelView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView).offset(-__WGWidth(15));
                make.top.bottom.equalTo(self.titleLabel);
                make.left.greaterThanOrEqualTo(self.titleLabel.mas_right).offset(__WGWidth(47));
        }];
        
        [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.textLabelView);
        }];
        
        UIView *lineView = [[UIView alloc] init];
        [self.contentView addSubview:lineView];
        lineView.backgroundColor = UIColorHex(0xE6E6E6);
        [lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.left.right.equalTo(self.contentView);
                make.height.mas_equalTo(1);
        }];
        
}
- (void)update
{
        self.titleLabel.text = self.rowDescriptor.title;
        self.textLabelView.text = NOT_NULL_STRING(self.rowDescriptor.value, self.rowDescriptor.subTitle);
}
- (void)updateUserInfo
{
        [self update];
        @weakify(self);
        [LNUserManager updateUserInfoWithParam:@{
                                                 self.rowDescriptor.tag : self.rowDescriptor.value,
                                                 } success:^(NSString * _Nonnull sms) {
                                                         @strongify(self);
                                                         [MLSTipClass showText:[NSString stringWithFormat:@"%@修改成功",self.rowDescriptor.title] inView:self.formViewController.view];
                                                 } failed:^(NSError * _Nonnull error) {
                                                         @strongify(self);
                                                         self.rowDescriptor.value = self.oldValue;
                                                         [self update];
                                                         [MLSTipClass showErrorWithText:error.localizedDescription inView:self.formViewController.view];
                                                 }];
}
- (void)datePickerValueDidChanged:(UIDatePicker *)datePicker
{
        if (datePicker != self.datePicker) {
                return;
        }
        self.textLabelView.text = [NSDate jk_stringWithDate:datePicker.date format:@"yyyy-MM-dd"];
}
- (void)formDescriptorCellDidSelectedWithFormController:(XLFormViewController *)controller
{
        self.oldValue = self.rowDescriptor.value;
        if (self.rowDescriptor.rowType.integerValue == LNUpdateUserInfoTypeBirthday)
        {
                // date
                if ( !NULLString(self.textLabelView.text) ) {
                        NSDate *date = [NSDate jk_dateWithString:self.textLabelView.text format:@"yyyy-MM-dd"];
                        if (date) {
                                [self.datePicker setDate:date animated:NO];
                        }
                }
                [self.textField becomeFirstResponder];
        }
        else if ( self.rowDescriptor.rowType.integerValue == LNUpdateUserInfoTypeGender )
        {
                /// alert
                [self alertGenderVC];
        }
        else
        {
                MLSModifyInfoViewController *vc = [[MLSModifyInfoViewController alloc] init];
                vc.rowDescriptor = self.rowDescriptor;
                [controller.navigationController pushViewController:vc animated:YES];
        }
}
- (void)alertGenderVC
{
        QMUIAlertController *alertVC = [QMUIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(QMUIAlertControllerStyleActionSheet)];
        [alertVC addAction:[QMUIAlertAction actionWithTitle:@"男" style:(QMUIAlertActionStyleDefault) handler:^(QMUIAlertAction *action) {
                self.rowDescriptor.value = @"男";
                [self updateUserInfo];
        }]];
        [alertVC addAction:[QMUIAlertAction actionWithTitle:@"女" style:(QMUIAlertActionStyleDefault) handler:^(QMUIAlertAction *action) {
                self.rowDescriptor.value = @"女";
                [self updateUserInfo];
        }]];
        [alertVC addAction:[QMUIAlertAction actionWithTitle:@"保密" style:(QMUIAlertActionStyleDefault) handler:^(QMUIAlertAction *action) {
                self.rowDescriptor.value = @"保密";
                [self updateUserInfo];
        }]];
        [alertVC addAction:[QMUIAlertAction actionWithTitle:@"取消" style:(QMUIAlertActionStyleCancel) handler:nil]];
        [alertVC showWithAnimated:YES];
}


- (TTTAttributedLabel *)titleLabel
{
        if ( _titleLabel == nil )
        {
                _titleLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
                _titleLabel.font = WGSystem16Font;
                _titleLabel.textColor = UIColorHex(0x323232);
        }
        return _titleLabel;
}
- (US2ValidatorTextField *)textField
{
        if (_textField == nil) {
                _textField = [[US2ValidatorTextField alloc] init];
                _textField.tintColor = [UIColor clearColor];
                _textField.inputView = self.datePicker;
                _textField.inputAccessoryView = self.textFieldDateAccessoryView;
        }
        return _textField;
}
- (TTTAttributedLabel *)textLabelView
{
        if ( _textLabelView == nil )
        {
                _textLabelView = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
                _textLabelView.font = WGSystem16Font;
                _textLabelView.backgroundColor = [UIColor whiteColor];
                _textLabelView.textAlignment = NSTextAlignmentRight;
                _textLabelView.textColor = UIColorHex(0x969696);
        }
        return _textLabelView;
}
- (UIDatePicker *)datePicker
{
        if (_datePicker == nil) {
                _datePicker = [[UIDatePicker alloc] init];
                _datePicker.datePickerMode = UIDatePickerModeDate;
                _datePicker.backgroundColor = [UIColor whiteColor];
                _datePicker.maximumDate = [NSDate date];
                [_datePicker addTarget:self action:@selector(datePickerValueDidChanged:) forControlEvents:(UIControlEventValueChanged)];
        }
        return _datePicker;
}
- (UIView *)textFieldDateAccessoryView
{
        if (!_textFieldDateAccessoryView) {
                _textFieldDateAccessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, __MAIN_SCREEN_WIDTH__, __WGHeight(40))];
                UIView *lineView =[[UIView alloc] init];
                lineView.backgroundColor = UIColorHex(0xdcdcdc);
                [_textFieldDateAccessoryView addSubview:lineView];
                _textFieldDateAccessoryView.backgroundColor = [UIColor whiteColor];
                
                QMUIButton *cancelBtn = [self createButtonWithTitle:@"取消" titleColor:UIColorHex(0xBEBED2)];
                QMUIButton *sureBtn = [self createButtonWithTitle:@"确定" titleColor:UIColorHex(0x1E1E1E)];
                [_textFieldDateAccessoryView addSubview:cancelBtn];
                [_textFieldDateAccessoryView addSubview:sureBtn];
                
                [cancelBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(_textFieldDateAccessoryView.mas_left).offset(__WGWidth(10));
//                        make.left.equalTo(_textFieldDateAccessoryView.mas_right).offset(-__WGWidth(10));
                        make.top.bottom.equalTo(_textFieldDateAccessoryView);
                }];
                [sureBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.right.equalTo(_textFieldDateAccessoryView.mas_right).offset(-__WGWidth(10));
                        make.top.bottom.equalTo(_textFieldDateAccessoryView);
                }];
                @weakify(self);
                [cancelBtn jk_addActionHandler:^(NSInteger tag) {
                        @strongify(self);
                        [self update];
                        [self.textField resignFirstResponder];
                }];
                [sureBtn jk_addActionHandler:^(NSInteger tag) {
                        @strongify(self);
                        self.rowDescriptor.value = [NSDate jk_stringWithDate:self.datePicker.date format:@"yyyy-MM-dd"];
                        [self updateUserInfo];
                        [self.textField resignFirstResponder];
                }];
        }
        return _textFieldDateAccessoryView;
}
- (QMUIButton *)createButtonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor
{
        QMUIButton *btn = [[QMUIButton alloc] init];
        [btn setTitleColor:titleColor forState:(UIControlStateNormal)];
        [btn setTitle:title forState:(UIControlStateNormal)];
        btn.titleLabel.font = WGSystem16Font;
        return btn;
}
@end
