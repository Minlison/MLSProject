//
//  MLSCommonAgreementFooter.m
//  MLSProject
//
//  Created by MinLison on 2017/12/14.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "MLSCommonAgreementFooter.h"
@interface MLSCommonAgreementFooter ()
@property(nonatomic, strong) QMUIButton *agreementButton;
@property(nonatomic, strong) QMUIGhostButton *aggreeIconButton;
@property(nonatomic, strong) UIStackView *stackView;
@end
@implementation MLSCommonAgreementFooter
- (void)setupView
{
        [super setupView];
        //override
        self.alignment = MLSCommonAgreementFooterAlignmentCenter;
        self.agreementButton = [[QMUIButton alloc] init];
        self.agreementButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.aggreeIconButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        NSDictionary *norAttr = @{
                                  NSFontAttributeName : WGSystem14Font,
                                  NSForegroundColorAttributeName : UIColorHex(0x969696)
                                  };
        NSDictionary *selAttr = @{
                                  NSFontAttributeName : WGSystem14Font,
                                  NSForegroundColorAttributeName : UIColorHex(0x0190D4)
                                  };
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:@" 认真阅读并同意" attributes:norAttr];
        [self.aggreeIconButton setAttributedTitle:attribute forState:(UIControlStateNormal)];
        
        self.aggreeIconButton.backgroundColor = [UIColor clearColor];
        [self.aggreeIconButton setImage:[UIImage about_btn_check_nor] forState:UIControlStateNormal];
        [self.aggreeIconButton setImage:[UIImage about_btn_check_sel] forState:UIControlStateSelected];
        
        [self.agreementButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"《会员注册须知》" attributes:selAttr] forState:(UIControlStateNormal)];
        
        UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.aggreeIconButton,self.agreementButton]];
        stackView.axis = UILayoutConstraintAxisHorizontal;
        stackView.distribution = UIStackViewDistributionEqualSpacing;
        stackView.alignment = UIStackViewAlignmentCenter;
        stackView.spacing = 0;
        [self.contentView addSubview:stackView];
        self.stackView = stackView;
        
        [self updateLayout];
        
        @weakify(self);
        [self.aggreeIconButton jk_addActionHandler:^(NSInteger tag) {
                @strongify(self);
                self.aggreeIconButton.selected = !self.aggreeIconButton.selected;
               
                if (self.actionBlock) {
                        self.actionBlock(MLSCommonAgreementFooterAgree,self.aggreeIconButton.isSelected);
                }
        }];
        [self.agreementButton jk_addActionHandler:^(NSInteger tag) {
                @strongify(self);
                self.aggreeIconButton.selected = !self.aggreeIconButton.selected;
                if (self.actionBlock) {
                        self.actionBlock(MLSCommonAgreementFooterAgreeAndShowAgreement,self.aggreeIconButton.isSelected);
                }
        }];
}
- (void)updateLayout
{
        
        switch (self.alignment) {
                case MLSCommonAgreementFooterAlignmentLeft:
                {
                        [self.stackView mas_remakeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(self.contentView.mas_left).offset(__WGWidth(15));
                                make.centerY.equalTo(self.contentView);
                        }];
                }
                        break;
                case MLSCommonAgreementFooterAlignmentCenter:
                {
                        [self.stackView mas_remakeConstraints:^(MASConstraintMaker *make) {
                                make.center.equalTo(self.contentView);
                        }];
                }
                        break;
                        
                default:
                        break;
        }
}
- (void)setAlignment:(MLSCommonAgreementFooterAlignment)alignment
{
        _alignment = alignment;
        [self updateLayout];
}
- (QMUIButton *)agreementButton
{
        if (_agreementButton == nil) {
                _agreementButton = [[QMUIButton alloc] init];
                _agreementButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                _agreementButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                [_agreementButton setImage:[UIImage about_btn_check_nor] forState:UIControlStateNormal];
                [_agreementButton setImage:[UIImage about_btn_check_sel] forState:UIControlStateSelected];
        }
        return _agreementButton;
}
- (QMUIGhostButton *)aggreeIconButton
{
        if (_aggreeIconButton == nil) {
                _aggreeIconButton = [[QMUIGhostButton alloc] init];
                _aggreeIconButton.ghostColor = UIColorClear;
                _aggreeIconButton.cornerRadius = 5;
                [_aggreeIconButton setTitleColor:UIColorWhite forState:(UIControlStateNormal)];
                [_aggreeIconButton setTitle:[NSString app_Login] forState:(UIControlStateNormal)];
                _aggreeIconButton.backgroundColor = UIColorHex(0x80C8EA);
        }
        return _aggreeIconButton;
}
@end
