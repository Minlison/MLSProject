//
//  LNUserFormSMSLoginCell.m
//  ChengziZdd
//
//  Created by MinLison on 2017/11/3.
//  Copyright © 2017年 chengzivr. All rights reserved.
//

#import "LNUserFormSMSLoginCell.h"
#import "MLSSMSValidator.h"
#import "MZTimerLabel.h"
#import "MLSPhoneCondition.h"
@interface LNUserFormSMSLoginCell ()
@property(nonatomic, strong) QMUIButton *rightView;
@property(nonatomic, strong) MZTimerLabel *timerLabel;
@end

@implementation LNUserFormSMSLoginCell

- (void)setUp
{
        [super setUp];
        [self.leftView setImage:[UIImage login_code] forState:(UIControlStateNormal)];
        [self.leftView setImage:[UIImage login_code] forState:(UIControlStateSelected)];
        
        self.textField.validator = [MLSSMSValidator validator];
        
        @weakify(self);
        [self.rightView jk_addActionHandler:^(NSInteger tag) {
                @strongify(self);
                if (self.field.action)
                {
                        self.field.action(self);
                        [self configTimerLabel:YES];
                }
        }];
        
        self.rightView.enabled = NO;
        
        [self.contentView addSubview:self.rightView];
        [self.rightView addSubview:self.timerLabel];
        
        [self.timerLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.rightView);
        }];
        
        
        [self.KVOController observe:WGUserManager keyPath:@keypath(WGUserManager,phone) options:(NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew) block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
                @strongify(self);
                self.rightView.enabled = [[MLSPhoneCondition condition] check:[change jk_stringForKey:NSKeyValueChangeNewKey]];
        }];
}
- (void)layout
{
        [self configTimerLabel:NO];
        [self.leftView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(UserFormLeftMargin);
                make.size.mas_equalTo(UserFormleftViewSize);
                make.centerY.equalTo(self.contentView);
        }];
        
        [self.rightView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.size.mas_equalTo(UserFormrightViewSize);
                make.right.equalTo(self.contentView.mas_right).offset(-UserFormRightMargin);
        }];
        
        [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.leftView.mas_right).offset(UserFormTextFieldInsets.left);
                make.right.equalTo(self.rightView.mas_left).offset(-UserFormTextFieldInsets.right);
                make.centerY.equalTo(self.contentView);
                make.top.equalTo(self.contentView).offset(UserFormTextFieldInsets.top);
                make.bottom.equalTo(self.contentView).offset(-UserFormTextFieldInsets.bottom);
        }];
        [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.leftView.mas_left);
                make.right.equalTo(self.rightView.mas_right);
                make.bottom.equalTo(self.contentView);
                make.height.mas_equalTo(UserFormBootomLineHeight);
        }];
        
}
- (void)configTimerLabel:(BOOL)force
{
        NSInteger time = [WGUserManager getSMSResidueCountTime];
        if (time != kGetSMSCountTime || force )
        {
                self.rightView.enabled = NO;
                NSString *text = @"(xxs)重新获取";
                NSRange r = [text rangeOfString:@"xx"];
                self.timerLabel.text = text;
                self.timerLabel.textRange = r;
                [self.timerLabel setCountDownTime:time];
                @weakify(self);
                [self.timerLabel startWithEndingBlock:^(NSTimeInterval countTime) {
                        @strongify(self);
                        self.rightView.enabled = YES;
                        self.timerLabel.textRange = NSMakeRange(0, 0);
                        self.timerLabel.text = [NSString aPP_GetSMSCode];
                }];
        }
        else
        {
                self.timerLabel.text = [NSString aPP_GetSMSCode];
        }
}
- (MZTimerLabel *)timerLabel
{
        if (_timerLabel == nil) {
                _timerLabel = [[MZTimerLabel alloc] initWithTimerType:(MZTimerLabelTypeTimer)];
                _timerLabel.timeFormat = @"ss";
                _timerLabel.text = [NSString aPP_GetSMSCode];
                _timerLabel.enabled = NO;
                _timerLabel.font = WGSystem14Font;
                _timerLabel.textAlignment = NSTextAlignmentRight;
                _timerLabel.textColor = UIColorBlue;
        }
        return _timerLabel;
}
- (QMUIButton *)rightView
{
        if (_rightView == nil) {
                _rightView = [[QMUIButton alloc] init];
                _rightView.titleLabel.font = WGSystem14Font;
        }
        return _rightView;
}
@end
