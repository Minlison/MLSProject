//
//  MLSRegisterNotNewUserView.m
//  MLSProject
//
//  Created by MinLison on 2017/12/12.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "MLSRegisterNotNewUserView.h"

@interface MLSRegisterNotNewUserView ()
@property(nonatomic, strong) QMUIGhostButton *headImgButton;
@property(nonatomic, strong) TTTAttributedLabel *desLabel;
@property(nonatomic, strong) QMUIGhostButton *myAccountButton;
@property(nonatomic, strong) QMUIGhostButton *forgetPwdButton;
@property(nonatomic, strong) QMUIGhostButton *changePhoneForRegister;
@end

@implementation MLSRegisterNotNewUserView

- (void)setupView
{
        [super setupView];
        self.myAccountButton = [self createNormalBottomButtonWithTitle:@"是我的，立即登录"];
        self.myAccountButton.selected = YES;
        self.forgetPwdButton = [self createNormalBottomButtonWithTitle:@"忘记密码，重设密码"];
        self.changePhoneForRegister = [self createNormalBottomButtonWithTitle:@"换个手机号重新注册"];
        self.desLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        self.desLabel.font = WGSystem14Font;
        self.desLabel.textColor = UIColorHex(0xB4B4B4);
        self.desLabel.numberOfLines = 0;
        self.desLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.headImgButton];
        [self addSubview:self.desLabel];
        
        
        QMUIGridView *gridView = [[QMUIGridView alloc] init];
        gridView.columnCount = 1;
        gridView.rowHeight = 46;
        gridView.separatorWidth = 20;
        gridView.separatorColor = [UIColor clearColor];
        
        [gridView addSubview:self.myAccountButton];
        [gridView addSubview:self.forgetPwdButton];
        [gridView addSubview:self.changePhoneForRegister];
        [self addSubview:gridView];
        
        [self.headImgButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                if (@available(iOS 11, *)) {
                        make.top.equalTo(self.mas_safeAreaLayoutGuideTop).offset(__WGHeight(50));
                } else {
                        make.top.equalTo(self.controller.mas_topLayoutGuideBottom).offset(__WGHeight(50));
                }
                make.centerX.equalTo(self);
                make.height.width.mas_equalTo(__WGHeight(91));
        }];
        
        [self.desLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.headImgButton);
                make.top.equalTo(self.headImgButton.mas_bottom).offset(__WGHeight(15));
                make.left.equalTo(self).offset(__WGWidth(76));
                make.right.equalTo(self).offset(-__WGWidth(76));
        }];
        
        [gridView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.desLabel.mas_bottom).offset(__WGHeight(50));
                make.left.equalTo(self).offset(__WGWidth(30));
                make.right.equalTo(self).offset(-__WGWidth(30));
                make.height.mas_equalTo(__WGHeight(180));
        }];
        
        [self updateContent];
        @weakify(self);
        [self.KVOController observe:MLSUserManager keyPath:@keypath(MLSUserManager,img) options:(NSKeyValueObservingOptionNew) block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
                @strongify(self);
                [self updateContent];
        }];
        
        [self actionConfig];
        
}
- (void)actionConfig
{
        @weakify(self);
        [self.myAccountButton jk_addActionHandler:^(NSInteger tag) {
                @strongify(self);
                if (self.actionBlock) {
                        self.actionBlock(MLSRegisterNotNewUserViewClickTypeMineLoginRightNow);
                }
        }];
        
        [self.forgetPwdButton jk_addActionHandler:^(NSInteger tag) {
                @strongify(self);
                if (self.actionBlock) {
                        self.actionBlock(MLSRegisterNotNewUserViewClickTypeForgetPwdAndReset);
                }
        }];
        
        [self.changePhoneForRegister jk_addActionHandler:^(NSInteger tag) {
                @strongify(self);
                if (self.actionBlock) {
                        self.actionBlock(MLSRegisterNotNewUserViewClickTypeChangePhoneToRegister);
                }
        }];
}
- (void)updateContent
{
        [self.headImgButton sd_setBackgroundImageWithURL:[NSURL URLWithString:NOT_NULL_STRING_DEFAULT_EMPTY(MLSUserManager.img)] forState:(UIControlStateNormal) placeholderImage:[UIImage pic_default_avatar]];
        self.desLabel.text = @"该手机号注册过以上体育软件园账号 请确认是你的账号";
}
- (QMUIGhostButton *)headImgButton
{
        if (_headImgButton == nil) {
                _headImgButton = [[QMUIGhostButton alloc] init];
                _headImgButton.borderWidth = 0;
                _headImgButton.ghostColor = [UIColor clearColor];
                _headImgButton.clipsToBounds = YES;
        }
        return _headImgButton;
}
- (QMUIGhostButton *)createNormalBottomButtonWithTitle:(NSString *)title
{
        QMUIGhostButton *button = [[QMUIGhostButton alloc] init];
        [button setTitle:title forState:(UIControlStateNormal)];
        button.titleLabel.font = WGSystem16Font;
        [button setTitleColor:[UIColor whiteColor] forState:(UIControlStateSelected)];
        [button setBackgroundImage:[UIImage imageWithColor:UIColorHex(0x0190D4)] forState:UIControlStateSelected];
        [button setTitleColor:UIColorHex(0x0190D4) forState:(UIControlStateNormal)];
        button.borderWidth = 1;
        button.ghostColor = UIColorHex(0x0190D4);
        button.cornerRadius = 5;
        return button;
}
@end
