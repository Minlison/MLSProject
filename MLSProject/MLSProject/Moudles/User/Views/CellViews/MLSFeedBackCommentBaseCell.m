//
//  MLSFeedBackCommentBaseCell.m
//  MinLison
//
//  Created by MinLison on 2017/11/20.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSFeedBackCommentBaseCell.h"
#import "MLSCustomButton.h"

@interface MLSFeedBackCommentBaseCell ()
@property (strong, nonatomic)  QMUIGhostButton *headImageBtn;
@property (strong, nonatomic)  TTTAttributedLabel *userNameLabel;
@property (strong, nonatomic)  TTTAttributedLabel *timeLabel;
@property (strong, nonatomic)  MLSCustomButton*likeBtn;
@property(nonatomic, copy) WGFeedBackCommentActionBlock actionBlock;
@property(nonatomic, strong) MLSFeedBackCommentModel *commentModel;
@property(nonatomic, strong, readwrite) UIView *centerContentView;
@end

@implementation MLSFeedBackCommentBaseCell
- (BOOL)shouldUpdateCellWithObject:(MLSFeedBackCommentModel *)object
{
        if (![object isKindOfClass:[MLSFeedBackCommentModel class]])
        {
                return NO;
        }
        [self updateContentWithModel:object];
        return YES;
}
+ (CGFloat)heightForObject:(id)object identifier:(NSString *)identifier atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
        return UITableViewAutomaticDimension;
}
- (void)updateContentWithModel:(MLSFeedBackCommentModel *)model
{
        self.commentModel = model;
        [self.headImageBtn sd_setImageWithURL:[NSURL URLWithString:NOT_NULL_STRING_DEFAULT_EMPTY(model.img)] forState:(UIControlStateNormal) placeholderImage:[UIImage pic_default_avatar]];
        self.userNameLabel.text = NOT_NULL_STRING(model.nickname, [NSString app_NoNickName]);
        self.timeLabel.text = [AppUnit formatGMT8TimeMillisecond:model.time.floatValue withFormat:@"MM.dd HH:mm"];//@"10.13 12:14";
        self.likeBtn.selected = model.islike;
        [self.likeBtn setTitle:NOT_NULL_STRING(model.like, @"0") forState:UIControlStateNormal];
        [self.likeBtn setTitle:NOT_NULL_STRING(model.like, @"0") forState:UIControlStateSelected];
}
- (NSAttributedString *)getAttributeCommentFormComment:(NSString *)comment userName:(NSString *)userName
{
        NSString *userComment = [NSString stringWithFormat:@"%@:",NOT_NULL_STRING(userName, [NSString app_NoNickName])];
        NSMutableParagraphStyle *paramStyle = [[NSMutableParagraphStyle alloc] init];
        [paramStyle setParagraphStyle:[NSParagraphStyle defaultParagraphStyle]];
        paramStyle.lineSpacing = 3;
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]
                                           initWithString:userComment attributes:@{                                                                                                                                                 NSForegroundColorAttributeName : UIColorHex(0x333333),                                                                                                                                                 NSFontAttributeName : WGSystem14Font,NSParagraphStyleAttributeName : paramStyle}];
        [attr appendAttributedString:[[NSAttributedString alloc]
                                      initWithString:NOT_NULL_STRING_DEFAULT_EMPTY(comment) attributes:@{                                                                                                                                    NSForegroundColorAttributeName : UIColorHex(0x999999),                                                                                                                                    NSFontAttributeName : WGSystem14Font,NSParagraphStyleAttributeName : paramStyle}]];
        return attr;
}
- (void)setCommentCellActionBlock:(WGFeedBackCommentActionBlock)actionBlock
{
        self.actionBlock = actionBlock;
}
- (void)setupView
{
        [super setupView];
        self.headImageBtn = [[QMUIGhostButton alloc] init];
        self.headImageBtn.ghostColor = [UIColor clearColor];
        self.headImageBtn.clipsToBounds = YES;
        [self.contentView addSubview:self.headImageBtn];
        
        self.userNameLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        self.userNameLabel.font = WGSystem12Font;
        self.userNameLabel.textColor = UIColorHex(0x999999);
        self.userNameLabel.textAlignment = NSTextAlignmentLeft;
        
        self.timeLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        self.timeLabel.font    = WGSystem12Font;
        self.timeLabel.textColor = UIColorHex(0x999999);
        self.timeLabel.textAlignment = NSTextAlignmentLeft;
        
        UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.userNameLabel,self.timeLabel]];
        stackView.axis = UILayoutConstraintAxisVertical;
        stackView.distribution = UIStackViewDistributionFillProportionally;
        stackView.alignment = UIStackViewAlignmentFill;
        stackView.spacing = 2;
        [self.contentView addSubview:stackView];
        
        self.likeBtn = [MLSCustomButton rightImgButton];
        self.likeBtn.imageEdgeInsets = UIEdgeInsetsMake(-2.5, 0, 0, 0);
        self.likeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        self.likeBtn.spacingBetweenImageAndTitle = 4;
        self.likeBtn.titleLabel.font = WGSystem12Font;
        [self.likeBtn setTitleColor:UIColorHex(0x999999) forState:(UIControlStateNormal)];
        [self.likeBtn setTitleColor:UIColorHex(0xf6645f) forState:UIControlStateSelected];
        [self.likeBtn setImage:[UIImage comment_btn_like_nor] forState:UIControlStateNormal];
        [self.likeBtn setImage:[UIImage comment_btn_like_sel] forState:UIControlStateSelected];
        [self.likeBtn setTitle:@"0" forState:(UIControlStateNormal)];
        [self.likeBtn setTitle:@"0" forState:(UIControlStateSelected)];
        [self.contentView addSubview:self.likeBtn];
        @weakify(self);
        [self.likeBtn jk_addActionHandler:^(NSInteger tag) {
                @strongify(self);
                if (self.actionBlock) {
                        self.actionBlock(self.likeBtn.isSelected ? WGFeedBackCommentActionTypeUnLike : WGFeedBackCommentActionTypeLike, self.commentModel, ^(BOOL isSuccess) {
                                if (isSuccess) {
                                        self.likeBtn.selected = !self.likeBtn.isSelected;
                                        [self updateContentWithModel:self.commentModel];
                                }
                        });
                }
        }];
        
        
        self.centerContentView = [[UIView alloc] init];
        self.centerContentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.centerContentView];
        
        [self.headImageBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView).offset(__WGWidth(14.0f));
                make.left.equalTo(self.contentView).offset(__WGWidth(14.0f));
                make.height.width.mas_equalTo(__WGWidth(30.0f));
        }];
        
        [stackView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.headImageBtn);
                make.left.equalTo(self.headImageBtn.mas_right).offset(__WGWidth(10.0f));
                make.right.lessThanOrEqualTo(self.likeBtn.mas_left).offset(-__WGWidth(8.0f));
        }];
        
        [self.likeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.headImageBtn.mas_centerY).offset(-self.likeBtn.imageEdgeInsets.top);
                make.right.equalTo(self.contentView.mas_right).offset(__WGWidth(-10.0f));
                make.width.mas_equalTo(__WGWidth(80.0f));
                make.height.mas_equalTo(__WGHeight(30.0f));
        }];
        
        
        [self.centerContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(stackView.mas_bottom);
                make.left.equalTo(stackView.mas_left);
                make.right.equalTo(self.likeBtn.imageView.mas_right);
                make.bottom.equalTo(self.contentView.mas_bottom).priorityHigh();
        }];
}

@end
