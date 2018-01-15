//
//  WGFeedBackHeadView.m
//  MinLison
//
//  Created by MinLison on 2017/11/8.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSFeedBackHeadCell.h"
@interface MLSFeedBackHeadCell ()
@property(nonatomic, strong) TTTAttributedLabel *titleLabel;
@property(nonatomic, strong) QMUIGhostButton *iconView;
@property(nonatomic, strong) TTTAttributedLabel *nameLabel;
@property(nonatomic, strong) TTTAttributedLabel *timeLabel;
@property(nonatomic, strong) TTTAttributedLabel *detailLabel;
@end
@implementation MLSFeedBackHeadCell
- (BOOL)shouldUpdateCellWithObject:(MLSFeedBackContentModel *)object
{
        if (![object isKindOfClass:[MLSFeedBackContentModel class]]) {
                return NO;
        }
        [self updateContentWithModel:object];
        return YES;
}
+ (CGFloat)heightForObject:(id)object identifier:(NSString *)identifier atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
        return UITableViewAutomaticDimension;
}
- (void)updateContentWithModel:(MLSFeedBackContentModel *)model
{
        self.titleLabel.text = NOT_NULL_STRING_DEFAULT_EMPTY(model.title);
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:NOT_NULL_STRING_DEFAULT_EMPTY(model.img)] forState:(UIControlStateNormal) placeholderImage:[UIImage app_icon]];
        self.nameLabel.text = NOT_NULL_STRING(model.nickname, [NSString app_NoNickName]);
        self.timeLabel.text = [AppUnit formatGMT8TimeMillisecond:model.time.floatValue withFormat:@"MM-dd"];
        self.detailLabel.text = NOT_NULL_STRING_DEFAULT_EMPTY(model.content);
}
- (void)setupView
{
        [super setupView];
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView.mas_top).offset(__WGWidth(24));
                make.centerX.equalTo(self.contentView);
                make.left.greaterThanOrEqualTo(self.contentView).offset(__WGWidth(8));
                make.right.lessThanOrEqualTo(self.contentView).offset(-__WGWidth(8));
        }];
        
        UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.iconView,self.nameLabel,self.timeLabel]];
        stackView.axis = UILayoutConstraintAxisHorizontal;
        stackView.distribution = UIStackViewDistributionEqualCentering;
        stackView.alignment = UIStackViewAlignmentCenter;
        stackView.spacing = __WGWidth(10);
        [self.contentView addSubview:stackView];
        [self.iconView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(__WGWidth(18));
                make.width.mas_equalTo(__WGWidth(18));
        }];
        [stackView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.titleLabel.mas_bottom).offset(__WGWidth(10));
                make.centerX.equalTo(self.contentView);
                make.height.mas_equalTo(__WGWidth(20));
        }];
        
        [self.contentView addSubview:self.detailLabel];
        [self.detailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(stackView.mas_bottom).offset(__WGWidth(13));
                make.left.equalTo(self.contentView.mas_left).offset(__WGWidth(13));
                make.right.equalTo(self.contentView.mas_right).offset(-__WGWidth(13));
                make.bottom.equalTo(self.contentView.mas_bottom).offset(-__WGWidth(50));
        }];
}

/// MARK: - Lazy
- (QMUIGhostButton *)iconView
{
        if (_iconView == nil) {
                _iconView = [[QMUIGhostButton alloc] initWithGhostColor:UIColorHex(0xE1E1E1)];
                [_iconView setImage:[UIImage app_icon] forState:(UIControlStateNormal)];
                _iconView.userInteractionEnabled = NO;
                _iconView.contentMode = UIViewContentModeScaleAspectFit;
                _iconView.clipsToBounds = YES;
        }
        return _iconView;
}
- (TTTAttributedLabel *)titleLabel
{
        if (_titleLabel == nil) {
                _titleLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
                _titleLabel.textColor = UIColorBlack;
                _titleLabel.font = WGBoldSystem16Font;
                _titleLabel.textAlignment = NSTextAlignmentCenter;
        }
        return _titleLabel;
}
- (TTTAttributedLabel *)nameLabel
{
        if (_nameLabel == nil) {
                _nameLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
                _nameLabel.textColor = UIColorGray5;
                _nameLabel.font = WGSystem12Font;
                _nameLabel.textAlignment = NSTextAlignmentCenter;
        }
        return _nameLabel;
}
- (TTTAttributedLabel *)timeLabel
{
        if (_timeLabel == nil) {
                _timeLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
                _timeLabel.textColor = UIColorGray5;
                _timeLabel.font = WGSystem12Font;
                _timeLabel.textAlignment = NSTextAlignmentCenter;
        }
        return _timeLabel;
}
- (TTTAttributedLabel *)detailLabel
{
        if (_detailLabel == nil) {
                _detailLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
                _detailLabel.textColor = UIColorBlack;
                _detailLabel.font = WGSystem14Font;
                _detailLabel.lineSpacing = 4;
                _detailLabel.numberOfLines = 0;
        }
        return _detailLabel;
}
@end
