//
//  MLSPlayerViewController.m
//  MLSProject
//
//  Created by MinLison on 2017/9/12.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSPlayerViewController.h"
#import <IJKMediaFrameworkWithSSL/IJKMediaFrameworkWithSSL.h>
#import "MLSPlayerControlProtocol.h"
#import "MLSPlayerControlView.h"

#define MLSPlayerModelRetryMaxCount 3

#define MLSPlayerError(c,des,reason) [NSError errorWithDomain:@"MLSPlayerErrorDomain" code:c userInfo:@{NSLocalizedDescriptionKey : des, NSLocalizedFailureReasonErrorKey : reason}]
#define MLSPlayerDefaultError MLSPlayerError(0,@"播放错误\n请稍后重试",@"")
#define MLSPlayerNoWifiError MLSPlayerError(0,@"无网络连接\n请检查网络设置后重试",@"")

@interface MLSPlayerViewController () <MLSPlayerControlViewDelegate>
@property(nonatomic, strong) IJKFFMoviePlayerController *player;
@property(nonatomic, strong, readwrite) MLSPlayerViewModel <MLSPlayerModel *>* viewModel;
@property(nonatomic, strong) MLSPlayerControlView *currentControlView;
@property(nonatomic, assign, getter=isFulScreen) BOOL fullScreen;
@property(nonatomic, strong) NSTimer *playerTimer;
@property(nonatomic, strong) HLNetWorkReachability *networkReachability;
@property(nonatomic, assign) BOOL firstRotate;
@end

@implementation MLSPlayerViewController

+ (instancetype)playerViewControllerWithModel:(MLSPlayerModel *)model
{
        MLSPlayerViewModel *viewModel = [[MLSPlayerViewModel alloc] init];
        [viewModel add:model];
        return [self playerViewControllerWithViewModel:viewModel];
}

+ (instancetype)playerViewControllerWithViewModel:(MLSPlayerViewModel <MLSPlayerModel *>*)viewModel
{
        MLSPlayerViewController *vc = [[MLSPlayerViewController alloc] init];
        vc.viewModel = viewModel;
        return vc;
}
- (void)viewDidLoad
{
        [super viewDidLoad];
        [self _InitNetworkWatchDog];
        self.firstRotate = YES;
        
#ifdef DEBUG
        [IJKFFMoviePlayerController setLogReport:YES];
        [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_DEBUG];
#else
        [IJKFFMoviePlayerController setLogReport:NO];
        [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_INFO];
#endif
        
        [self _RetryCurrent];
}
- (void)viewDidAppear:(BOOL)animated
{
        [super viewDidAppear:animated];
        [self.player prepareToPlay];
        /// 适应屏幕
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
}

- (void)viewWillDisappear:(BOOL)animated
{
        [super viewWillDisappear:animated];
}

