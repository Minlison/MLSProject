//
//  MLSFastView.m
//  MLSProject
//
//  Created by MinLison on 2017/6/12.
//  Copyright © 2017年 com.minlison.orgz. All rights reserved.
//

#import "MLSFastView.h"

@interface MLSFastView()
@property (strong, nonatomic) UIImageView *fastImageView;
@property (strong, nonatomic) UILabel *fastTimeLabel;
@property (strong, nonatomic) UIProgressView *fastProgressView;
@property (assign, nonatomic) NSInteger seekCount;
@property (assign, nonatomic) BOOL countForward;
@end
@implementation MLSFastView
- (instancetype)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) {
		[self _InitSubViews];
	}
	return self;
}
- (void)_InitSubViews
{
	self.backgroundColor     = [UIColor colorWithWhite:0 alpha:0.8];
	self.layer.cornerRadius  = 4;
	self.layer.masksToBounds = YES;
	[self addSubview:self.fastImageView];
	[self addSubview:self.fastTimeLabel];
	[self addSubview:self.fastProgressView];
	
	[self mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.mas_equalTo(150);
		make.height.mas_equalTo(80);
	}];
	
	[self.fastImageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.height.width.mas_equalTo(32);
		make.top.equalTo(self.mas_top).offset(5);
		make.centerX.equalTo(self.mas_centerX);
	}];
	
	
	[self.fastTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.equalTo(self);
		make.top.equalTo(self.fastImageView.mas_bottom).offset(-8);
	}];
	
	[self.fastProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.height.mas_equalTo(2);
		make.left.equalTo(self.mas_left).offset(12);
		make.right.equalTo(self.mas_right).offset(-12);
		make.top.equalTo(self.fastTimeLabel.mas_bottom).offset(5);
		make.bottom.mas_equalTo(self.mas_bottom).offset(-8);
	}];
}

- (UIImageView *)fastImageView {
	if (!_fastImageView) {
		_fastImageView = [[UIImageView alloc] init];
	}
	return _fastImageView;
}

- (UILabel *)fastTimeLabel {
	if (!_fastTimeLabel) {
		_fastTimeLabel               = [[UILabel alloc] init];
		_fastTimeLabel.textColor     = [UIColor whiteColor];
		_fastTimeLabel.textAlignment = NSTextAlignmentCenter;
		_fastTimeLabel.font          = [UIFont systemFontOfSize:14.0];
	}
	return _fastTimeLabel;
}

- (UIProgressView *)fastProgressView {
	if (!_fastProgressView) {
		_fastProgressView                   = [[UIProgressView alloc] init];
		_fastProgressView.progressTintColor = UIColorHex(0x48dbff);
		_fastProgressView.trackTintColor    = [UIColor colorWithWhite:0 alpha:0.4];
	}
	return _fastProgressView;
}
- (void)setFormatTime:(NSString *)formatTime progress:(CGFloat)progress forward:(BOOL)forawrd
{
	if (forawrd) {
		self.fastImageView.image = [UIImage player_fast_forward];
	} else {
		self.fastImageView.image = [UIImage player_fast_backward];
	}
	self.hidden           = NO;
	self.fastTimeLabel.text        = formatTime;
	self.fastProgressView.progress = progress;
}

@end
