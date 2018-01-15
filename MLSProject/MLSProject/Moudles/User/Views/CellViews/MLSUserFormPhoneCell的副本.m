//
//  MLSUserFormPhoneCell.m
//  ChengziZdd
//
//  Created by MinLison on 2017/11/3.
//  Copyright © 2017年 chengzivr. All rights reserved.
//

#import "MLSUserFormPhoneCell.h"
#import "MLSPhoneValidator.h"

#define WGUserFormCountryCodeFmt(c) [NSString stringWithFormat:@"+%@",c]

@interface MLSUserFormPhoneCell ()
@property(nonatomic, strong) QMUIButton *countryCodeView;
@property(nonatomic, strong) NBPhoneNumberUtil *phoneNumUtil;
@end

@implementation MLSUserFormPhoneCell
- (void)setUp
{
        [super setUp];
        
        [self.leftView setImage:[UIImage login_phone] forState:(UIControlStateNormal)];
        [self.leftView setImage:[UIImage login_phone] forState:(UIControlStateSelected)];
        
        @weakify(self);
        [self.countryCodeView jk_addActionHandler:^(NSInteger tag) {
                @strongify(self);
                if (self.field.action)
                {
                        self.field.action(self);
                }
        }];
        
        self.textField.validator = [MLSPhoneValidator validator];
        
        [self.contentView addSubview:self.countryCodeView];
        
        [self.KVOController observe:WGUserManager keyPath:@keypath(WGUserManager,country_code) options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial) block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
                @strongify(self);
                [self.countryCodeView setTitle:WGUserFormCountryCodeFmt([change jk_stringForKey:NSKeyValueChangeNewKey]) forState:(UIControlStateNormal)];
        }];
}
- (void)textFieldValid:(BOOL)valid
{
        if (valid)
        {
                NSError *error = nil;
                NBPhoneNumber *phoneNumber = [self.phoneNumUtil parseWithPhoneCarrierRegion:[NSString stringWithFormat:@"+%@%@",WGUserManager.country_code,self.textField.text] error:&error];
                NSString *fmtCountryCode = WGUserFormCountryCodeFmt(phoneNumber.countryCode.stringValue);
                if (phoneNumber.countryCode && ![self.countryCodeView.currentTitle isEqualToString:fmtCountryCode])
                {
                        [self.countryCodeView setTitle:fmtCountryCode forState:(UIControlStateNormal)];
                        WGUserManager.country_code = phoneNumber.countryCode.stringValue;
                }
        }
}
- (void)layout
{
        [self.leftView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(UserFormLeftMargin);
                make.size.mas_equalTo(UserFormleftViewSize);
                make.centerY.equalTo(self.contentView);
        }];
        
        [self.countryCodeView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.leftView.mas_right);
                make.centerY.equalTo(self.contentView);
                make.width.mas_equalTo(70);
        }];
        
        [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.countryCodeView.mas_right).offset(UserFormTextFieldInsets.left);
                make.right.equalTo(self.contentView.mas_right).offset(-UserFormRightMargin);
                make.centerY.equalTo(self.contentView);
                make.top.equalTo(self.contentView).offset(UserFormTextFieldInsets.top);
                make.bottom.equalTo(self.contentView).offset(-UserFormTextFieldInsets.bottom);
        }];
        [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.leftView.mas_left);
                make.right.equalTo(self.textField.mas_right);
                make.bottom.equalTo(self.contentView);
                make.height.mas_equalTo(UserFormBootomLineHeight);
        }];
}

- (QMUIButton *)countryCodeView
{
        if (!_countryCodeView) {
                _countryCodeView = [[QMUIButton alloc] initWithImage:[UIImage account_btn_up] title:WGUserFormCountryCodeFmt(WGUserManager.country_code)];
                [_countryCodeView setTitleColor:UIColorGrayDarken forState:(UIControlStateNormal)];
                _countryCodeView.titleLabel.font = WGSystem14Font;
                _countryCodeView.imagePosition = QMUIButtonImagePositionRight;
                _countryCodeView.spacingBetweenImageAndTitle = 8;
        }
        return _countryCodeView;
}
- (NBPhoneNumberUtil *)phoneNumUtil
{
        if (!_phoneNumUtil) {
                _phoneNumUtil = [[NBPhoneNumberUtil alloc] init];
        }
        return _phoneNumUtil;
}
@end
