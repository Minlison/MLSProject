//
//  MLSUserLoginContainerView.m
//  ChengziZdd
//
//  Created by MinLison on 2017/11/2.
//  Copyright © 2017年 chengzivr. All rights reserved.
//

#import "MLSUserLoginContainerView.h"
#import "MZTimerLabel.h"
static const CGFloat bootomLineWidth = 1;
@interface MLSUserLoginContainerView ()
@property(nonatomic, strong) QMUIButton *leftView;
@property(nonatomic, strong) UITextField *textField;
@property(nonatomic, strong) QMUIButton *rightView;
@property(nonatomic, strong) MZTimerLabel *timerLabel;
@end

@implementation MLSUserLoginContainerView
- (instancetype)initWithFrame:(CGRect)frame
{
        if (self = [super initWithFrame:frame]) {
                [self _setupView];
        }
        return self;
}
- (void)setShowBootomLine:(BOOL)showBootomLine
{
        if (_showBootomLine != showBootomLine) {
                _showBootomLine = showBootomLine;
                if (showBootomLine)
                {
                        self.qmui_borderPosition = QMUIBorderViewPositionBottom;
                        self.qmui_borderWidth = bootomLineWidth;
                }
        }
}
- (void)setShowCountDownButton:(BOOL)showCountDownButton
{
        if (_showCountDownButton != showCountDownButton) {
                _showCountDownButton = showCountDownButton;
                [self _reLayout];
        }
}
- (void)setLeftViewImg:(UIImage *)leftViewImg
{
        [self.leftView setImage:leftViewImg forState:(UIControlStateNormal)];
}
- (void)setPlaceHolder:(NSString *)placeHolder
{
        self.textField.placeholder = placeHolder;
}
- (void)setKeyboardType:(UIKeyboardType)keyboardType
{
        self.textField.keyboardType = keyboardType;
}
- (void)_setupView
{
        [self addSubview:self.leftView];
        [self addSubview:self.textField];
        [self.rightView addSubview:self.timerLabel];
        [self.timerLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.rightView);
        }];
        [self _reLayout];
}
- (void)_reLayout
{
        
        [self.leftView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(20);
                make.height.width.mas_equalTo(30);
                make.centerY.equalTo(self);
        }];
        
        [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.leftView.mas_right).offset(8);
                make.centerY.equalTo(self);
                make.height.mas_equalTo(50);
                make.top.greaterThanOrEqualTo(self);
                make.bottom.greaterThanOrEqualTo(self);
        }];
        
        if (self.showCountDownButton)
        {
                [self addSubview:self.rightView];
                [self.rightView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(self.textField.mas_right);
                        make.centerY.equalTo(self.textField);
                        make.width.mas_equalTo(100);
                        make.height.mas_equalTo(50);
                }];
                [self mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.right.equalTo(self.rightView.mas_right);
                }];
        }
        else
        {
                [self.rightView removeFromSuperview];
                [self mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.right.equalTo(self.textField.mas_right);
                }];
        }
        
}
- (void)configTimerLabel:(BOOL)force
{
        NSInteger time = [WGUserManager getSMSResidueCountTime];
        if (time != kGetSMSCountTime || force )
        {
                self.rightView.userInteractionEnabled = NO;
                NSString *text = @"(xxs)重新获取";
                NSRange r = [text rangeOfString:@"xx"];
                
//                UIColor* fgColor = [UIColor redColor];
//                NSDictionary* attributesForRange = @{
//                                                     NSForegroundColorAttributeName: fgColor,
//                                                     };
//                self.timerLabel.attributedDictionaryForTextInRange = attributesForRange;
                self.timerLabel.text = text;
                self.timerLabel.textRange = r;
                [self.timerLabel setCountDownTime:time];
                @weakify(self);
                [self.timerLabel startWithEndingBlock:^(NSTimeInterval countTime) {
                        @strongify(self);
                        self.rightView.userInteractionEnabled = YES;
                        self.timerLabel.textRange = NSMakeRange(0, 0);
                        self.timerLabel.text = [NSString aPP_GetSMSCode];
                }];
        }
        else
        {
                self.timerLabel.text = [NSString aPP_GetSMSCode];
        }
}

- (void)setCountDownAction:(void (^)(void))action
{
        @weakify(self);
        [self.rightView jk_addActionHandler:^(NSInteger tag) {
                @strongify(self);
                if (action) {
                        action();
                }
                [self configTimerLabel:YES];
        }];
}
- (UITextField *)textField
{
        if (_textField == nil) {
                _textField = [[UITextField alloc] init];
                _textField.font = WGSystem13Font;
        }
        return _textField;
}
- (MZTimerLabel *)timerLabel
{
        if (_timerLabel == nil) {
                _timerLabel = [[MZTimerLabel alloc] initWithTimerType:(MZTimerLabelTypeTimer)];
                _timerLabel.resetTimerAfterFinish = YES;
                _timerLabel.timeFormat = @"ss";
                _timerLabel.text = [NSString aPP_GetSMSCode];
                _timerLabel.userInteractionEnabled = NO;
                _timerLabel.font = WGSystem12Font;
                _timerLabel.textAlignment = NSTextAlignmentRight;
                _timerLabel.textColor = UIColorBlue;
        }
        return _timerLabel;
}
- (QMUIButton *)rightView
{
        if (_rightView == nil) {
                _rightView = [[QMUIButton alloc] init];
                _rightView.titleLabel.font = WGSystem12Font;
                [self configTimerLabel:NO];
        }
        return _rightView;
}
- (QMUIButton *)leftView
{
        if (_leftView == nil) {
                _leftView = [[QMUIButton alloc] initWithFrame:CGRectZero];
                [_leftView setImage:[UIImage icon_update] forState:(UIControlStateNormal)];
        }
        return _leftView;
}

@end
