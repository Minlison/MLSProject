//
//  MLSMineHeaderView.m
//  MLSProject
//
//  Created by MinLison on 2017/12/8.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "MLSMineHeaderView.h"
@interface MLSMineHeaderView ()
@property(nonatomic, strong, readwrite) UIImageView *backGroundView;
@property(nonatomic, strong) QMUIGhostButton *headImgBtn;
@property(nonatomic, strong) TTTAttributedLabel *nickNamelabel;
@property(nonatomic, strong) TTTAttributedLabel *phoneNumlabel;
@property(nonatomic, strong) QMUIButton *rightGoBtn;
@property(nonatomic, strong) UIStackView *stackView;
@end
@implementation MLSMineHeaderView

- (void)setupView
{
        [super setupView];
        // 104 + 37
        [self addSubview:self.backGroundView];
        [self addSubview:self.headImgBtn];
        UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.nickNamelabel,self.phoneNumlabel]];
        self.stackView = stackView;
        stackView.axis = UILayoutConstraintAxisVertical;
        stackView.distribution = UIStackViewDistributionFillProportionally;
        stackView.alignment = UIStackViewAlignmentFill;
        stackView.spacing = __WGHeight(11);
        [self addSubview:stackView];
        [self addSubview:self.rightGoBtn];
        
        [self.backGroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
        }];
        [self.headImgBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.mas_top).offset(__WGHeight(44));
                make.left.equalTo(self).offset(__WGWidth(10));
                make.height.width.mas_equalTo(__WGWidth(70));
        }];
        [stackView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.headImgBtn.mas_right).offset(__WGWidth(10));
                make.centerY.equalTo(self.headImgBtn);
        }];
        [self.rightGoBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.mas_right).offset(-__WGWidth(10));
                make.centerY.equalTo(self.headImgBtn);
                make.height.width.mas_equalTo(__WGWidth(70));
        }];
        @weakify(self);
        [self.rightGoBtn jk_addActionHandler:^(NSInteger tag) {
                @strongify(self);
                if (self.actionBlock) {
                        self.actionBlock(MLSMineHeaderViewClickTypeUpdateUserInfo);
                }
        }];
        
        [self updateContent];
        [self.KVOController observe:MLSUserManager keyPath:@keypath(MLSUserManager,userInfoDidChange) options:(NSKeyValueObservingOptionNew) block:^(MLSMineHeaderView *  _Nullable observer, MLSUser *  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
                [observer updateContent];
        }];
        [self.headImgBtn jk_addActionHandler:^(NSInteger tag) {
                @strongify(self);
                if (self.actionBlock) {
                        self.actionBlock(MLSMineHeaderViewClickTypeHeadImgClick);
                }
        }];
}
- (void)updateContent
{
        [self.headImgBtn sd_setImageWithURL:[NSURL URLWithString:NOT_NULL_STRING_DEFAULT_EMPTY(MLSUserManager.img)] forState:(UIControlStateNormal) placeholderImage:[UIImage pic_default_avatar]];
        self.phoneNumlabel.text = NOT_NULL_STRING(MLSUserManager.mobile, @"");
        self.nickNamelabel.text = NOT_NULL_STRING(MLSUserManager.nickname, MLSUserManager.isLogin ? @"匿名用户" : @"注册/登录");
        self.stackView.spacing = MLSUserManager.isLogin ? __WGHeight(11) : 0;
}
- (QMUIButton *)rightGoBtn
{
        if (_rightGoBtn == nil) {
                _rightGoBtn = [[QMUIButton alloc] qmui_initWithImage:[UIImage list_geng_duo_bai_se] title:nil];
                _rightGoBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        }
        return _rightGoBtn;
}

- (TTTAttributedLabel *)phoneNumlabel
{
        if (_phoneNumlabel == nil) {
                _phoneNumlabel = [self createLabel];
        }
        return _phoneNumlabel;
}

- (TTTAttributedLabel *)nickNamelabel
{
        if (_nickNamelabel == nil) {
                _nickNamelabel = [self createLabel];
        }
        return _nickNamelabel;
}
- (TTTAttributedLabel *)createLabel
{
        TTTAttributedLabel *label = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        label.font = WGSystem16Font;
        label.textColor = [UIColor whiteColor];
        return label;
}
- (QMUIGhostButton *)headImgBtn
{
        if (_headImgBtn == nil) {
                _headImgBtn = [[QMUIGhostButton alloc] init];
                _headImgBtn.ghostColor = [UIColor whiteColor];
                _headImgBtn.borderWidth = 2;
                _headImgBtn.clipsToBounds = YES;
        }
        return _headImgBtn;
}
- (UIImageView *)backGroundView
{
        if (_backGroundView == nil) {
                _backGroundView = [[UIImageView alloc] initWithImage:[UIImage mine_background]];
        }
        return _backGroundView;
}
@end
