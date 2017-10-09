//
//  MLSPlayerView.m
//  MLSProject
//
//  Created by MinLison on 2017/9/12.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSPlayerView.h"
#import "MLSPlayerControlProtocol.h"

#define MLSPlayerViewAnimationDuration 0.5f
@interface MLSPlayerView ()
@property(nonatomic, assign) UIInterfaceOrientation orientation;
@property(nonatomic, strong) UIView *contentView;
@end

@implementation MLSPlayerView
- (void)setupView
{
        self.backgroundColor = [UIColor blackColor];
        self.clipsToBounds = YES;
        [self addSubview:self.contentView];
        CGFloat height = MAX([[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width);
        CGFloat width = MIN([[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width);
        CGRect frame = CGRectMake(0, 0, width, height);
        self.contentView.frame = frame;
}
- (UIView *)contentView
{
        if (_contentView == nil) {
                _contentView = [[UIView alloc] init];
                _contentView.backgroundColor = [UIColor clearColor];
        }
        return _contentView;
}
- (void)setPlayerView:(UIView *)playerView
{
        if (_playerView != playerView)
        {
                [_playerView removeFromSuperview];
                [self.contentView addSubview:playerView];
                [playerView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.edges.equalTo(self.contentView);
                }];
                _playerView = playerView;
                [self.contentView sendSubviewToBack:playerView];
        }
}

- (void)setPlayerControlView:(UIView<MLSPlayerControlProtocol> *)playerControlView
{
        if (_playerControlView != playerControlView)
        {
                [_playerControlView removeFromSuperview];
                [self.contentView addSubview:playerControlView];
                [playerControlView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.edges.equalTo(self.contentView);
                }];
                _playerControlView = playerControlView;
                [self.contentView bringSubviewToFront:playerControlView];
        }
}

/**
 播放器视图布局
 */
- (void)_ResetPlayerViewLayout
{
        [self.playerControlView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.contentView);
        }];
        [self.playerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.contentView);
        }];
}

/**
  竖屏布局
 */
- (void)_ResetPortraitLayout
{
        CGFloat height = MAX([[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width);
        CGFloat width = MIN([[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width);
        
        [self _ResetPlayerViewLayout];
        [self.contentView setTransform:CGAffineTransformIdentity];
        [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left).offset(0);
                make.top.equalTo(self.mas_top).offset(0);
                make.width.mas_equalTo(width);
                make.height.mas_equalTo(height);
        }];
        [self setNeedsLayout];
}

/**
 横屏布局
 */
- (void)_ResetLandscapeLayout
{
        CGFloat height = MIN([[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width);
        CGFloat width = MAX([[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width);
        CGFloat rotateValue = M_PI_2;
        if (self.orientation == UIInterfaceOrientationLandscapeLeft) {
                rotateValue = -M_PI_2;
        }
        
        [self _ResetPlayerViewLayout];
        [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left).offset((height - width) / 2);
                make.top.equalTo(self.mas_top).offset((width - height) / 2);
                make.width.mas_equalTo(width);
                make.height.mas_equalTo(height);
        }];
        [self setNeedsLayout];
        [self.contentView setTransform:CGAffineTransformMakeRotation(rotateValue)];
}

/**
 旋转至屏幕适配方向

 @param orientation 屏幕方向
 */
- (void)rotateContentViewToOrientation:(UIInterfaceOrientation)orientation
{
        self.orientation = orientation;
        [self.playerControlView setFullScreen:UIInterfaceOrientationIsLandscape(self.orientation)];
        
        
        if (UIInterfaceOrientationIsPortrait(self.orientation))
        {
                [UIView animateWithDuration:MLSPlayerViewAnimationDuration animations:^{
                        [self _ResetPortraitLayout];
                } completion:^(BOOL finished) {
                }];
        }
        else
        {

                if ( CGRectEqualToRect(self.contentView.frame, self.bounds) ) // 当前是竖屏
                {
                        [UIView animateWithDuration:MLSPlayerViewAnimationDuration animations:^{
                                [self _ResetLandscapeLayout];
                        } completion:^(BOOL finished) {
                        }];
                }
                else
                {
                        /// 如果当前是横屏, 就旋转180度
                        [UIView animateWithDuration:MLSPlayerViewAnimationDuration animations:^{
                                
                                [self _ResetPlayerViewLayout];
                                
                                CGFloat rotateValue = M_PI_2;
                                
                                if (self.orientation == UIInterfaceOrientationLandscapeLeft)
                                {
                                        rotateValue = -M_PI_2;
                                }
                                [self.contentView setTransform:CGAffineTransformMakeRotation(rotateValue)];
                        } completion:^(BOOL finished) {
                        }];
                }
        }
        
}


@end
