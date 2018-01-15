//
//  MLSUserLoginView.m
//  ChengziZdd
//
//  Created by MinLison on 2017/11/1.
//  Copyright © 2017年 chengzivr. All rights reserved.
//

#import "MLSUserLoginView.h"
#import "MLSUserLoginContainerView.h"
#import "MLSUserThirdLoginView.h"

@interface MLSUserLoginView ()
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) MLSUserLoginContainerView *phoneView;
@property(nonatomic, strong) MLSUserLoginContainerView *smsView;
@property(nonatomic, strong) QMUIButton *loginButton;
@property(nonatomic, strong) MLSUserThirdLoginView *thirdLoginView;
@end

@implementation MLSUserLoginView
- (void)setLoginAction:(void (^)(WGThirdLoginType type))action
{
        [self.thirdLoginView setThirdLoginAction:action];
        [self.loginButton jk_addActionHandler:^(NSInteger tag) {
                if (action) {
                        action(WGThirdLoginTypePhone);
                }
        }];
}
- (void)setGetSMSAction:(void (^)(void))action
{
        [self.phoneView setCountDownAction:action];
}
- (void)setupView
{
        [super setupView];
        [self addSubview:self.scrollView];
        
        UIView *containerView = [[UIView alloc] init];
        
        [self.scrollView addSubview:containerView];
        
        [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
        }];
        
        [containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.leading.trailing.top.bottom.equalTo(self.scrollView);
                make.leading.trailing.top.equalTo(self);
                make.bottom.greaterThanOrEqualTo(self);
        }];
        
        [self setupContainer:containerView];
}
- (void)setupContainer:(UIView *)containerView
{
        
        [containerView addSubview:self.loginButton];
        [containerView addSubview:self.thirdLoginView];
        
        UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.phoneView,self.smsView]];
        stackView.axis = UILayoutConstraintAxisVertical;
        stackView.distribution = UIStackViewDistributionFillEqually;
        stackView.alignment = UIStackViewAlignmentFill;
        stackView.spacing = 10;
        [containerView addSubview:stackView];
        
        [stackView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.top.equalTo(self).offset(120);
                make.left.equalTo(self).offset(20);
                make.right.equalTo(self).offset(-20);
        }];
        
        [self.loginButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.top.equalTo(stackView.mas_bottom).offset(50);
                make.left.equalTo(self).offset(20);
                make.right.equalTo(self).offset(-20);
                make.height.mas_equalTo(50);
        }];
        
        [self.thirdLoginView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.greaterThanOrEqualTo(self.loginButton.mas_bottom);
                make.bottom.equalTo(self).offset(-20);
                make.left.right.equalTo(self);
        }];
}
- (void)setThirdLoginAction:(void (^)(WGThirdLoginType))action
{
        [self.thirdLoginView setThirdLoginAction:action];
}
- (MLSUserLoginContainerView *)phoneView
{
        if (!_phoneView) {
                _phoneView = [[MLSUserLoginContainerView alloc] initWithFrame:CGRectZero];
                _phoneView.showCountDownButton = YES;
                _phoneView.showBootomLine = YES;
                
                _phoneView.leftViewImg = [UIImage icon_update];
                _phoneView.placeHolder = [NSString aPP_PhoneNum];
        }
        return _phoneView;
}
- (MLSUserLoginContainerView *)smsView
{
        if (!_smsView) {
                _smsView = [[MLSUserLoginContainerView alloc] initWithFrame:CGRectZero];
                _smsView.showCountDownButton = NO;
                _smsView.leftViewImg = [UIImage icon_update];
                _smsView.placeHolder = [NSString aPP_SMSSecurityCode];
        }
        return _smsView;
}
- (QMUIButton *)loginButton
{
        if (_loginButton == nil) {
                _loginButton = [[QMUIButton alloc] init];
                [_loginButton setTitleColor:UIColorWhite forState:(UIControlStateNormal)];
                [_loginButton setTitle:[NSString app_Login] forState:(UIControlStateNormal)];
                [_loginButton setBackgroundColor:UIColorBlue];
                _loginButton.layer.cornerRadius = 25;
        }
        return _loginButton;
}
- (MLSUserThirdLoginView *)thirdLoginView
{
        if (_thirdLoginView == nil) {
                _thirdLoginView = [[MLSUserThirdLoginView alloc] initWithFrame:CGRectZero];
        }
        return _thirdLoginView;
}
- (UIScrollView *)scrollView
{
        if (_scrollView == nil) {
                _scrollView = [[UIScrollView alloc] init];
                _scrollView.bounces = NO;
        }
        return _scrollView;
}
@end
