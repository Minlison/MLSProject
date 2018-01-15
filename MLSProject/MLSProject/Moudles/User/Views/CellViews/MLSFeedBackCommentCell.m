//
//  MLSFeedBackCommentCell.m
//  MinLison
//
//  Created by MinLison on 2017/11/8.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSFeedBackCommentCell.h"
#import "MLSFeedBackCommentModel.h"
#import "MLSCustomButton.h"
@interface MLSFeedBackCommentCell ()
@property (strong, nonatomic)  TTTAttributedLabel *commentLabel;
@end
@implementation MLSFeedBackCommentCell
- (void)updateContentWithModel:(MLSFeedBackCommentModel *)model
{
        [super updateContentWithModel:model];
        self.commentLabel.text = NOT_NULL_STRING_DEFAULT_EMPTY(model.content);
}
- (void)setupView
{
        [super setupView];
        
        
        self.commentLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        self.commentLabel.numberOfLines = 0;
        self.commentLabel.backgroundColor = [UIColor clearColor];
        self.commentLabel.font  = WGSystem14Font;
//        self.commentLabel.textInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        self.commentLabel.lineSpacing = 3;
        [self.centerContentView addSubview:self.commentLabel];
        
        
        [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.centerContentView).offset(__WGWidth(12.0f));
                make.left.equalTo(self.centerContentView);
                make.right.equalTo(self.centerContentView);
                make.bottom.equalTo(self.centerContentView).offset(__WGWidth(-7.0f));
        }];
}

@end
