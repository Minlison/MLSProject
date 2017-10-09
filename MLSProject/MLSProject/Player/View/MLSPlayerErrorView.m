//
//  MLSPlayerErrorView.m
//  Test
//
//  Created by MinLison on 2017/3/9.
//  Copyright © 2017年 com.minlison.orgz. All rights reserved.
//

#import "MLSPlayerErrorView.h"
@interface MLSPlayerErrorView()
@property (strong, nonatomic) UIImageView *errImgView;
@property (strong, nonatomic) UILabel *errDesLabel;
@property (strong, nonatomic) UILabel *errorInfoLabel;
@property (strong, nonatomic) UIButton *confirmBtn;
@property (copy, nonatomic) void (^ConfirmBlock)();
@end

@implementation MLSPlayerErrorView
+ (instancetype)errorView
{
    return [[self alloc] initWithFrame:CGRectZero];
}
- (instancetype)initWithFrame:(CGRect)frame
{
        if (self = [super initWithFrame:frame])
        {
                [self _SetupUI];
                
        }
        return self;
}
- (void)_SetupUI
{
        [self addSubview:self.errImgView];
        [self addSubview:self.errDesLabel];
        [self addSubview:self.errorInfoLabel];
        [self addSubview:self.confirmBtn];
        [self _LayoutWithConfirmButton:YES];
        
}
- (void)_LayoutWithConfirmButton:(BOOL)configBtn
{
        [self.errImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.errorInfoLabel.mas_centerX);
        }];
        [self.errorInfoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.mas_centerX);
                make.centerY.equalTo(self.mas_centerY).offset(configBtn ? -10 : 0);
                make.top.equalTo(self.errImgView.mas_bottom).offset(10);
        }];
        [self.errDesLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.errorInfoLabel.mas_bottom).offset(5);
                make.centerX.equalTo(self.errorInfoLabel.mas_centerX);
        }];
        
        [self.confirmBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.errDesLabel.mas_bottom).offset(18);
                make.centerX.equalTo(self.errorInfoLabel.mas_centerX);
                make.width.mas_equalTo(69);
                make.height.mas_equalTo(22);
        }];
}
- (void)setError:(NSError *)error confirm:(void (^)(void))block
{
	[self setError:error noWifi:NO confirm:block];
}
- (void)setError:(NSError *)error noWifi:(BOOL)nowifi confirm:(void (^)(void))block
{
        if (!block)
        {
                self.confirmBtn.hidden = YES;
                [self _LayoutWithConfirmButton:NO];
        }
        else
        {
                self.confirmBtn.hidden = NO;
                [self _LayoutWithConfirmButton:YES];
        }
	self.ConfirmBlock = block;
	self.errorInfoLabel.text = error.localizedDescription;
	self.errDesLabel.text = error.localizedFailureReason;
        self.errImgView.image = nowifi ? [UIImage player_wifi_error] : [UIImage player_pattern_error];
}


- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
	return [self.confirmBtn pointInside:[self convertPoint:point toView:self.confirmBtn] withEvent:event];
}

- (void)confirmBtnClick:(UIButton *)sender
{
	if (self.ConfirmBlock)
	{
		self.ConfirmBlock();
	}
}
- (UIImageView *)errImgView
{
        if (_errImgView == nil) {
                _errImgView = [[UIImageView alloc] init];
                _errImgView.image = [UIImage player_pattern_error];
        }
        return _errImgView;
}
- (UILabel *)errorInfoLabel
{
        if (_errorInfoLabel == nil) {
                _errorInfoLabel = [[UILabel alloc] init];
                _errorInfoLabel.font = [UIFont systemFontOfSize:15];
                _errorInfoLabel.textColor = UIColorHex(0x979797);
        }
        return _errorInfoLabel;
}
- (UILabel *)errDesLabel
{
        if (_errDesLabel == nil) {
                _errDesLabel = [[UILabel alloc] init];
                _errDesLabel.font = [UIFont systemFontOfSize:11];
                _errDesLabel.textColor = UIColorHex(0x535353);
        }
        return _errDesLabel;
}
- (UIButton *)confirmBtn
{
        if (_confirmBtn == nil) {
                _confirmBtn = [[UIButton alloc] init];
                [_confirmBtn setTitleColor:UIColorHex(0x979797) forState:(UIControlStateNormal)];
                _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:11];
                _confirmBtn.backgroundColor = UIColorHex(0x131313);
                [_confirmBtn setTitle:@"确认" forState:(UIControlStateNormal)];
                [_confirmBtn addTarget:self action:@selector(confirmBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        }
        return _confirmBtn;
}
@end
