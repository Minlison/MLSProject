//
//  MLSUserThirdLoginView.m
//  MinLison
//
//  Created by MinLison on 2017/11/2.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSUserThirdLoginView.h"

@interface MLSUserThirdLoginView ()
@property(nonatomic, strong) QMUIButton *webCatView;
@property(nonatomic, strong) QMUIButton *qqView;
@property(nonatomic, strong) QMUIButton *weiBoView;
@property(nonatomic, strong) QMUIButton *phoneView;
@property(nonatomic, copy) void (^LoginAction)(LNLoginType);
@property(nonatomic, strong) TTTAttributedLabel *titleLabel;
@end

@implementation MLSUserThirdLoginView
- (instancetype)initWithFrame:(CGRect)frame
{
        self = [super initWithFrame:frame];
        if (self) {
                [self _LayoutViews];
        }
        return self;
}
- (void)setThirdLoginAction:(void (^)(LNLoginType))action
{
        self.LoginAction = action;
}
- (void)_LayoutViews
{
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self);
                make.centerX.equalTo(self);
        }];
        
        UIView *leftLineView = [[UIView alloc] init];
        leftLineView.backgroundColor = self.titleLabel.textColor;
        UIView *rightLineView = [[UIView alloc] init];
        rightLineView.backgroundColor = self.titleLabel.textColor;
        [self addSubview:leftLineView];
        [self addSubview:rightLineView];
        
        [leftLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.titleLabel);
                make.right.equalTo(self.titleLabel.mas_left).offset(-__WGWidth(16));
                make.height.mas_equalTo(0.5);
                make.width.mas_equalTo(__WGWidth(41));
        }];
        
        [rightLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.titleLabel);
                make.left.equalTo(self.titleLabel.mas_right).offset(__WGWidth(16));
                make.height.width.equalTo(leftLineView);
        }];
        
        UIStackView *thridStackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.webCatView,self.qqView]];
        thridStackView.axis = UILayoutConstraintAxisHorizontal;
        thridStackView.distribution = UIStackViewDistributionFillEqually;
        thridStackView.alignment = UIStackViewAlignmentFill;
        thridStackView.spacing = __WGWidth(59);

        
        [self addSubview:thridStackView];
        
        [thridStackView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.titleLabel.mas_bottom).offset(__WGWidth(41));
                make.bottom.equalTo(self).offset(-__WGWidth(60));
                make.centerX.equalTo(self);
                make.leading.greaterThanOrEqualTo(self).offset(__WGWidth(8));
                make.trailing.lessThanOrEqualTo(self).offset(-__WGWidth(8));
                make.height.mas_equalTo(__WGWidth(52));
        }];
}
- (void)threePartiesLogin:(UIButton *)sender
{
        if (self.LoginAction)
        {
                self.LoginAction(sender.tag);
        }
}
- (QMUIButton *)webCatView
{
        if (_webCatView == nil) {
                _webCatView = [QMUIButton buttonWithType:(UIButtonTypeCustom)];
                [_webCatView setImage:[UIImage login_icon_wechat] forState:(UIControlStateNormal)];
                _webCatView.imageView.contentMode = UIViewContentModeScaleAspectFit;
                _webCatView.tag = LNLoginTypeWebchat;
                [_webCatView addTarget:self action:@selector(threePartiesLogin:) forControlEvents:(UIControlEventTouchUpInside)];
        }
        return _webCatView;
}
- (QMUIButton *)qqView
{
        if (_qqView == nil) {
                _qqView = [QMUIButton buttonWithType:(UIButtonTypeCustom)];
                [_qqView setImage:[UIImage login_icon_qq] forState:(UIControlStateNormal)];
                _qqView.imageView.contentMode = UIViewContentModeScaleAspectFit;
                _qqView.tag = LNLoginTypeQQ;
                [_qqView addTarget:self action:@selector(threePartiesLogin:) forControlEvents:(UIControlEventTouchUpInside)];
        }
        return _qqView;
}
- (QMUIButton *)weiBoView
{
        if (_weiBoView == nil) {
                _weiBoView = [QMUIButton buttonWithType:(UIButtonTypeCustom)];
                [_weiBoView setImage:[UIImage login_icon_weibo] forState:(UIControlStateNormal)];
                _weiBoView.imageView.contentMode = UIViewContentModeScaleAspectFit;
                _weiBoView.tag = LNLoginTypeWeibo;
                [_weiBoView addTarget:self action:@selector(threePartiesLogin:) forControlEvents:(UIControlEventTouchUpInside)];
        }
        return _weiBoView;
}
- (QMUIButton *)phoneView
{
        if (_phoneView == nil) {
                _phoneView = [QMUIButton buttonWithType:(UIButtonTypeCustom)];
                [_phoneView setImage:[UIImage login_icon_phone] forState:(UIControlStateNormal)];
                _phoneView.imageView.contentMode = UIViewContentModeScaleAspectFit;
                [_phoneView addTarget:self action:@selector(threePartiesLogin:) forControlEvents:(UIControlEventTouchUpInside)];
        }
        return _weiBoView;
}
- (TTTAttributedLabel *)titleLabel
{
        if (_titleLabel == nil) {
                _titleLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
                _titleLabel.textColor = UIColorHex(0xDCE1EB);
                _titleLabel.font = WGSystem13Font;
                _titleLabel.text = [NSString aPP_ThirdPartyFastLogin];
        }
        return _titleLabel;
}
@end
