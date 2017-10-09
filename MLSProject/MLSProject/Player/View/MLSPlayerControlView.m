//
//  MLSPlayerControlView.m
//  MLSProject
//
//  Created by MinLison on 2017/9/12.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSPlayerControlView.h"
#import "ASValueTrackingSlider.h"
#import "MLSStateView.h"
#import "MLSPlayerGestureView.h"
#import "MLSFastView.h"
#define MLSPlayerTopViewHeight           64
#define MLSPlayerBottomViewHeight        64
#define MLSPlayerTimeLabelHasHour        60
#define MLSPlayerTimeLabelHasNotHour     40
#define MLSPlayerControlHideDelay        3.0
#define MLSPlayerControlHideAnimationDuration 0.3
#define _MLS_MOVIE_ERROR_(err_code,title,des) [NSError errorWithDomain:@"MLSMoviePlayer" code:err_code userInfo:@{NSLocalizedFailureReasonErrorKey : des, NSLocalizedDescriptionKey : title}]

@interface MLSPlayerControlView () <UIGestureRecognizerDelegate,MLSPlayerGestureViewDelegate>
@property(nonatomic, strong) UIView *topView;
@property(nonatomic, strong) UIButton *backButton;
@property(nonatomic, strong) UIImageView *backImgView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIView *bottomView;
@property(nonatomic, strong) UIButton *playButton;
@property(nonatomic, strong) ASValueTrackingSlider *slider;
@property(nonatomic, strong) UILabel *currentTimeLabel;
@property(nonatomic, strong) UILabel *totoalTimeLabel;
@property(nonatomic, strong) UIButton *fullScreenButton;
@property(nonatomic, strong) MLSPlayerGestureView *gestureView;
@property(nonatomic, strong) MLSStateView *stateView;
@property(nonatomic, assign,readwrite, getter=isShowing) BOOL showing;
@property(nonatomic, assign, getter=isAnimationing) BOOL animationing;
@property(nonatomic, assign, getter=isSliderBeingDragged) BOOL sliderBeingDragged;
@property(nonatomic, assign, getter=isTimeHasHour) BOOL timeHasHour;
@property(nonatomic, assign) MLSPlayerMovedValue lastMovedValue;
@property(nonatomic, assign, getter=isError) BOOL error;
@property(nonatomic, assign, getter=isShowHUDView) BOOL showHUDView;

@end

@implementation MLSPlayerControlView
@synthesize fullScreen = _fullScreen;
@synthesize loadState = _loadState;
@synthesize playback = _playback;
@synthesize delegate = _delegate;
@synthesize delegatePlayer = _delegatePlayer;
@synthesize currentUseCellar = _currentUseCellar;
@synthesize noNetwork = _noNetwork;
@synthesize showing = _showing;
@synthesize playModel = _playModel;
@synthesize allowCeller = _allowCeller;

- (instancetype)initWithFrame:(CGRect)frame
{
        if (self == [super initWithFrame:frame])
        {
                self.showing = YES;
                [self _SetupUI];
        }
        return self;
}

