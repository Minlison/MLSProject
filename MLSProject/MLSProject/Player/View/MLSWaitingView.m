//
//  MLSWaitingView.m
//  Test
//
//  Created by MinLison on 2017/3/7.
//  Copyright © 2017年 com.minlison.orgz. All rights reserved.
//

#import "MLSWaitingView.h"
@interface MLSWaitingView()
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UIActivityIndicatorView *loadingView;

@end

@implementation MLSWaitingView
+ (instancetype)waitingView
{
	return [[self alloc] initWithFrame:CGRectZero];
}
- (instancetype)initWithFrame:(CGRect)frame
{
        if (self = [super initWithFrame:frame]) {
                [self _SetupUI];
        }
        return self;
}
- (void)_SetupUI
{
        [self addSubview:self.loadingView];
        [self addSubview:self.nameLabel];
        [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.mas_top);
                make.centerX.equalTo(self.mas_centerX);
                make.left.greaterThanOrEqualTo(self.mas_left);
                make.right.lessThanOrEqualTo(self.mas_right);
        }];
        [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.loadingView.mas_bottom).offset(13);
                make.bottom.equalTo(self.mas_bottom);
                make.left.greaterThanOrEqualTo(self.mas_left);
                make.right.lessThanOrEqualTo(self.mas_right);
        }];
        self.backgroundColor = [UIColor blackColor];
        [self _SetUPLabel];
        [self.loadingView startAnimating];
}
- (void)rotate
{
        [self.loadingView startAnimating];
}
- (void)_SetUPLabel
{
        self.nameLabel.font = [UIFont systemFontOfSize:15];
        self.nameLabel.textColor = UIColorHex(0xa8a8a8);
        self.loadingView.transform = CGAffineTransformIdentity;
        self.nameLabel.text = self.video_name;
}

- (void)setVideo_name:(NSString *)video_name
{
	_video_name = video_name;
	[self _SetUPLabel];
}

- (void)sizeToFit
{
	CGSize size = [self sizeThatFits:CGSizeMake([UIScreen mainScreen].bounds.size.width * 0.5, [UIScreen mainScreen].bounds.size.height * 0.5)];
	self.bounds = CGRectMake(0, 0, size.width, size.height);
}

- (UILabel *)nameLabel
{
        if (_nameLabel == nil) {
                _nameLabel = [[UILabel alloc] init];
                _nameLabel.font = [UIFont systemFontOfSize:15];
                _nameLabel.textColor = UIColorHex(0xA8A8A8);
        }
        return _nameLabel;
}
- (UIActivityIndicatorView *)loadingView
{
        if (_loadingView == nil) {
                _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhite) size:CGSizeMake(30, 30)];
        }
        return _loadingView;
}
@end
