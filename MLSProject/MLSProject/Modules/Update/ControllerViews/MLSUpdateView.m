//
//  MLSUpdateView.m
//  MLSProject
//
//  Created by MinLison on 2017/10/10.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSUpdateView.h"
#import <TTTAttributedLabel/TTTAttributedLabel.h>

@interface MLSUpdateView ()
@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) UIImageView *iconImgView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) TTTAttributedLabel *desLabel;
@property(nonatomic, strong) UIStackView *actionView;
@property(nonatomic, strong) UIButton *latterButton;
@property(nonatomic, strong) UIButton *updateButton;
@property(nonatomic, copy) MLSUpdateActionBlock action;
@end

@implementation MLSUpdateView
- (void)setupView
{
        [super setupView];
        self.backgroundColor = [UIColor clearColor];
        [self setupContentView];
}
- (void)setupContentView
{
        [self _CreateSubViews];
        [self _LayoutSubViews];
}
- (void)setUpdateModel:(MLSUpdateModel *)updateModel
{
        _updateModel = updateModel;
        [self.desLabel setText:updateModel.content];
}
/// MARK: - Action
- (void)setActionBlock:(MLSUpdateActionBlock)actionBlock
{
        self.action = actionBlock;
}
- (void)latterButtonClick:(UIButton *)btn
{
        if (self.action)
        {
                self.action(MLSUpdateActionTypeLater);
        }
}
- (void)updateButtonClick:(UIButton *)btn
{
        if (self.action)
        {
                self.action(MLSUpdateActionTypeNow);
        }
}

/// MARK: - Private UI Method
- (void)_LayoutSubViews
{
        [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self);
                make.width.mas_equalTo(__MLSWidth(280.0));
        }];
        
        [self.iconImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView.mas_top).offset(24);
                make.centerX.equalTo(self.contentView.mas_centerX);
        }];
        
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.iconImgView.mas_bottom).offset(20);
                make.left.equalTo(self.contentView.mas_left).offset(28);
                make.right.equalTo(self.contentView.mas_right).offset(-28);
        }];
        
        [self.desLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.titleLabel.mas_bottom).offset(11);
                make.left.equalTo(self.titleLabel.mas_left);
                make.right.equalTo(self.contentView.mas_right).offset(-28);
        }];
        
        [self.actionView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.desLabel.mas_bottom).offset(15);
                make.left.right.bottom.equalTo(self.contentView);
                make.height.mas_equalTo(__MLSHeight(46));
        }];
        
}
- (void)_CreateSubViews
{
        self.contentView = [[UIView alloc] init];
        self.contentView.backgroundColor = QMUICMI.whiteColor;
        self.contentView.layer.cornerRadius = 8;
        self.contentView.clipsToBounds = YES;
        [self addSubview:self.contentView];
        
        self.iconImgView = [[UIImageView alloc] initWithImage:[UIImage icon_update]];
        [self.contentView addSubview:self.iconImgView];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = QMUICMI.blackColor;
        self.titleLabel.font = MLSSystem15Font;
        self.titleLabel.text = [NSString app_UpdateNewFunction];
        [self.contentView addSubview:self.titleLabel];
        
        self.desLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        self.desLabel.font = MLSSystem14Font;
        self.desLabel.textColor = QMUICMI.grayDarkenColor;
        [self.desLabel setText:self.updateModel.content];
        [self.contentView addSubview:self.desLabel];
        
        
        
        self.latterButton = [[UIButton alloc] init];
        self.latterButton.adjustsImageWhenHighlighted = NO;
        self.latterButton.titleLabel.font = MLSSystem16Font;
        [self.latterButton setTitle:[NSString app_Latter] forState:(UIControlStateNormal)];
        [self.latterButton setTitleColor:QMUICMI.grayColor forState:(UIControlStateNormal)];
        [self.latterButton addTarget:self action:@selector(latterButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        
        self.updateButton = [[UIButton alloc] init];
        self.updateButton.adjustsImageWhenHighlighted = NO;
        self.updateButton.titleLabel.font = MLSSystem16Font;
        [self.updateButton setTitle:[NSString app_Update] forState:(UIControlStateNormal)];
        [self.updateButton setTitleColor:QMUICMI.redColor forState:(UIControlStateNormal)];
        [self.updateButton addTarget:self action:@selector(updateButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        
        self.actionView = [[UIStackView alloc] initWithArrangedSubviews:@[self.latterButton,self.updateButton]];
        self.actionView.backgroundColor = self.contentView.backgroundColor;
        self.actionView.distribution = UIStackViewDistributionFillEqually;
        self.actionView.axis = UILayoutConstraintAxisHorizontal;
        
        UIView *topLineView = [[UIView alloc] init];
        topLineView.backgroundColor = QMUICMI.grayLightenColor;
        
        UIView *verticalLineView = [[UIView alloc] init];
        verticalLineView.backgroundColor = QMUICMI.grayLightenColor;
        
        [self.actionView addSubview:topLineView];
        [self.actionView addSubview:verticalLineView];
        
        [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.actionView.mas_top);
                make.height.mas_equalTo(0.5);
                make.left.right.equalTo(self.actionView);
        }];
        
        [verticalLineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.actionView.mas_centerX);
                make.top.equalTo(self.actionView.mas_top);
                make.bottom.equalTo(self.actionView.mas_bottom);
                make.width.mas_equalTo(0.5);
        }];
        
        [self.contentView addSubview:self.actionView];
}
@end