/// MARK: - Setter Method
- (void)setError:(NSError *)error confirm:(void (^)())block
{
        self.error = YES;
        [self showAnimation:YES];
        self.playButton.enabled = NO;
        [self.stateView setError:error confirm:block];
}
- (void)setPlayModel:(MLSPlayerModel *)playModel
{
        _playModel = playModel;
        self.titleLabel.text = playModel.name;
}
- (void)setTimeHasHour:(BOOL)timeHasHour
{
        if (_timeHasHour != timeHasHour)
        {
                [self _LayoutBottomView];
                _timeHasHour = timeHasHour;
        }
}
- (void)setFullScreen:(BOOL)fullScreen
{
        _fullScreen = fullScreen;
        [self _LayoutTopView];
        [self _LayoutBottomView];
        [self _LayoutTopAndBottomViewWithShowing:self.isShowing];
}
- (void)setLoadState:(IJKMPMovieLoadState)loadState
{
        switch (loadState) {
                case IJKMPMovieLoadStateUnknown:
                {
                        self.stateView.state = MLSStatePrepare;
                }
                        break;
                case IJKMPMovieLoadStatePlayable:
                {
                        if (!self.currentUseCellar || (self.currentUseCellar && self.allowCeller))
                        {
                                [self.delegatePlayer play];
                        }
                        self.stateView.state = MLSStateLoading;
                }
                        break;
                case IJKMPMovieLoadStatePlaythroughOK:
                {
                        self.stateView.state = MLSStateLoading;
                }
                        break;
                case IJKMPMovieLoadStateStalled:
                {
                        self.stateView.state = MLSStateLoading;
                }
                        break;
                default:
                        break;
        }
}
- (void)setPlayback:(IJKMPMoviePlaybackState)playback
{
        switch (playback)
        {
                case IJKMPMoviePlaybackStateStopped:
                {
                        self.playButton.selected = NO;
                        self.stateView.state = MLSStateCompletion;
                        [self showAnimation:YES];
                }
                        break;
                case IJKMPMoviePlaybackStatePlaying:
                {
                        self.playButton.selected = YES;
                        self.stateView.state = MLSStatePlaying;
                        [self hideAnimation:YES delay:MLSPlayerControlHideDelay];
                }
                        break;
                case IJKMPMoviePlaybackStatePaused:
                {
                        self.playButton.selected = NO;
                        self.stateView.state = MLSStatePaused;
                        
                }
                        break;
                case IJKMPMoviePlaybackStateInterrupted:
                {
                        self.playButton.selected = NO;
                        self.stateView.state = MLSStateCompletion;
                }
                        break;
                case IJKMPMoviePlaybackStateSeekingForward:
                case IJKMPMoviePlaybackStateSeekingBackward:
                {
                }
                        break;
                default:
                        break;
        }
}
- (void)setCurrentUseCellar:(BOOL)currentUseCellar
{
        if (_currentUseCellar != currentUseCellar)
        {
                if (currentUseCellar && !self.allowCeller)
                {
                        @weakify(self);
                        [self.stateView setError:_MLS_MOVIE_ERROR_(0,@"您当前处于非 WIFI 网络", @"是否继续") noWifi:YES confirm:^{
                                @strongify(self);
                                self.allowCeller = YES;
                                if (self.delegate && [self.delegate respondsToSelector:@selector(playerControl:allowCellerNetwork:)])
                                {
                                        [self.delegate playerControl:self allowCellerNetwork:self.allowCeller];
                                }
                                [self.delegatePlayer play];
                        }];
                }
        }
}
/// MARK: - GestureDelegate

