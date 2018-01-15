//
//  MLSUserAgreementCell.m
//  MLSProject
//
//  Created by MinLison on 2017/12/12.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "MLSUserAgreementCell.h"
@interface MLSUserAgreementCell ()
@property(nonatomic, strong) QMUIButton *agreementButton;
@end
@implementation MLSUserAgreementCell
+ (CGFloat)heightForField:(FXFormField *)field width:(CGFloat)width
{
        return __WGHeight(30);
}
- (void)didSelectWithTableView:(UITableView *)tableView controller:(UIViewController *)controller
{
        // do nothing
}
- (void)update
{
        [super update];
        self.button.selected = [self.field.value boolValue];
}
- (void)setUp
{
        //override
        
        self.agreementButton = [[QMUIButton alloc] init];
        self.agreementButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        NSDictionary *norAttr = @{
                                  NSFontAttributeName : WGSystem14Font,
                                  NSForegroundColorAttributeName : UIColorHex(0x969696)
                                  };
        NSDictionary *selAttr = @{
                                  NSFontAttributeName : WGSystem14Font,
                                  NSForegroundColorAttributeName : UIColorHex(0x0190D4)
                                  };
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:@" 认真阅读并同意" attributes:norAttr];
        [self.button setAttributedTitle:attribute forState:(UIControlStateNormal)];
        [self.agreementButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"《会员注册须知》" attributes:selAttr] forState:(UIControlStateNormal)];
        self.button.backgroundColor = [UIColor clearColor];
        [self.button setImage:[UIImage about_btn_check_nor] forState:UIControlStateNormal];
        [self.button setImage:[UIImage about_btn_check_sel] forState:UIControlStateSelected];
        
        
        UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.button,self.agreementButton]];
        stackView.axis = UILayoutConstraintAxisHorizontal;
        stackView.distribution = UIStackViewDistributionFillEqually;
        stackView.alignment = UIStackViewAlignmentCenter;
        stackView.spacing = 0;
        [self.contentView addSubview:stackView];
        
        
        
        [stackView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self.contentView);
                make.left.equalTo(self.contentView).offset(__WGWidth(34));
                make.right.equalTo(self.contentView).offset(-__WGWidth(28));
                CGFloat height = [[self class] heightForField:self.field width:0];
                if ([CoBaseUtils isPhoneType:(iPhoneTypeInches_5_5)] || [CoBaseUtils isPhoneType:(iPhoneTypeInches_5_8)])
                {
                        make.height.mas_equalTo(__WGHeight(MIN(height, 44)));
                }
                else
                {
                        make.height.mas_equalTo(__WGHeight(MIN(height, 48)));
                }
        }];
        
        
        @weakify(self);
        [self.agreementButton jk_addActionHandler:^(NSInteger tag) {
                @strongify(self);
                if (self.field.action) {
                        self.field.action(self);
                }
                self.button.selected = !self.button.selected;
                self.field.value = @(self.button.isSelected);
        }];
        [self.button jk_addActionHandler:^(NSInteger tag) {
                @strongify(self);
                self.button.selected = !self.button.selected;
                self.field.value = @(self.button.isSelected);
        }];
        
}
@end
