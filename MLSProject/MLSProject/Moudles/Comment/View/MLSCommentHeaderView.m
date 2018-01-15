//
//  MLSCommentHeaderView.m
//  MinLison
//
//  Created by minlison on 2017/10/26.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSCommentHeaderView.h"

@interface MLSCommentHeaderView()
/** 内部的label */
@property (nonatomic, strong) TTTAttributedLabel *label;
@end
@implementation MLSCommentHeaderView

- (void)setupView
{
        [super setupView];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.label = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        self.label.font = WGBoldSystem15Font;
        self.label.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.label];
        
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView).offset(__WGWidth(20.0f));
                make.bottom.equalTo(self.contentView).offset(-__WGHeight(10)).priorityLow();
                make.leading.equalTo(self.contentView).offset(__WGWidth(11.0f));
                make.trailing.lessThanOrEqualTo(self.contentView.mas_trailing).offset(-__WGWidth(20.0f));
        }];
        
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = UIColorHex(0xf7f7f7);
        [self.contentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.leading.trailing.equalTo(self.contentView);
                make.height.mas_equalTo(1);
        }];
}
- (void)setText:(NSString *)text
{
        _text = text;
        self.label.text = text;
}

@end
