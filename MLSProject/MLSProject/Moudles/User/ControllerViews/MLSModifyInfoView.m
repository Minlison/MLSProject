//
//  MLSModifyInfoView.m
//  MLSProject
//
//  Created by MinLison on 2017/12/11.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "MLSModifyInfoView.h"
#import "MLSUpdateUserInfoForm.h"
#import "MLSPhoneCondition.h"
#import "MLSNickNameCondition.h"
#import "MLSIDNumberCondation.h"
@interface MLSModifyInfoView ()<US2ValidatorUIDelegate, QMUITextViewDelegate>
@property(nonatomic, strong) US2ValidatorTextView *textView;
@property(nonatomic, strong) TTTAttributedLabel *verifyTipLabel;
@end

@implementation MLSModifyInfoView
- (BOOL)isValidator
{
        return self.textView.isValid;
}
- (void)setRowDescriptor:(XLFormRowDescriptor *)rowDescriptor
{
        _rowDescriptor = rowDescriptor;
        NSString *defaultStr = [NSString stringWithFormat:@"请输入%@",self.rowDescriptor.title];
        if (NULLObject(self.rowDescriptor.value))
        {
                self.textView.placeholder = NOT_NULL_STRING(self.rowDescriptor.subTitle, defaultStr);
        }
        else
        {
                self.textView.text = self.rowDescriptor.value;
        }
        
        [self updateValidator];
}
- (void)setupView
{
        [super setupView];
        self.backgroundColor = UIColorHex(0xf5f5f5);
        [self addSubview:self.textView];
        [self addSubview:self.verifyTipLabel];
        
        [self.textView mas_remakeConstraints:^(MASConstraintMaker *make) {
                if (@available(iOS 11, *)) {
                        make.top.equalTo(self.mas_safeAreaLayoutGuideTop).offset(__WGHeight(15));
                        make.left.equalTo(self.mas_safeAreaLayoutGuideLeft);
                        make.right.equalTo(self.mas_safeAreaLayoutGuideRight);
                } else {
                        make.top.equalTo(self.controller.mas_topLayoutGuideBottom).offset(__WGHeight(15));
                        make.left.right.equalTo(self);
                }
                make.height.mas_equalTo(__WGHeight(51));
        }];
        
        [self.verifyTipLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.textView).offset(14);
                make.top.equalTo(self.textView.mas_bottom).offset(__WGHeight(8));
                make.right.equalTo(self.textView.mas_right);
        }];
        [self updateValidator];
}
- (void)textView:(QMUITextView *)textView newHeightAfterTextChanged:(CGFloat)height
{
        if (height >= __WGHeight(51))
        {
                [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_equalTo(height);
                }];
        }
}
- (void)updateValidator
{
        LNUpdateUserInfoType type = self.rowDescriptor.rowType.integerValue;
        US2Validator *validator = [US2Validator validator];
        switch (type)
        {
                case LNUpdateUserInfoTypeNickName:
                {
                        MLSNickNameCondition *nickName = [[MLSNickNameCondition alloc] init];
                        [validator addCondition:nickName];
                }
                        break;
                case LNUpdateUserInfoTypeRealName:
                {
                        US2ConditionRange *range = [[US2ConditionRange alloc] init];
                        range.range = NSMakeRange(1, 6);
                        [validator addCondition:range];
                }
                        break;
                case LNUpdateUserInfoTypePhone:
                {
                        MLSPhoneCondition *mobile = [[MLSPhoneCondition alloc] init];
                        [validator addCondition:mobile];
                }
                        break;
                case LNUpdateUserInfoTypeIDNumber:
                {
                        MLSIDNumberCondation *condition = [[MLSIDNumberCondation alloc] init];
                        condition.shouldAllowViolation = YES;
                        [validator addCondition:condition];
                }
                        break;
                case LNUpdateUserInfoTypeGender:
                case LNUpdateUserInfoTypeBirthday:
                case LNUpdateUserInfoTypeAddress:
                {
                }
                        break;
                case LNUpdateUserInfoTypeEmail:
                {
                        US2ValidatorEmail *email = [[US2ValidatorEmail alloc] init];
                        validator = email;
                }
                        break;
                        
                default:
                        break;
        }
        self.textView.validator = validator;
}
- (void)validatorUI:(id <US2ValidatorUIProtocol>)validatorUI changedValidState:(BOOL)isValid
{
        if (!isValid)
        {
                self.verifyTipLabel.text = [NSString stringWithFormat:@"%@格式不正确",self.rowDescriptor.title];
        }
        else
        {
                self.verifyTipLabel.text = nil;
                self.rowDescriptor.value = [validatorUI text];
        }
        if (self.validatorAction)
        {
                self.validatorAction(isValid);
        }
}

- (US2ValidatorTextView *)textView
{
        if (_textView == nil) {
                _textView = [[US2ValidatorTextView alloc] initWithFrame:CGRectZero];
                _textView.validatorUIDelegate = self;
                _textView.font = WGSystem16Font;
                _textView.backgroundColor = [UIColor whiteColor];
                _textView.textColor = UIColorHex(0x323232);
                _textView.placeholderColor = UIColorHex(0x969696);
                _textView.autoResizable = YES;
                _textView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0);
        }
        return _textView;
}
- (TTTAttributedLabel *)verifyTipLabel
{
        if (_verifyTipLabel == nil) {
                _verifyTipLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
                _verifyTipLabel.textColor = UIColorHex(0xFB4E44);
                _verifyTipLabel.font = WGSystem14Font;
        }
        return _verifyTipLabel;
}
@end