- (void)playerGestureTap:(MLSPlayerGestureState)state
{
        [self hideOrShowControl];
}
- (void)playerGestureThirdTap:(MLSPlayerGestureState)state
{
        if (self.delegate && [self.delegate respondsToSelector:@selector(playerControl:showHUDView:)])
        {
                self.showHUDView = !self.isShowHUDView;
                [self.delegate playerControl:self showHUDView:self.isShowHUDView];
        }
}
- (void)playerGestureMoved:(MLSPlayerGestureState)state StartPosition:(MLSPlayerPosition)position direction:(MLSPlayerMoveDirection)direction valueChanged:(MLSPlayerMovedValue)value
{
        if (!self.isFullScreen) {
                return;
        }
        if (state == MLSPlayerGestureStateStart)
        {
                if (direction == MLSPlayerMoveDirectionLeft || direction == MLSPlayerMoveDirectionRight)
                {
                        [self beginSeek];
                }
                
        }
        else if (state == MLSPlayerGestureStateMoved)
        {
                // 向上移动, 或者向下移动, 表示调整亮度或者音量
                if (direction == MLSPlayerMoveDirectionTop || direction == MLSPlayerMoveDirectionBootom)
                {
                        // 左侧,调整亮度
                        if (position == MLSPlayerPositionLeft)
                        {
                                [self.stateView addBrightness:value.vertical animation:YES];
                        }
                        // 右侧调整音量
                        else if (position == MLSPlayerPositionRight)
                        {
                                [self.stateView addVolume:value.vertical animation:YES];
                        }
                }
                else if (direction == MLSPlayerMoveDirectionLeft || direction == MLSPlayerMoveDirectionRight)
                {
                        // 表示调整进度 seek
                        [self _SeekUIWithAddSeconds:value.horizontal * 100];
                }
        }
        else if (state == MLSPlayerGestureStateEnd)
        {
                if (direction == MLSPlayerMoveDirectionLeft || direction == MLSPlayerMoveDirectionRight)
                {
                        // 结束,调整进度
                        [self endSeek];
                }
        }
}
- (void)playerGestureScale:(MLSPlayerGestureState)state scale:(CGFloat)scale
{
        
}
- (void)_SeekUIWithAddSeconds:(CGFloat)seconds
{
        self.slider.value = MIN(self.slider.maximumValue, MAX(0, self.slider.value + seconds));
        NSString *fastViewFormat = [NSString stringWithFormat:@"%@/%@",[self getHourMinutesSecondsWithStamp:self.slider.value],[self getHourMinutesSecondsWithStamp:self.delegatePlayer.duration]];
        
        [self.stateView setFormatTime:fastViewFormat progress:(self.slider.value/self.slider.maximumValue) forward:seconds > 0];
        [self continueSeek];
}
/// MARK: - Private Method
- (void)_SetupUI
{
        [self _SetUPStateView];
        [self _SetUpGestureControl];
        [self _SetupTopView];
        [self _SetupBottomView];
        
        [self _LayoutTopAndBottomViewWithShowing:YES];
        [self refreshMediaControl];
}
- (void)_SetUpGestureControl
{
        [self addSubview:self.gestureView];
        [self sendSubviewToBack:self.gestureView];
        [self.gestureView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
        }];
}
- (void)_SetUPStateView
{
        [self addSubview:self.stateView];
        [self.stateView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
        }];
        
}

- (void)_SetupTopView
{
        [self.topView addSubview:self.backImgView];
        [self.topView addSubview:self.backButton];
        [self.topView addSubview:self.titleLabel];
        [self addSubview:self.topView];
        
        [self _LayoutTopView];
}
- (void)_SetupBottomView
{
        [self.bottomView addSubview:self.playButton];
        [self.bottomView addSubview:self.currentTimeLabel];
        [self.bottomView addSubview:self.slider];
        [self.bottomView addSubview:self.totoalTimeLabel];
        [self addSubview:self.bottomView];
        
        [self _LayoutBottomView];
}

