//
//  LNEventTitleHeaderView.m
//  MLSProject
//
//  Created by MinLison on 2017/12/14.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "MLSCommonTitleHeaderView.h"
@interface MLSCommonTitleHeaderView ()
@property(nonatomic, strong, readwrite) TTTAttributedLabel *titleLabel;
@end
@implementation MLSCommonTitleHeaderView

- (void)setupView
{
        [super setupView];
        self.textLabel.text = nil;
        self.detailTextLabel.text = nil;
        self.titleLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        self.titleLabel.backgroundColor = [UIColor whiteColor];
        self.titleLabel.font = WGSystem16Font;
        self.titleLabel.textColor = UIColorHex(0x323232);
        self.titleLabel.textInsets = UIEdgeInsetsMake(0, __WGWidth(16), 0, 0);
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = UIColorHex(0xe6e6e6);
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:lineView];
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView).offset(__WGHeight(10));
                make.left.right.bottom.equalTo(self.contentView);
        }];
        [lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(__WGWidth(16));
                make.right.equalTo(self.contentView).offset(-__WGWidth(16));
                make.bottom.equalTo(self.contentView);
                make.height.mas_equalTo(1);
        }];
}
@end
