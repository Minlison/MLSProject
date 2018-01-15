//
//  MLSUserCenterCell.m
//  MinLison
//
//  Created by MinLison on 2017/10/27.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSUserCenterCell.h"
#import "MLSUserCenterPlistModel.h"

@interface MLSUserCenterCell ()
@property(nonatomic, strong) UIImageView *iconView;
@property(nonatomic, strong) TTTAttributedLabel *nameLabel;
@end

@implementation MLSUserCenterCell
- (void)setupView
{
        [super setupView];
        UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.iconView,self.nameLabel]];
        stackView.axis = UILayoutConstraintAxisHorizontal;
        stackView.distribution = UIStackViewDistributionEqualSpacing;
        stackView.alignment = UIStackViewAlignmentCenter;
        stackView.spacing = __WGWidth(10);
        [self.contentView addSubview:stackView];
        [stackView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self.contentView);
                make.left.greaterThanOrEqualTo(self.contentView.mas_left);
                make.right.lessThanOrEqualTo(self.contentView.mas_right);
                make.top.greaterThanOrEqualTo(self.contentView.mas_top);
                make.bottom.lessThanOrEqualTo(self.contentView.mas_bottom);
        }];
        [self.iconView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.width.mas_equalTo(__WGWidth(30));
        }];
}
- (BOOL)shouldUpdateCellWithObject:(MLSUserCenterCellModel *)object
{
        if (![object isKindOfClass:[MLSUserCenterCellModel class]])
        {
                return NO;
        }
        self.iconView.image = [UIImage imageNamed:object.iconName] ?:[UIImage selectionHolder];
        self.nameLabel.text = object.title;
        return YES;
}
- (UIImageView *)iconView
{
        if (_iconView == nil)
        {
                _iconView = [[UIImageView alloc] init];
                _iconView.contentMode = UIViewContentModeScaleAspectFit;
        }
        return _iconView;
}
- (TTTAttributedLabel *)nameLabel
{
        if (_nameLabel == nil)
        {
                _nameLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
                _nameLabel.font = WGSystem13Font;
                _nameLabel.textColor = UIColorBlack;
        }
        return _nameLabel;
}
@end
