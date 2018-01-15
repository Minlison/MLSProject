//
//  MLSFeedBackReplayCommentCell.m
//  MinLison
//
//  Created by MinLison on 2017/11/20.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSFeedBackReplayCommentCell.h"
#import "MLSCustomButton.h"
@interface MLSFeedBackReplayCommentCell ()
@property (strong, nonatomic)  TTTAttributedLabel *commentLabel;
@property (strong, nonatomic)  TTTAttributedLabel *replayLabel;
@end

@implementation MLSFeedBackReplayCommentCell
- (void)updateContentWithModel:(MLSFeedBackCommentModel *)model
{
        [super updateContentWithModel:model];
        if (!NULLString(model.reply_content))
        {
                self.commentLabel.text = [self getAttributeCommentFormComment:model.content userName:model.nickname];
                self.replayLabel.text = NOT_NULL_STRING_DEFAULT_EMPTY(model.reply_content);
        }
        else
        {
                self.replayLabel.text = NOT_NULL_STRING_DEFAULT_EMPTY(model.content);
        }
}

- (void)setupView
{
        [super setupView];
        
        self.commentLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        self.commentLabel.numberOfLines = 0;
        self.commentLabel.backgroundColor = __UIColorFromHexRGBA(0xf0f0f0,0.3);
        self.commentLabel.font  = WGSystem14Font;
        self.commentLabel.textInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        self.commentLabel.lineSpacing = 3;
        [self.centerContentView addSubview:self.commentLabel];
        
        self.replayLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        self.replayLabel.numberOfLines = 0;
        self.replayLabel.lineSpacing = 3;
        self.replayLabel.font  = WGSystem14Font;
        self.replayLabel.textColor = UIColorHex(0x333333);
        [self.centerContentView addSubview:self.replayLabel];
        
        
        [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.centerContentView).offset(__WGWidth(12.0f));
                make.left.equalTo(self.centerContentView);
                make.right.equalTo(self.centerContentView);
        }];
        
        [self.replayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.commentLabel.mas_bottom).offset(__WGWidth(7.0f));
                make.right.equalTo(self.commentLabel.mas_right);
                make.left.equalTo(self.commentLabel.mas_left);
                make.bottom.equalTo(self.centerContentView.mas_bottom).offset(__WGWidth(-7.0f));
        }];
}
@end
