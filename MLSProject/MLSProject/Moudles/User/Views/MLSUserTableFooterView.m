//
//  MLSUserTableFooterView.m
//  MinLison
//
//  Created by MinLison on 2017/11/1.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSUserTableFooterView.h"

@interface MLSUserTableFooterView ()
@property(nonatomic, strong) QMUIButton *iconButton;
@property(nonatomic, strong) QMUIButton *feedBackButton;
@property(nonatomic, strong) TTTAttributedLabel *versionLabel;
@property(nonatomic, strong) UIStackView *stackView;
@end

@implementation MLSUserTableFooterView

- (void)setFeedBackAction:(void (^)(void))action
{
        [self.feedBackButton jk_addActionHandler:^(NSInteger tag) {
                if (action) {
                        action();
                }
        }];
        [self.stackView jk_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
                if (action) {
                        action();
                }
        }];
}
- (void)setupView
{
        UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.feedBackButton,self.versionLabel]];
        stackView.axis = UILayoutConstraintAxisVertical;
        stackView.distribution = UIStackViewDistributionFillProportionally;
        stackView.alignment = UIStackViewAlignmentFill;
        stackView.spacing = 9;
        [self addSubview:stackView];
        self.stackView = stackView;
        [stackView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.mas_centerX);
                make.top.greaterThanOrEqualTo(self);
                make.left.equalTo(self);
                make.right.equalTo(self);
                make.bottom.equalTo(self.mas_bottom).offset(-__WGWidth(14));
        }];
}

- (QMUIButton *)feedBackButton
{
        if (_feedBackButton == nil)
        {
                _feedBackButton = [[QMUIButton alloc] initWithFrame:CGRectZero];
                [_feedBackButton setTitle:[NSString app_SuggestionFeedBack] forState:(UIControlStateNormal)];
                _feedBackButton.adjustsImageWhenHighlighted = NO;
                [_feedBackButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
                [_feedBackButton setTitleColor:[UIColor blackColor] forState:(UIControlStateSelected)];
                _feedBackButton.titleLabel.font = WGSystem14Font;
                [_feedBackButton setTitleColor:UIColorGray5 forState:(UIControlStateNormal)];
        }
        return _feedBackButton;
}

- (QMUIButton *)iconButton
{
        if (_iconButton == nil)
        {
                _iconButton = [[QMUIButton alloc] initWithFrame:CGRectZero];
                [_iconButton setImage:[UIImage app_icon] forState:(UIControlStateNormal)];
        }
        return _iconButton;
}
- (TTTAttributedLabel *)versionLabel
{
        if (_versionLabel == nil) {
                _versionLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
                _versionLabel.textAlignment = NSTextAlignmentCenter;
                _versionLabel.textColor = UIColorGray5;
                _versionLabel.font = WGSystem12Font;
                _versionLabel.text = [NSString stringWithFormat:@"v %@",[AppUnit version]];
        }
        return _versionLabel;
}
@end