- (void)_LayoutTopView
{
        [self.titleLabel removeFromSuperview];
        [self.topView addSubview:self.titleLabel];
        
        [self.backButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.topView.mas_left).offset(10);
                make.top.equalTo(self.topView.mas_top).offset(26);
                make.width.mas_equalTo(128);
                make.bottom.equalTo(self.topView.mas_bottom);
        }];
        
        [self.backImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.topView.mas_left).offset(10);
                make.top.equalTo(self.topView.mas_top).offset(26);
        }];
        
        
        if ( self.isFullScreen )
        {
                
                [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(self.backImgView.mas_right);
                        make.centerY.equalTo(self.backImgView.mas_centerY);
                }];
        }
        else
        {
                [self.titleLabel removeFromSuperview];
                [self.topView addSubview:self.titleLabel];
                
                [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.centerX.equalTo(self.topView.mas_centerX);
                        make.centerY.equalTo(self.backImgView.mas_centerY);
                }];
                
                [self.fullScreenButton removeFromSuperview];
                [self.topView addSubview:self.fullScreenButton];
                
                [self.fullScreenButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.right.equalTo(self.topView.mas_right).offset(-8);
                        make.centerY.equalTo(self.backImgView.mas_centerY);
                }];
        }
        
}
- (void)_LayoutBottomView
{
        [self.totoalTimeLabel removeFromSuperview];
        [self.bottomView addSubview:self.totoalTimeLabel];
        
        [self.playButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.bottomView.mas_centerY);
                make.left.equalTo(self.bottomView.mas_left).offset(6);
        }];
        [self.currentTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.playButton.mas_centerY);
                make.left.equalTo(self.playButton.mas_right).offset(11);
                make.width.mas_equalTo(self.isTimeHasHour ? MLSPlayerTimeLabelHasHour : MLSPlayerTimeLabelHasNotHour);
        }];
        [self.slider mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.currentTimeLabel.mas_right).offset(20);
                make.centerY.equalTo(self.playButton.mas_centerY);
        }];
        
        
        if (self.isFullScreen)
        {
                
                [self.totoalTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(self.slider.mas_right).offset(12);
                        make.centerY.equalTo(self.playButton.mas_centerY);
                        make.width.equalTo(self.currentTimeLabel.mas_width);
                }];
                
                [self.fullScreenButton removeFromSuperview];
                [self.bottomView addSubview:self.fullScreenButton];
                [self.fullScreenButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.width.mas_equalTo(24);
                        make.left.equalTo(self.totoalTimeLabel.mas_right).offset(10);
                        make.centerY.equalTo(self.playButton.mas_centerY);
                        make.right.equalTo(self.bottomView.mas_right).offset(-10);
                }];
                
                [self mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.right.equalTo(self.fullScreenButton.mas_right).offset(10);
                }];
        }
        else
        {
                [self.totoalTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(self.slider.mas_right).offset(12);
                        make.centerY.equalTo(self.playButton.mas_centerY);
                        make.right.equalTo(self.bottomView.mas_right).offset(-10);
                        make.width.equalTo(self.currentTimeLabel.mas_width);
                }];
        }
        
}

- (void)_LayoutTopAndBottomViewWithShowing:(BOOL)showing
{
        self.topView.hidden = NO;
        self.bottomView.hidden = NO;
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideControlView) object:nil];
        [self.layer removeAllAnimations];
        [self.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.mas_top).offset(showing?0:(-MLSPlayerTopViewHeight));
                make.left.right.equalTo(self);
                make.height.mas_equalTo(MLSPlayerTopViewHeight);
        }];
        [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.mas_bottom).offset(showing?0:(MLSPlayerBottomViewHeight));
                make.left.right.equalTo(self);
                make.height.mas_equalTo(MLSPlayerTopViewHeight);
        }];
}

