//
//  MLSUserTableHeaderView.m
//  MinLison
//
//  Created by MinLison on 2017/10/27.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSUserTableHeaderView.h"

@interface MLSUserTableHeaderView ()
@property(nonatomic, strong) QMUIGhostButton *headButton;
@property(nonatomic, strong) TTTAttributedLabel *nickNameLabel;
@end

@implementation MLSUserTableHeaderView

- (void)setUserHeadClickBlock:(void (^)(void))clickBlock
{
        [self.headButton jk_addActionHandler:^(NSInteger tag) {
                if (clickBlock)
                {
                        clickBlock();
                }
        }];
}
- (void)setupView
{
        UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.headButton,self.nickNameLabel]];
        
        stackView.axis = UILayoutConstraintAxisVertical;
        stackView.distribution = UIStackViewDistributionEqualCentering;
        stackView.alignment = UIStackViewAlignmentCenter;
        stackView.spacing = __WGWidth(15);
        stackView.userInteractionEnabled = YES;
        [self addSubview:stackView];
        
        [self.headButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.width.mas_equalTo(__WGWidth(64));
        }];
        
        [stackView mas_remakeConstraints:^(MASConstraintMaker *make) {
                if (@available(iOS 11.0, *)) {
                        make.top.equalTo(self.mas_safeAreaLayoutGuideTop).offset(__WGWidth(76));
                } else {
                        make.top.equalTo(self.mas_top).offset(__WGWidth(76));
                }
                make.centerX.equalTo(self.mas_centerX);
                make.left.greaterThanOrEqualTo(self);
                make.right.lessThanOrEqualTo(self);
        }];
        
        @weakify(self);
        [self.KVOController observe:LNUserManager keyPath:@keypath(LNUserManager,img) options:(NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew) block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
                @strongify(self);
                NSString *newAvatar = [change objectForKey:NSKeyValueChangeNewKey];
                [self.headButton sd_setImageWithURL:[NSURL URLWithString:NOT_NULL_STRING_DEFAULT_EMPTY(newAvatar)] forState:UIControlStateNormal placeholderImage:[UIImage pic_default_avatar] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                        
                }];
        }];
        
        [self.KVOController observe:LNUserManager keyPath:@keypath(LNUserManager,nickname) options:(NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew) block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
                @strongify(self);
                NSString *newNickName = [change objectForKey:NSKeyValueChangeNewKey];
                if (!NULLString(newNickName) && LNUserManager.isLogin)
                {
                        self.nickNameLabel.text = newNickName;
                }
                else
                {
                        self.nickNameLabel.text = [self getAttributeEmptyUserNickName];
                }
        }];
}
- (QMUIGhostButton *)headButton
{
        if (_headButton == nil) {
                _headButton = [[QMUIGhostButton alloc] initWithFrame:CGRectZero];
                _headButton.adjustsImageWhenHighlighted = NO;
                [_headButton setImage:[UIImage pic_default_avatar] forState:UIControlStateNormal];
                _headButton.ghostColor = [UIColor clearColor];
                _headButton.clipsToBounds = YES;
        }
        return _headButton;
}
- (TTTAttributedLabel *)nickNameLabel
{
        if (_nickNameLabel == nil) {
                _nickNameLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
                _nickNameLabel.textAlignment = NSTextAlignmentCenter;
                _nickNameLabel.font = WGSystem16Font;
                _nickNameLabel.textColor = UIColorBlack;
                _nickNameLabel.text = [NSString app_NotLogin];
        }
        return _nickNameLabel;
}
- (NSAttributedString *)getAttributeEmptyUserNickName
{
        if (LNUserManager.isLogin) {
                return [[NSAttributedString alloc] initWithString:LNUserManager.nickname attributes:@{
                                                                                                       NSForegroundColorAttributeName : UIColorBlack,
                                                                                                       NSFontAttributeName : WGSystem16Font
                                                                                                       }];
        }
        return [[NSAttributedString alloc] initWithString:[NSString app_NotLogin] attributes:@{
                                                                                               NSForegroundColorAttributeName : UIColorGray5,
                                                                                               NSFontAttributeName : WGSystem16Font
                                                                                               }];
}
@end