- (void)backButtonDidClick:(UIButton *)button
{
        [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
        [self _RotateTo:UIInterfaceOrientationPortrait animation:NO];
        [self _DestroyPlayer];
        [super backButtonDidClick:button];
}

- (void)_RetryCurrent
{
        MLSPlayerModel *currentModel = self.viewModel.current;
        @weakify(self);
        @weakify(currentModel);
        NSError *error = [self.networkReachability isReachabile] ? MLSPlayerDefaultError : MLSPlayerNoWifiError;
        if (currentModel.retryCount < MLSPlayerModelRetryMaxCount)
        {
                currentModel.retryCount += 1;
                if (currentModel.regetUrlCallBack)
                {
                        currentModel.regetUrlCallBack(currentModel, ^(NSString * _Nullable url) {
                                @strongify(self);
                                @strongify(currentModel);
                                
                                if (!url)
                                {
                                        [self _SetControlViewErrorWithClickBack:error];
                                        return;
                                }
                                currentModel.videoUrl = url;
                                [self _RePlayCurrent];
                        });
                }
                else
                {
                        [self _SetControlViewErrorWithClickBack:error];
                }
        }
        else
        {
                [self _SetControlViewErrorWithClickBack:error];
        }
}
- (void)_SetControlViewErrorWithClickBack:(NSError *)error
{
        [self.currentControlView setError:error confirm:nil];
}
- (void)_RePlayCurrent
{
        if ( ![self.viewModel current] ||  ![self _InitPlayer] )
        {
                [self _CallPlayBackEndWithError:MLSPlayerDefaultError];
        }
        else
        {
                [self.player prepareToPlay];
        }
}
- (void)_PlayNext
{
        if ( ![self.viewModel next] ||  ![self _InitPlayer])
        {
                [self _CallPlayBackEndWithError:MLSPlayerDefaultError];
        }
        else
        {
                [self.player prepareToPlay];
        }
}
- (BOOL)_InitPlayer
{
        [self _JudgeNetworkStatus];
        
        [self _DestroyPlayer];
        
        [self _SetUPPlayerControlView];
        
        if ([self.networkReachability isWLAN] && !self.allowCellerNetwork)
        {
                return NO;
        }
        
        if ( [self _CreatePlayer] )
        {
                [self _InstallMovieNotificationObservers];
                [self.currentControlView setDelegatePlayer:self.player];
                [self.currentControlView refreshMediaControl];
                self.currentControlView.playModel = self.viewModel.current;
                return YES;
        }
        return NO;
}
- (void)_InitNetworkWatchDog
{
        self.networkReachability = [HLNetWorkReachability reachabilityForInternetConnection];
        @weakify(self);
        [self.networkReachability setReachabilityStatusChangeBlock:^(HLNetWorkStatus status) {
                @strongify(self);
                [self _JudgeNetworkStatus];
        }];
        [self.networkReachability startNotifier];
}
- (void)_JudgeNetworkStatus
{
        if ( ![self.networkReachability isReachabile] )
        {
                [self.player pause];
        }
        
        if ([self.networkReachability isWifi])
        {
                [self.player play];
        }
        
        if ([self.networkReachability isWLAN])
        {
                if (self.allowCellerNetwork)
                {
                        [self.player play];
                }
                else
                {
                        [self.player stop];
                }
        }
        self.currentControlView.playModel = self.viewModel.current;
        self.currentControlView.allowCeller = self.allowCellerNetwork;
        self.currentControlView.noNetwork = ![self.networkReachability isReachabile];
        self.currentControlView.currentUseCellar = [self.networkReachability isWLAN];
}

- (BOOL)_CreatePlayer
{
        
        NSString *url = self.viewModel.current.videoUrl;
        
        if (!url)
        {
                [self _RetryCurrent];
                return NO;
        }
        
        if (self.player != nil)
        {
                [self.player shutdownWithWait];
        }
        IJKFFOptions *options = [IJKFFOptions optionsByDefault];
        [options setPlayerOptionIntValue:1 forKey:@"videotoolbox"];
        self.player = [[IJKFFMoviePlayerController alloc] initWithContentURLString:url withOptions:options];
        [self.player setPauseInBackground:YES];
        self.player.shouldAutoplay = YES;
        self.player.scalingMode = IJKMPMovieScalingModeAspectFit;
        
        [self.controllerView setPlayerView:self.player.view];
        
        return self.player != nil;
}

- (void)_SetUPPlayerControlView
{
        [self.currentControlView setDelegate:self];
        if (self.player)
        {
                [self.currentControlView setDelegatePlayer:self.player];
        }
        [self.controllerView setPlayerControlView:self.currentControlView];
        self.currentControlView.loadState = IJKMPMovieLoadStateUnknown;
}
- (void)_DestroyPlayer
{
        if (self.player)
        {
                [self _RemoveMovieNotificationObservers];
                [self.player stop];
                [self.player.view removeFromSuperview];
                [self.player shutdownWithWait];

        }
        self.player = nil;
}

- (void)_CallPlayBackEndWithError:(NSError *)error
{
        /// 播放完成回调
        MLSPlayerModel *model = self.viewModel.current;
        model.error = error;
        if (model.playEndCallBack)
        {
                model.playEndCallBack(model);
        }
}

/// MARK: - Notifaction Methods
/// Device
- (void)deviceOrientationChange:(NSNotification *)notifaction
{
        // 设备旋转
        UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;

        /// 用户手动点击全屏, 只旋转横屏状态
        if (self.isFulScreen)
        {
                if (deviceOrientation == UIDeviceOrientationLandscapeLeft || deviceOrientation == UIDeviceOrientationLandscapeRight)
                {
                        [self _RotateTo:(UIInterfaceOrientation)deviceOrientation];
                }
        }
        else
        {
                if (deviceOrientation == UIDeviceOrientationPortrait || deviceOrientation == UIDeviceOrientationLandscapeLeft || deviceOrientation == UIDeviceOrientationLandscapeRight)
                {
                        [self _RotateTo:(UIInterfaceOrientation)deviceOrientation];
                }

        }
}
- (void)_RotateTo:(UIInterfaceOrientation)orientation animation:(BOOL)animation
{
         [[UIApplication sharedApplication] setStatusBarOrientation:orientation animated:animation];
}
- (void)_RotateTo:(UIInterfaceOrientation)orientation
{
        if (self.firstRotate && UIInterfaceOrientationIsLandscape(orientation))
        {
                [self _RotateTo:orientation animation:NO];
                
        }
        else
        {
                [self _RotateTo:orientation animation:YES];
        }
        self.firstRotate = NO;
        
}
- (void)statusBarOrientationChange:(NSNotification *)notifaction
{
        // 状态栏方向改变
        [self.controllerView rotateContentViewToOrientation:[UIApplication sharedApplication].statusBarOrientation];
}

/// Player
- (void)playerLoadStateDidChange:(NSNotification *)notification
{
        self.currentControlView.loadState = self.player.loadState;
        
        //    MPMovieLoadStateUnknown        = 0,
        //    MPMovieLoadStatePlayable       = 1 << 0,
        //    MPMovieLoadStatePlaythroughOK  = 1 << 1, // Playback will be automatically started in this state when shouldAutoplay is YES
        //    MPMovieLoadStateStalled        = 1 << 2, // Playback will be automatically paused in this state, if started
        
        IJKMPMovieLoadState loadState = _player.loadState;
        
        if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0)
        {
                NSLogDebug(@"loadStateDidChange: IJKMPMovieLoadStatePlaythroughOK: %d\n", (int)loadState);
        }
        else if ((loadState & IJKMPMovieLoadStateStalled) != 0)
        {
                NSLogDebug(@"loadStateDidChange: IJKMPMovieLoadStateStalled: %d\n", (int)loadState);
        }
        else
        {
                NSLogDebug(@"loadStateDidChange: ???: %d\n", (int)loadState);
        }
}