- (void)setShowing:(BOOL)showing animation:(BOOL)animation
{
        BOOL showControlView = showing;
        /// 如果是错误, 并且要隐藏, 不隐藏
        if (self.isError && showControlView == NO)
        {
                [self _LayoutTopAndBottomViewWithShowing:YES];
                return;
                
        }
        if (self.isSliderBeingDragged)
        {
                [self _LayoutTopAndBottomViewWithShowing:YES];
                [self hideAnimation:YES delay:MLSPlayerControlHideDelay];
                return;
        }
        
        /// 动画过程中, 并且不是错误提示, 不响应别的事件
        if (self.isAnimationing)
        {
                return;
        }
        
        self.showing = showControlView;
        
        [self refreshMediaControl];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(playerControl:willShow:)])
        {
                [self.delegate playerControl:self willShow:showControlView];
        }
        if (animation)
        {
                self.animationing = YES;
                
                [UIView animateWithDuration:MLSPlayerControlHideAnimationDuration animations:^{
                        [self _LayoutTopAndBottomViewWithShowing:showControlView];
                        [self setNeedsLayout];
                        [self layoutIfNeeded];
                } completion:^(BOOL finished) {
                        self.animationing = NO;
                        self.topView.hidden = !self.isShowing;
                        self.bottomView.hidden = !self.isShowing;
                }];
        }
        else
        {
                [self _LayoutTopAndBottomViewWithShowing:showControlView];
        }
}
/// MARK: - MLSPlayerControlProtocol BEGIN
- (void)hideOrShowControl
{
        if (self.isShowing)
        {
                [self hideAnimation:YES];
        }
        else
        {
                [self showAnimation:YES];
                [self hideAnimation:YES delay:MLSPlayerControlHideDelay];
        }
}
- (void)showAnimation:(BOOL)animation
{
        [self setShowing:YES animation:animation];
}
- (void)hideAnimation:(BOOL)animation
{
        [self setShowing:NO animation:animation];
}
- (void)showControlView
{
        [self showAnimation:YES];
}
- (void)showAnimation:(BOOL)animation delay:(CGFloat)delay
{
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showControlView) object:nil];
        [self performSelector:@selector(showControlView) withObject:nil afterDelay:delay];
}
- (void)hideControlView
{
        [self hideAnimation:YES];
}
- (void)hideAnimation:(BOOL)animation delay:(CGFloat)delay
{
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideControlView) object:nil];
        [self performSelector:@selector(hideControlView) withObject:nil afterDelay:delay];
}
- (void)refreshMediaControl
{
        // duration
        NSTimeInterval duration = self.delegatePlayer.duration;
        NSInteger intDuration = duration + 0.5;
        if (intDuration > 0)
        {
                self.slider.maximumValue = duration;
        }
        else
        {
                self.slider.maximumValue = 1.0f;
        }
        self.totoalTimeLabel.text = [self getHourMinutesSecondsWithStamp:intDuration];
        
        
        // position
        NSTimeInterval position;
        if (self.isSliderBeingDragged)
        {
                position = self.slider.value;
        }
        else
        {
                position = self.delegatePlayer.currentPlaybackTime;
        }
        NSInteger intPosition = position + 0.5;
        if (intDuration > 0)
        {
                self.slider.value = position;
        }
        else
        {
                self.slider.value = 0.0f;
        }
        self.currentTimeLabel.text = [self getHourMinutesSecondsWithStamp:intPosition];
        
        if (self.delegatePlayer.isPlaying)
        {
                self.playModel.current = intPosition;
                self.playModel.duration = intDuration;
        }
        
        
        // status
        BOOL isPlaying = [self.delegatePlayer isPlaying];
        self.playButton.selected = isPlaying;
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshMediaControl) object:nil];
        if (self.isShowing)
        {
                [self performSelector:@selector(refreshMediaControl) withObject:nil afterDelay:0.5];
        }
}
- (void)beginSeek
{
        self.sliderBeingDragged = YES;
        if (self.delegate && [self.delegate respondsToSelector:@selector(playerControlWillSeek:)])
        {
                [self.delegate playerControlWillSeek:self];
        }
}
- (void)endSeek
{
        self.sliderBeingDragged = NO;
        [self _SeekTo:self.slider.value];
}
- (void)continueSeek
{
        self.sliderBeingDragged = YES;
        [self refreshMediaControl];
        if (self.delegate && [self.delegate respondsToSelector:@selector(playerControl:seekingValue:)])
        {
                [self.delegate playerControl:self seekingValue:self.slider.value];
        }
}
- (NSString *)getHourMinutesSecondsWithStamp:(NSInteger)seconds
{
        int hour = MAX((int)(seconds / 3600), 0);
        int minute = MAX((int)((seconds - hour * 3600) / 60), 0);
        int second = MAX((int)(seconds % 60), 0);
        
        if (hour > 0 || self.isTimeHasHour)
        {
                if (!self.isTimeHasHour)
                {
                        self.timeHasHour = YES;
                }
                return [NSString stringWithFormat:@"%02d:%02d:%02d",hour,minute,second];
        }
        return [NSString stringWithFormat:@"%02d:%02d",minute,second];
}
/// MARK: - MLSPlayerControlProtocol END
/// Target Method
- (void)back:(UIButton *)btn
{
        if (self.delegate && [self.delegate respondsToSelector:@selector(playerControlClickBack:)]) {
                [self.delegate playerControlClickBack:self];
        }
}
- (void)fullScreen:(UIButton *)btn
{
        if (self.delegate && [self.delegate respondsToSelector:@selector(playerControl:clickFullScreen:)])
        {
                [self.delegate playerControl:self clickFullScreen:!self.isFullScreen];
        }
}
- (void)playOrPause:(UIButton *)btn
{
        /*
         self.playButton.selected = isPlaying;
         
         [_playButton setImage:[UIImage player_ic_play] forState:(UIControlStateNormal)];
         [_playButton setImage:[UIImage palyer_ic_stop] forState:(UIControlStateSelected)];
         */
        if (btn.isSelected) // 等价于 player is playing
        {
                 [self.delegatePlayer pause];
        }
        else
        {
                [self.delegatePlayer play];
        }
        [self refreshMediaControl];
}

