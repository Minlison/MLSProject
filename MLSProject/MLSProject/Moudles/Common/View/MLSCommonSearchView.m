//
//  MLSCommonSearchView.m
//  MLSProject
//
//  Created by MinLison on 2017/12/20.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "MLSCommonSearchView.h"
@interface MLSCommonSearchView ()
@property(nonatomic, strong) TTTAttributedLabel *textLabel;
@property(nonatomic, strong) QMUIButton *searchBtn;
@property(nonatomic, strong) UIView *contentView;
@end
@implementation MLSCommonSearchView

- (void)setPlaceHolder:(NSString *)placeHolder
{
        _placeHolder = placeHolder.copy;
        self.textLabel.text = placeHolder;
}
- (void)setSearchFieldBackGroundColor:(UIColor *)searchFieldBackGroundColor
{
        _searchFieldBackGroundColor = searchFieldBackGroundColor;
        self.contentView.backgroundColor = searchFieldBackGroundColor;
}
- (void)setSearchTextFieldInset:(UIEdgeInsets)searchTextFieldInset
{
        _searchTextFieldInset = searchTextFieldInset;
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self).valueOffset([NSValue valueWithUIEdgeInsets:self.searchTextFieldInset]);
        }];
}
- (void)setSearchContentCornerRadius:(CGFloat)searchContentCornerRadius
{
        _searchContentCornerRadius = searchContentCornerRadius;
        self.contentView.layer.cornerRadius = searchContentCornerRadius;
        self.contentView.layer.masksToBounds = YES;
}
- (void)setSearchContentBorderColor:(UIColor *)searchContentBorderColor
{
        _searchContentBorderColor = searchContentBorderColor;
        self.contentView.layer.borderColor = searchContentBorderColor.CGColor;
        self.contentView.layer.masksToBounds = YES;
}
- (void)setSearchContentBorderWidth:(CGFloat)searchContentBorderWidth
{
        _searchContentBorderWidth = searchContentBorderWidth;
        self.contentView.layer.borderWidth = searchContentBorderWidth;
        self.contentView.layer.masksToBounds = YES;
}
- (void)setupView
{
        [super setupView];
        [self addSubview:self.contentView];
        self.searchTextFieldInset = UIEdgeInsetsZero;
        self.searchContentBorderWidth = 1;
        self.searchContentBorderColor = UIColorHex(0xE6E6EA);
        self.searchFieldBackGroundColor = [UIColor whiteColor];
        self.searchContentCornerRadius = 5;
        
        [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self).valueOffset([NSValue valueWithUIEdgeInsets:self.searchTextFieldInset]);
        }];
        
        UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.searchBtn,self.textLabel]];
        stackView.axis = UILayoutConstraintAxisHorizontal;
        stackView.distribution = UIStackViewDistributionEqualSpacing;
        stackView.alignment = UIStackViewAlignmentCenter;
        stackView.spacing = 6;
        stackView.tintColor = UIColorHex(0xB2B2B2);
        [self.contentView addSubview:stackView];
        [stackView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self.contentView);
        }];
        UIButton *btn = [[UIButton alloc] init];
        [self addSubview:btn];
        [btn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.contentView);
        }];
        @weakify(self);
        [btn jk_addActionHandler:^(NSInteger tag) {
                @strongify(self);
                if (self.searchActionBlock) {
                        self.searchActionBlock();
                }
        }];
}
- (UIView *)contentView
{
        if (!_contentView) {
                _contentView = [[UIView alloc] init];
        }
        return _contentView;
}
- (QMUIButton *)searchBtn
{
        if (_searchBtn == nil) {
                _searchBtn = [[QMUIButton alloc] qmui_initWithImage:[UIImage sou_suo_zhuang_shi] title:nil];
                _searchBtn.userInteractionEnabled = NO;
        }
        return _searchBtn;
}
- (TTTAttributedLabel *)textLabel
{
        if (_textLabel == nil) {
                _textLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
                _textLabel.font = WGSystem14Font;
                _textLabel.textColor = UIColorHex(0xB2B2B2);
                _textLabel.text = @"搜索";
        }
        return _textLabel;
}
@end