- (void)playerPlayBackDidFinish:(NSNotification*)notification
{
        //    MPMovieFinishReasonPlaybackEnded,
        //    MPMovieFinishReasonPlaybackError,
        //    MPMovieFinishReasonUserExited
        IJKMPMovieFinishReason reason = [[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
        NSError *error = nil;
        
        if (reason == IJKMPMovieFinishReasonPlaybackError)
        {
                error = MLSPlayerDefaultError;
                if ([self.networkReachability currentReachabilityStatus] == HLNetWorkStatusNotReachable)
                {
                        error = MLSPlayerNoWifiError;
                }
        }
        
        [self _CallPlayBackEndWithError:error];
        
        if ( ![self.networkReachability isReachabile] )
        {
                return;
        }
        
        if ([self.networkReachability isWLAN] && !self.allowCellerNetwork)
        {
                return;
        }
        
        switch (reason)
        {
                case IJKMPMovieFinishReasonPlaybackEnded:
                {
                        NSLogDebug(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackEnded: %d\n", (int)reason);
                       
                        [self _PlayNext];
                }
                        break;
                        
                case IJKMPMovieFinishReasonUserExited:
                {
                        NSLogDebug(@"playbackStateDidChange: IJKMPMovieFinishReasonUserExited: %d\n", (int)reason);
                }
                        break;
                        
                case IJKMPMovieFinishReasonPlaybackError:
                {
                        NSLogDebug(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackError: %d\n", (int)reason);
                        [self _RetryCurrent];
                }
                        
                        break;
                        
                default:
                {
                        NSLogDebug(@"playbackPlayBackDidFinish: ???: %d\n", (int)reason);
                        [self backButtonDidClick:nil];
                }
                        break;
        }
}

- (void)playerIsPreparedToPlayDidChange:(NSNotification*)notification
{
        NSLogDebug(@"mediaIsPreparedToPlayDidChange\n");
        if (self.viewModel.current.current > 0)
        {
                self.player.currentPlaybackTime = self.viewModel.current.current;
        }
}

- (void)playerPlayBackStateDidChange:(NSNotification*)notification
{
        self.currentControlView.playback = self.player.playbackState;
        
        switch (_player.playbackState)
        {
                case IJKMPMoviePlaybackStateStopped:
                {
                        NSLogDebug(@"IJKMPMoviePlayBackStateDidChange %d: stoped", (int)_player.playbackState);
                }
                        break;
                case IJKMPMoviePlaybackStatePlaying:
                {
                        NSLogDebug(@"IJKMPMoviePlayBackStateDidChange %d: playing", (int)_player.playbackState);
                }
                        break;
                case IJKMPMoviePlaybackStatePaused:
                {
                        NSLogDebug(@"IJKMPMoviePlayBackStateDidChange %d: paused", (int)_player.playbackState);
                }
                        break;
                case IJKMPMoviePlaybackStateInterrupted:
                {
                        NSLogDebug(@"IJKMPMoviePlayBackStateDidChange %d: interrupted", (int)_player.playbackState);
                }
                        break;
                case IJKMPMoviePlaybackStateSeekingForward:
                case IJKMPMoviePlaybackStateSeekingBackward:
                {
                        NSLogDebug(@"IJKMPMoviePlayBackStateDidChange %d: seeking", (int)_player.playbackState);
                }
                        break;
                default:
                {
                        NSLogDebug(@"IJKMPMoviePlayBackStateDidChange %d: unknown", (int)_player.playbackState);
                }
                        break;
        }
}


/// MARK:Install Movie Notifications
/* Register observers for the various movie object notifications. */
- (void)_InstallMovieNotificationObservers
{
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerLoadStateDidChange:)
                                                     name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                                   object:self.player];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerPlayBackDidFinish:)
                                                     name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                                   object:self.player];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerIsPreparedToPlayDidChange:)
                                                     name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                                   object:self.player];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerPlayBackStateDidChange:)
                                                     name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                                   object:self.player];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(deviceOrientationChange:)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(statusBarOrientationChange:)
                                                     name:UIApplicationDidChangeStatusBarOrientationNotification
                                                   object:nil];
}