/// UISlider
- (void)_SeekTo:(CGFloat)second
{
        if (self.delegate && [self.delegate respondsToSelector:@selector(playerControl:seekEndValue:)])
        {
                [self.delegate playerControl:self seekEndValue:second];
        }
        
        if (self.delegatePlayer)
        {
                [self.delegatePlayer setCurrentPlaybackTime:second];
        }
}
- (void)progressSliderTouchBegan:(ASValueTrackingSlider *)sender
{
        [self beginSeek];
}

- (void)progressSliderValueChanged:(ASValueTrackingSlider *)sender
{
        [self continueSeek];
}

- (void)progressSliderTouchEnded:(ASValueTrackingSlider *)sender
{
        [self endSeek];
}
- (void)panRecognizer:(UIPanGestureRecognizer *)sender {}

- (void)tapSliderAction:(UITapGestureRecognizer *)tap
{
        if ([tap.view isKindOfClass:[UISlider class]])
        {
                UISlider *slider = (UISlider *)tap.view;
                CGPoint point = [tap locationInView:slider];
                CGFloat length = slider.frame.size.width;
                // 视频跳转的value
                CGFloat tapValue = point.x / length;
                CGFloat seekValue = tapValue * slider.maximumValue;
                [self _SeekTo:seekValue];
        }
}
/**
 slider滑块的bounds
 */
- (CGRect)thumbRect
{
        return [self.slider thumbRectForBounds:self.slider.bounds
                                          trackRect:[self.slider trackRectForBounds:self.slider.bounds]
                                              value:self.slider.value];
}
/// MARK: - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
        CGRect rect = [self thumbRect];
        CGPoint point = [touch locationInView:self.slider];
        if ([touch.view isKindOfClass:[UISlider class]]) { // 如果在滑块上点击就不响应pan手势
                if (point.x <= rect.origin.x + rect.size.width && point.x >= rect.origin.x) { return NO; }
        }
        return YES;
}

