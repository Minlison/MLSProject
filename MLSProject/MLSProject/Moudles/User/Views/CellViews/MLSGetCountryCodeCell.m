//
//  MLSGetCountryCodeCell.m
//  MinLison
//
//  Created by MinLison on 2017/11/5.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSGetCountryCodeCell.h"
#import "MLSCountryCodeManager.h"

@interface MLSGetCountryCodeCell ()
@property(nonatomic, strong) UIImageView *iconView;
@property(nonatomic, strong) TTTAttributedLabel *titleView;
@property(nonatomic, strong) TTTAttributedLabel *countryCodeLabel;
@end

@implementation MLSGetCountryCodeCell
+ (CGFloat)heightForObject:(WGCountryCodeModel *)object atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
        return 55;
}
- (void)setupView
{
        [super setupView];
        [self.contentView addSubview:self.iconView];
        [self.contentView addSubview:self.titleView];
        [self.contentView addSubview:self.countryCodeLabel];
        
        [self.iconView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(__WGWidth(12));
                make.centerY.equalTo(self.contentView);
                make.width.mas_equalTo(__WGWidth(40));
        }];
        
        [self.titleView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.iconView.mas_right).offset(__WGWidth(8));
                make.centerY.equalTo(self.iconView);
        }];
        
        [self.countryCodeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView.mas_right).offset(-__WGWidth(12));
                make.centerY.equalTo(self.iconView);
                make.left.greaterThanOrEqualTo(self.titleView.mas_right);
        }];
        
}
- (BOOL)shouldUpdateCellWithObject:(WGCountryCodeModel *)object
{
        if ( ![object isKindOfClass:[WGCountryCodeModel class]] )
        {
                return NO;
        }
        self.iconView.image = [object getCountryImage];
        self.titleView.text = object.country_name;
        self.countryCodeLabel.text = [NSString stringWithFormat:@"+%@",object.phone_code];
        return YES;
}


/// MARK: -Lazy
- (UIImageView *)iconView
{
        if (_iconView == nil) {
                _iconView = [[UIImageView alloc] init];
                _iconView.contentMode = UIViewContentModeScaleAspectFill;
        }
        return _iconView;
}
- (TTTAttributedLabel *)titleView
{
        if (_titleView == nil) {
                _titleView = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
                _titleView.font = WGSystem16Font;
                _titleView.textColor = UIColorGray;
                _titleView.textAlignment = NSTextAlignmentLeft;
        }
        return _titleView;
}
- (TTTAttributedLabel *)countryCodeLabel
{
        if (_countryCodeLabel == nil) {
                _countryCodeLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
                _countryCodeLabel.font = WGSystem16Font;
                _countryCodeLabel.textColor = UIColorGray;
                _countryCodeLabel.textAlignment = NSTextAlignmentRight;
        }
        return _countryCodeLabel;
}
@end
