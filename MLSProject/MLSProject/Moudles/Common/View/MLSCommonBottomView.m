//
//  MLSCommonBottomView.m
//  MLSProject
//
//  Created by MinLison on 2017/12/14.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "MLSCommonBottomView.h"
@interface MLSCommonBottomView ()
@property(nonatomic, strong, readwrite) QMUIGhostButton *actionButton;
@end
@implementation MLSCommonBottomView

- (void)setupView
{
        [super setupView];
        [self addSubview:self.actionButton];
        [self.actionButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self).valueOffset([NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(8, 15, 8, 15)]);
        }];
}

- (QMUIGhostButton *)actionButton
{
        if (_actionButton == nil) {
                _actionButton = [[QMUIGhostButton alloc] init];
                _actionButton.titleLabel.font = WGSystem16Font;
                _actionButton.adjustsImageWhenHighlighted = NO;
                _actionButton.ghostColor = UIColorHex(0x0190D4);
                _actionButton.cornerRadius = 5;
                _actionButton.clipsToBounds = YES;
                [_actionButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
                [_actionButton setTitle:@"" forState:(UIControlStateNormal)];
                [_actionButton setBackgroundImage:[UIImage imageWithColor:UIColorHex(0x0190D4)] forState:(UIControlStateNormal)];
        }
        return _actionButton;
}


@end
