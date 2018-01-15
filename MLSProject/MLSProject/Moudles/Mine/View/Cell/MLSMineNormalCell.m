//
//  MLSMineNormalCell.m
//  MLSProject
//
//  Created by MinLison on 2017/12/8.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "MLSMineNormalCell.h"
@interface MLSMineNormalCell ()
@property(nonatomic, strong) TTTAttributedLabel *leftTitleLabel;
@property(nonatomic, strong) UIImageView *rightArrowView;
@end

@implementation MLSMineNormalCell

- (void)configure
{
        [super configure];
        self.accessoryType = UITableViewCellAccessoryNone;
        [self.contentView addSubview:self.leftTitleLabel];
        [self.contentView addSubview:self.rightArrowView];
        UIView *bottomLineView = [[UIView alloc] init];
        bottomLineView.backgroundColor = UIColorHex(0xe6e6e6);
        [self.contentView addSubview:bottomLineView];
        
        [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
        }];
        [self.leftTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(__WGWidth(16));
                make.centerY.equalTo(self.contentView);
        }];
        [self.rightArrowView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView.mas_right).offset(-__WGWidth(19));
                make.centerY.equalTo(self.contentView);
        }];
        [bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.contentView);
                make.height.mas_equalTo(1);
                make.left.equalTo(self.leftTitleLabel);
                make.right.equalTo(self.rightArrowView);
        }];
}
- (void)formDescriptorCellDidSelectedWithFormController:(XLFormViewController *)controller
{
        [LNUserManager pushOrPresentLoginIfNeed:YES inViewController:self.formViewController completion:^{
                
        } dismiss:^{
                [super formDescriptorCellDidSelectedWithFormController:controller];
        }];
}
- (void)update
{
//        [super update];
        self.leftTitleLabel.text = self.rowDescriptor.title;
}
- (UIImageView *)rightArrowView
{
        if (_rightArrowView == nil) {
                _rightArrowView = [[UIImageView alloc] initWithImage:[UIImage list_geng_duo]];
        }
        return _rightArrowView;
}
- (TTTAttributedLabel *)leftTitleLabel
{
        if (_leftTitleLabel == nil) {
                _leftTitleLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
                _leftTitleLabel.font = WGSystem16Font;
                _leftTitleLabel.textColor = UIColorHex(0x323232);
        }
        return _leftTitleLabel;
}
@end
