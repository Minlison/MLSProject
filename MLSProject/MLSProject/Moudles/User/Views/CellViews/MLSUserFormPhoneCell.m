//
//  MLSUserFormPhoneCell.m
//  MinLison
//
//  Created by MinLison on 2017/11/3.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSUserFormPhoneCell.h"
#import "MLSPhoneValidator.h"
#import "MZTimerLabel.h"
#define WGUserFormCountryCodeFmt(c) [NSString stringWithFormat:@"+%@",c]

@interface MLSUserFormPhoneCell ()
@property(nonatomic, strong) NBPhoneNumberUtil *phoneNumUtil;
//@property(nonatomic, strong) QMUIButton *rightView;
//@property(nonatomic, strong) MZTimerLabel *timerLabel;
@end

@implementation MLSUserFormPhoneCell
- (void)setUp
{
        [super setUp];
        
//        [self.leftView setImage:[UIImage login_phone] forState:(UIControlStateNormal)];
//        [self.leftView setImage:[UIImage login_phone] forState:(UIControlStateSelected)];
        
//        @weakify(self);
//        [self.rightView jk_addActionHandler:^(NSInteger tag) {
//                @strongify(self);
//                if (self.field.action)
//                {
//                        self.field.action(self);
//                        [self configTimerLabel:YES];
//                }
//        }];
        
//        self.rightView.enabled = NO;
//
//        [self.contentView addSubview:self.timerLabel];
//        [self.contentView addSubview:self.rightView];
        
        
}
- (void)update
{
        [super update];
        self.textField.keyboardType = UIKeyboardTypePhonePad;
        self.textField.validator = [MLSPhoneValidator validator];
        if (!NULLString(self.field.value)) {
                self.textField.text = self.field.value;
        }
}
- (void)textFieldValid:(BOOL)valid
{
        if (valid)
        {
                NSError *error = nil;
                NBPhoneNumber *phoneNumber = [self.phoneNumUtil parseWithPhoneCarrierRegion:[NSString stringWithFormat:@"%@",self.textField.text] error:&error];
                if (!NULLString(phoneNumber.countryCode.stringValue))
                {
                        LNUserManager.country_code = phoneNumber.countryCode.stringValue;
                }
                self.field.value = self.textField.validatableText;
        }
//        self.rightView.enabled = valid;
}
//- (void)layout
//{
//        [self configTimerLabel:NO];
//        [self.leftView mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(self.contentView).offset(__WGWidth(UserFormLeftMargin));
//                make.size.mas_equalTo(CGSizeMake(__WGWidth(UserFormleftViewSize.width), __WGHeight(UserFormleftViewSize.height)));
//                make.bottom.equalTo(self.contentView);
//        }];
//
//        [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(self.leftView.mas_right).offset(__WGWidth(UserFormTextFieldInsets.left));
//                make.right.equalTo(self.rightView.mas_left).offset(-__WGWidth(UserFormTextFieldInsets.right));
//                make.centerY.equalTo(self.leftView);
//                make.top.greaterThanOrEqualTo(self.contentView).offset(__WGWidth(UserFormTextFieldInsets.top));
//                make.bottom.lessThanOrEqualTo(self.contentView).offset(-__WGWidth(UserFormTextFieldInsets.bottom));
//        }];
//
//        [self.rightView mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.centerY.equalTo(self.leftView);
//                make.right.equalTo(self.contentView.mas_right).offset(-__WGWidth(UserFormRightMargin));
//        }];
//
//        [self.timerLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.centerY.equalTo(self.leftView);
//                make.left.equalTo(self.textField.mas_right);
//                make.right.equalTo(self.contentView.mas_right).offset(-__WGWidth(UserFormRightMargin));
//        }];
//
//        [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(self.leftView.imageView.mas_left);
//                make.right.equalTo(self.rightView.mas_right);
//                make.bottom.equalTo(self.contentView);
//                make.height.mas_equalTo(__WGWidth(UserFormBootomLineHeight));
//        }];
//}

//- (void)configTimerLabel:(BOOL)force
//{
//
//        if ( ![LNUserManager isLastSMSCountTimeCompletion] || force )
//        {
//                NSInteger time = [LNUserManager getSMSResidueCountTime];
//                self.rightView.hidden = YES;
//                NSString *text = @"(xxs)重新获取";
//                NSRange r = [text rangeOfString:@"xx"];
//                self.timerLabel.text = text;
//                self.timerLabel.textRange = r;
//                [self.timerLabel setCountDownTime:time];
//                @weakify(self);
//                [self.timerLabel startWithEndingBlock:^(NSTimeInterval countTime) {
//                        @strongify(self);
//                        self.rightView.hidden = NO;
//                        self.textField.text = self.textField.text;
//                        self.timerLabel.textRange = NSMakeRange(0, 0);
//                        self.timerLabel.text = nil;
//                }];
//        }
//        else
//        {
//                self.timerLabel.text = nil;
//        }
//}
//- (MZTimerLabel *)timerLabel
//{
//        if (_timerLabel == nil) {
//                _timerLabel = [[MZTimerLabel alloc] initWithTimerType:(MZTimerLabelTypeTimer)];
//                _timerLabel.timeFormat = @"ss";
//                _timerLabel.timeLabel.textColor = UIColorHex(0xcad1e0);
//                _timerLabel.enabled = NO;
//                _timerLabel.font = WGSystem14Font;
//                _timerLabel.textAlignment = NSTextAlignmentRight;
//                _timerLabel.textColor = UIColorHex(0xcad1e0);
//                _timerLabel.resetTimerAfterFinish = YES;
//        }
//        return _timerLabel;
//}
//- (QMUIButton *)rightView
//{
//        if (_rightView == nil) {
//                _rightView = [[QMUIButton alloc] init];
//                _rightView.titleLabel.font = WGSystem14Font;
//                _rightView.adjustsTitleTintColorAutomatically = NO;
//                _rightView.adjustsButtonWhenHighlighted = NO;
//                _rightView.adjustsButtonWhenDisabled = NO;
//                [_rightView setTitle:[NSString aPP_GetSMSCode] forState:(UIControlStateDisabled)];
//                [_rightView setTitle:[NSString aPP_GetSMSCode] forState:(UIControlStateNormal)];
//                [_rightView setTitleColor:UIColorHex(0xcad1e0) forState:(UIControlStateDisabled)];
//                [_rightView setTitleColor:UIColorHex(0x5596dd) forState:(UIControlStateNormal)];
//                _rightView.enabled = NO;
//        }
//        return _rightView;
//}
- (NBPhoneNumberUtil *)phoneNumUtil
{
        if (!_phoneNumUtil) {
                _phoneNumUtil = [[NBPhoneNumberUtil alloc] init];
        }
        return _phoneNumUtil;
}
@end
