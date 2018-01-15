//
//  MLSMineSwitchCell.m
//  MLSProject
//
//  Created by MinLison on 2017/12/12.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "MLSMineSwitchCell.h"
@interface MLSMineSwitchCell ()
@property(nonatomic, strong) TTTAttributedLabel *leftTitleLabel;
@property(nonatomic, strong) UISwitch *switchControl;
@end
@implementation MLSMineSwitchCell
- (void)configure
{
        [super configure];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.accessoryType = UITableViewCellAccessoryNone;
        [self.contentView addSubview:self.leftTitleLabel];
        [self.contentView addSubview:self.switchControl];
        
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
        
        [self.switchControl mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView.mas_right).offset(-__WGWidth(19));
                make.centerY.equalTo(self.contentView);
        }];
        
        [bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.contentView);
                make.height.mas_equalTo(1);
                make.left.equalTo(self.leftTitleLabel);
                make.right.equalTo(self.switchControl);
        }];
}

- (void)update
{
        [super update];
        self.textLabel.text = self.rowDescriptor.title;
        self.switchControl.on = [self.rowDescriptor.value boolValue];
        self.switchControl.enabled = !self.rowDescriptor.isDisabled;
}

- (UISwitch *)switchControl
{
        if (!_switchControl) {
                _switchControl = [[UISwitch alloc] init];
                [_switchControl addTarget:self action:@selector(valueChanged) forControlEvents:UIControlEventValueChanged];
        }
        return _switchControl;
}

- (void)valueChanged
{
        self.rowDescriptor.value = @(self.switchControl.on);
        LNUserManager.userSetting.enablePushNotifaction = self.switchControl.isOn;
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
