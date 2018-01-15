//
//  MLSUserFormSMSCell.m
//  MinLison
//
//  Created by MinLison on 2017/11/3.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSUserFormSMSCell.h"
#import "MLSSMSValidator.h"
#import "MZTimerLabel.h"
#import "MLSPhoneCondition.h"
#import "MLSPhoneValidator.h"
@interface MLSUserFormSMSCell ()
@property(nonatomic, strong) QMUIButton *rightView;
@property(nonatomic, strong) MZTimerLabel *timerLabel;
@end

@implementation MLSUserFormSMSCell

- (void)setUp
{
        [super setUp];
        @weakify(self);
        [self.rightView jk_addActionHandler:^(NSInteger tag) {
                @strongify(self);
                if (self.field.action)
                {
                        self.field.action(self);
                        [self configTimerLabel:YES];
                }
        }];

        self.rightView.enabled = [[MLSPhoneCondition condition] check:LNUserManager.mobile];

        [self.contentView addSubview:self.timerLabel];
        [self.contentView addSubview:self.rightView];
        self.textField.validator = [MLSSMSValidator validator];
        
        [self.KVOController observe:LNUserManager keyPath:@keypath(LNUserManager,mobile) options:(NSKeyValueObservingOptionNew) block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
                self.rightView.enabled = [[MLSPhoneCondition condition] check:LNUserManager.mobile];
        }];
}
- (void)update
{
        [super update];
        self.textField.keyboardType = UIKeyboardTypeNumberPad;
}



- (void)layout
{
        [self configTimerLabel:NO];
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

        [self.timerLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.leftView);
                make.left.equalTo(self.textField.mas_right);
                make.right.equalTo(self.contentView.mas_right).offset(-__WGWidth(UserFormRightMargin));
        }];

        [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.leftView.imageView.mas_left);
                make.right.equalTo(self.rightView.mas_right);
                make.bottom.equalTo(self.contentView);
                make.height.mas_equalTo(__WGWidth(UserFormBootomLineHeight));
        }];
}

- (void)configTimerLabel:(BOOL)force
{

        if ( ![LNUserManager isLastSMSCountTimeCompletion] || force )
        {
                NSInteger time = [LNUserManager getSMSResidueCountTime];
                self.rightView.hidden = YES;
                NSString *text = @"(xxs)重新获取";
                NSRange r = [text rangeOfString:@"xx"];
                self.timerLabel.text = text;
                self.timerLabel.textRange = r;
                [self.timerLabel setCountDownTime:time];
                @weakify(self);
                [self.timerLabel startWithEndingBlock:^(NSTimeInterval countTime) {
                        @strongify(self);
                        self.rightView.hidden = NO;
                        self.textField.text = self.textField.text;
                        self.timerLabel.textRange = NSMakeRange(0, 0);
                        self.timerLabel.text = nil;
                }];
        }
        else
        {
                self.timerLabel.text = nil;
        }
}
- (MZTimerLabel *)timerLabel
{
        if (_timerLabel == nil) {
                _timerLabel = [[MZTimerLabel alloc] initWithTimerType:(MZTimerLabelTypeTimer)];
                _timerLabel.timeFormat = @"ss";
                _timerLabel.timeLabel.textColor = UIColorHex(0xcad1e0);
                _timerLabel.enabled = NO;
                _timerLabel.font = WGSystem16Font;
                _timerLabel.textAlignment = NSTextAlignmentRight;
                _timerLabel.textColor = UIColorHex(0xcad1e0);
                _timerLabel.resetTimerAfterFinish = YES;
        }
        return _timerLabel;
}
- (QMUIButton *)rightView
{
        if (_rightView == nil) {
                _rightView = [[QMUIButton alloc] init];
                _rightView.titleLabel.font = WGSystem16Font;
                _rightView.adjustsTitleTintColorAutomatically = NO;
                _rightView.adjustsButtonWhenHighlighted = NO;
                _rightView.adjustsButtonWhenDisabled = NO;
                [_rightView setTitle:[NSString aPP_GetSMSCode] forState:(UIControlStateDisabled)];
                [_rightView setTitle:[NSString aPP_GetSMSCode] forState:(UIControlStateNormal)];
                [_rightView setTitleColor:UIColorHex(0xcad1e0) forState:(UIControlStateDisabled)];
                [_rightView setTitleColor:UIColorHex(0x0190D4) forState:(UIControlStateNormal)];
                _rightView.enabled = NO;
        }
        return _rightView;
}
@end