/// MARK: -Lazy method
/// Private Method
- (UIImageView *)createShadowImageView:(UIImage *)img
{
        UIImageView *shadowView = [[UIImageView alloc] init];
        shadowView.contentMode = UIViewContentModeScaleToFill;
        shadowView.image = img;
        return shadowView;
}
- (UIView *)createBarViewWithBGImage:(UIImage *)img insets:(UIEdgeInsets)insets
{
        UIView *barView = [[UIView alloc] init];
        barView.backgroundColor = [UIColor clearColor];
        UIImageView *bgView = [self createShadowImageView:img];
        [barView addSubview:bgView];
        [bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(barView).mas_offset(insets);
        }];
        return barView;
}
- (UIView *)topView
{
        if (_topView == nil)
        {
                _topView = [self createBarViewWithBGImage:[UIImage player_top_shadow] insets:(UIEdgeInsetsZero)];
        }
        return _topView;
}
- (UIView *)bottomView
{
        if (_bottomView == nil)
        {
                _bottomView = [self createBarViewWithBGImage:[UIImage player_bottom_shadow] insets:(UIEdgeInsetsZero)];
        }
        return _bottomView;
}
- (UIButton *)backButton
{
        if (_backButton == nil)
        {
                _backButton = [[UIButton alloc] init];
                [_backButton addTarget:self action:@selector(back:) forControlEvents:(UIControlEventTouchUpInside)];
        }
        return _backButton;
}
- (UIImageView *)backImgView
{
        if (_backImgView == nil) {
                _backImgView = [[UIImageView alloc] init];
                _backImgView.image = [UIImage nav_ic_back_white];
        }
        return _backImgView;
}
- (UILabel *)titleLabel
{
        if (_titleLabel == nil)
        {
                _titleLabel = [[UILabel alloc] init];
                _titleLabel.font = [UIFont systemFontOfSize:18];
                _titleLabel.textColor = [UIColor whiteColor];
        }
        return _titleLabel;
}
- (UIButton *)playButton
{
        if (_playButton == nil)
        {
                _playButton = [[UIButton alloc] init];
                [_playButton addTarget:self action:@selector(playOrPause:) forControlEvents:(UIControlEventTouchUpInside)];
                [_playButton setImage:[UIImage player_ic_play] forState:(UIControlStateNormal)];
                [_playButton setImage:[UIImage player_ic_stop] forState:(UIControlStateSelected)];
        }
        return _playButton;
}
- (UIButton *)fullScreenButton
{
        if (_fullScreenButton == nil)
        {
                _fullScreenButton = [[UIButton alloc] init];
                _fullScreenButton.adjustsImageWhenHighlighted = NO;
                [_fullScreenButton addTarget:self action:@selector(fullScreen:) forControlEvents:(UIControlEventTouchUpInside)];
                [_fullScreenButton setImage:[UIImage player_ic_max] forState:(UIControlStateNormal)];
        }
        return _fullScreenButton;
}
- (UILabel *)createTimeLabel
{
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:14];
        return label;
}
- (UILabel *)currentTimeLabel
{
        if (_currentTimeLabel == nil)
        {
                _currentTimeLabel = [self createTimeLabel];
        }
        return _currentTimeLabel;
}
- (UILabel *)totoalTimeLabel
{
        if (_totoalTimeLabel == nil)
        {
                _totoalTimeLabel = [self createTimeLabel];
        }
        return _totoalTimeLabel;
}
- (ASValueTrackingSlider *)slider
{
        if (_slider == nil)
        {
                _slider = [[ASValueTrackingSlider alloc] init];
                _slider.value = 0;
                _slider.maximumValue = 1;
                _slider.minimumValue = 0;
                [_slider setThumbImage:[UIImage player_ic_btn] forState:UIControlStateNormal];
                [_slider setMaximumTrackTintColor:[UIColor colorWithWhite:1 alpha:0.4]];
                [_slider setMinimumTrackTintColor:[UIColor whiteColor]];
                
                // slider开始滑动事件
                [_slider addTarget:self action:@selector(progressSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
                // slider滑动中事件
                [_slider addTarget:self action:@selector(progressSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
                // slider结束滑动事件
                [_slider addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];
                
                UITapGestureRecognizer *sliderTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSliderAction:)];
                [_slider addGestureRecognizer:sliderTap];
                
                UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panRecognizer:)];
                panRecognizer.delegate = self;
                [panRecognizer setMaximumNumberOfTouches:1];
                [panRecognizer setDelaysTouchesBegan:YES];
                [panRecognizer setDelaysTouchesEnded:YES];
                [panRecognizer setCancelsTouchesInView:YES];
                [_slider addGestureRecognizer:panRecognizer];
        }
        return _slider;
}
- (MLSPlayerGestureView *)gestureView
{
        if (_gestureView == nil) {
                _gestureView = [[MLSPlayerGestureView alloc] init];
                _gestureView.delegate = self;
        }
        return _gestureView;
}
- (MLSStateView *)stateView
{
        if (_stateView == nil) {
                _stateView = [[MLSStateView alloc] init];
        }
        return _stateView;
}



@end