/// MARK: Remove Movie Notification Handlers
- (void)_RemoveMovieNotificationObservers
{
        [[NSNotificationCenter defaultCenter] removeObserver:self name:IJKMPMoviePlayerLoadStateDidChangeNotification object:self.player];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:IJKMPMoviePlayerPlaybackDidFinishNotification object:self.player];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification object:self.player];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:IJKMPMoviePlayerPlaybackStateDidChangeNotification object:self.player];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

/// MARK: - Player Control View Delegate
- (void)playerControl:(UIView <MLSPlayerControlProtocol> *)control clickFullScreen:(BOOL)fullScreen
{
        self.fullScreen = fullScreen;
        if (fullScreen)
        {
                [self _RotateTo:(UIInterfaceOrientationLandscapeRight)];
        }
        else
        {
                [self _RotateTo:(UIInterfaceOrientationPortrait)];
        }
}
- (void)playerControl:(UIView<MLSPlayerControlProtocol> *)control showHUDView:(BOOL)show
{
#ifdef DEBUG
        [self.player setShouldShowHudView:show];
#endif
}
- (void)playerControlClickBack:(UIView <MLSPlayerControlProtocol> *)control
{
        [self backButtonDidClick:nil];
}

- (void)playerControl:(UIView <MLSPlayerControlProtocol> *)control clickPlay:(BOOL)play
{
        // do nothing
}
- (void)playerControl:(UIView<MLSPlayerControlProtocol> *)control seekEndValue:(CGFloat)value
{
        // do nothing
}


- (void)playerControl:(UIView<MLSPlayerControlProtocol> *)control seekingValue:(CGFloat)value
{
        // do nothing
}


- (void)playerControlWillSeek:(UIView<MLSPlayerControlProtocol> *)control
{
        // do nothing
}
- (void)playerControl:(UIView<MLSPlayerControlProtocol> *)control willShow:(BOOL)show
{
        [self setNeedsStatusBarAppearanceUpdate];
}
- (void)playerControl:(UIView<MLSPlayerControlProtocol> *)control allowCellerNetwork:(BOOL)allowCellerNetwork
{
        self.allowCellerNetwork = allowCellerNetwork;
        [self _RetryCurrent];
}



/// Controller UI
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
        return UIInterfaceOrientationMaskPortrait;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
        return UIInterfaceOrientationPortrait;
}
- (BOOL)preferredNavigationBarHidden {
        return YES;
}

- (BOOL)shouldSetStatusBarStyleLight {
        return YES;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
        return NO;
}
- (BOOL)shouldAutorotate
{
        return NO;
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
        return UIStatusBarStyleLightContent;
}
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
        return UIStatusBarAnimationFade;
}
- (BOOL)prefersStatusBarHidden
{
        return !self.currentControlView.isShowing;
}
/// MARK: - Control
- (MLSPlayerControlView *)currentControlView
{
        if (_currentControlView == nil) {
                _currentControlView = [[MLSPlayerControlView alloc] initWithFrame:CGRectMake(0, 0, __MAIN_SCREEN_WIDTH__, __MAIN_SCREEN_HEIGHT__)];
                _currentControlView.allowCeller = self.allowCellerNetwork;
        }
        return _currentControlView;
}
/// MARK: - Router
+ (UIViewController<JLRRouteDefinitionTargetController> *)targetControllerWithParams:(NSDictionary *)parameters
{
        NSString *videoUrl = [parameters objectForKey:kMLSPlayerViewControllerParamKey_URL];
        if (videoUrl == nil) {
                return nil;
        }
        NSString *videoName = [parameters objectForKey:kMLSPlayerViewControllerParamKey_VIDEO_NAME];
        if (!videoName) {
                videoName = videoUrl.stringByDeletingPathExtension.lastPathComponent;
        }
        MLSPlayerModel *model = [[MLSPlayerModel alloc] init];
        model.videoUrl = videoUrl;
        model.name = videoName;
        
        return [MLSPlayerViewController playerViewControllerWithModel:model];
}

@end
