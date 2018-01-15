//
//  MLSCommentTableViewCell.m
//  MinLison
//
//  Created by minlison on 2017/10/26.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSCommentTableViewCell.h"
#import "MLSCustomButton.h"
@interface MLSCommentTableViewCell()
//头像
@property (strong, nonatomic)  QMUIGhostButton *headImageBtn;
//用户昵称
@property (strong, nonatomic)  TTTAttributedLabel *userNameLabel;
//时间
@property (strong, nonatomic)  TTTAttributedLabel *timeLabel;
//内容
@property (strong, nonatomic)  TTTAttributedLabel *commendLabel;
//点赞
@property (strong, nonatomic)  MLSCustomButton *likeBtn;
@property(nonatomic, copy) WGCommentActionBlock actionBlock;
@end
@implementation MLSCommentTableViewCell


- (void)setCommentCellActionBlock:(WGCommentActionBlock)actionBlock
{
        self.actionBlock = actionBlock;
        [self.likeBtn setTitle:NOT_NULL_STRING(self.model.like, @"0") forState:UIControlStateNormal];
}
- (BOOL)shouldUpdateCellWithObject:(MLSCommentModel *)object
{
        if ([object isKindOfClass:[MLSCommentModel class]])
        {
                [self setModel:object];
                return YES;
        }
        return NO;
}
- (void)setModel:(MLSCommentModel *)model
{
        _model = model;
        [self.headImageBtn sd_setImageWithURL:[NSURL URLWithString:NOT_NULL_STRING_DEFAULT_EMPTY(model.img)] forState:(UIControlStateNormal) placeholderImage:[UIImage pic_default_avatar]];
        self.userNameLabel.text = model.nickname;
        self.commendLabel.text = NOT_NULL_STRING_DEFAULT_EMPTY(model.content);
        self.timeLabel.text = [AppUnit formatGMT8TimeMillisecond:model.time.floatValue withFormat:@"MM.dd HH:mm"];
        [self.likeBtn setTitle:NOT_NULL_STRING(model.like, @"0") forState:UIControlStateNormal];
        self.likeBtn.selected = model.islike;
}

- (void)setupView
{
        [super setupView];
        self.headImageBtn = [[QMUIGhostButton alloc] init];
        self.headImageBtn.ghostColor = [UIColor clearColor];
        self.headImageBtn.clipsToBounds = YES;
        self.headImageBtn.userInteractionEnabled = NO;
        [self.contentView addSubview:self.headImageBtn];
        
        self.userNameLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        self.userNameLabel.font = WGSystem12Font;
        self.userNameLabel.textColor = UIColorHex(0x999999);
        self.userNameLabel.textAlignment = NSTextAlignmentLeft;
        
        
        self.timeLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        self.timeLabel.textAlignment = NSTextAlignmentLeft;
        self.timeLabel.font    = WGSystem12Font;
        self.timeLabel.textColor = UIColorHex(0x999999);
        
        UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.userNameLabel,self.timeLabel]];
        stackView.axis = UILayoutConstraintAxisVertical;
        stackView.distribution = UIStackViewDistributionFillProportionally;
        stackView.alignment = UIStackViewAlignmentFill;
        stackView.spacing = 2;
        [self.contentView addSubview:stackView];
        
        
        self.likeBtn = [MLSCustomButton rightImgButton];
        self.likeBtn.contentMode = UIControlContentVerticalAlignmentFill;
        self.likeBtn.imageEdgeInsets = UIEdgeInsetsMake(-2.5, 0, 0, 0);
        self.likeBtn.spacingBetweenImageAndTitle = 4;
        [self.likeBtn setImage:[UIImage comment_btn_like_nor] forState:UIControlStateNormal];
        [self.likeBtn setImage:[UIImage comment_btn_like_sel] forState:UIControlStateSelected];
        [self.likeBtn setTitleColor:UIColorHex(0xf6645f) forState:UIControlStateSelected];
        [self.likeBtn setTitleColor:UIColorHex(0x999999) forState:UIControlStateNormal];
        self.likeBtn.titleLabel.font =WGSystem12Font;
        [self.contentView addSubview:self.likeBtn];
        [self.likeBtn addTarget:self action:@selector(likeClick:) forControlEvents:UIControlEventTouchUpInside];
        
        self.commendLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        self.commendLabel.textColor = UIColorHex(0x333333);
        self.commendLabel.numberOfLines = 0;
        self.commendLabel.font  = WGSystem14Font;
        [self.contentView addSubview:self.commendLabel];
        
        [self.headImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView).offset(__WGWidth(10.0f));
                make.leading.equalTo(self.contentView).offset(__WGWidth(13.0f));
                make.height.width.offset(__WGWidth(28.0f));
        }];
        
        [stackView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.headImageBtn);
                make.leading.equalTo(self.headImageBtn.mas_trailing).offset(__WGWidth(10.0f));
                make.trailing.lessThanOrEqualTo(self.likeBtn.mas_leading).offset(-__WGWidth(8.0f));
        }];
        
        
        [self.likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.headImageBtn.mas_centerY).offset(-self.likeBtn.imageEdgeInsets.top);
                make.trailing.equalTo(self.contentView).offset(__WGWidth(10.0f));
                make.width.mas_equalTo(__WGWidth(80.0f));
                make.height.mas_equalTo(__WGWidth(30.0f));
        }];
        
        [self.commendLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(stackView.mas_bottom).offset(__WGWidth(10.0f));
                make.leading.equalTo(stackView);
                make.trailing.equalTo(self.contentView.mas_trailing).offset(-__WGWidth(9.0f));
                make.bottom.equalTo(self.contentView.mas_bottom).offset(-__WGWidth(18.0f)).priorityMedium();
        }];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = UIColorHex(0xC4C4C4);
        lineView.alpha = 0.5;
        lineView.hidden = YES;
        [self.contentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(self.contentView).offset(__WGWidth(15.0f));
                make.trailing.equalTo(self.contentView.mas_trailing).offset(-__WGWidth(15.0f));
                make.bottom.equalTo(self.contentView.mas_bottom);
                make.height.offset(0.5);
        }];
}

- (void)likeClick:(MLSCustomButton *)btn
{
        @weakify(self);
        if (self.actionBlock) {
                self.actionBlock(btn.isSelected ? WGCommentActionTypeUnLike : WGCommentActionTypeLike, self.model, ^(BOOL isSuccess) {
                        @strongify(self);
                        if (isSuccess) {
                                [self setModel:self.model];
                        }
                });
        }
}

@end
