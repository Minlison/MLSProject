//
//  MLSStateView.m
//  MLSProject
//
//  Created by MinLison on 2017/3/7.
//  Copyright © 2017年 com.minlison.orgz. All rights reserved.
//

#import "MLSStateView.h"
#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "MLSPlayerErrorView.h"
#import <AudioToolbox/AudioToolbox.h>
#import "MLSWaitingView.h"
#import "MLSFastView.h"

#define HIDE_DELAY_SECONDS 1.0
#define __ANIMATAION_DURATION__ 0.5

#define SHOW_VIEWS_BOUNDS(views,b,block) \
[self _HideSubviews];\
[views enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {\
if (block) {\
block(obj);\
}\
if (!CGRectEqualToRect(CGRectZero, b))\
{\
[obj setBounds:b];\
}\
else\
{\
[obj sizeToFit];\
}\
}];\
views.firstObject.center = [self _LeftViewCenter];\
views.lastObject.center = [self _RightViewCenter];\
views.firstObject.hidden = NO;\
views.lastObject.hidden = NO;\
[self _Show];



#define SHOW_VIEWS(views,block) SHOW_VIEWS_BOUNDS(views,CGRectZero,block)




@interface MLSStateView()
{
        CGFloat angle;
}
@property (strong, nonatomic) CADisplayLink *displayLink;
@property (strong, nonatomic) NSMutableArray <MLSWaitingView *>*waitingViews;
@property (strong, nonatomic) NSMutableArray <UIButton *>*pausedViews;
@property (strong, nonatomic) NSMutableArray <__kindof UIView *>*loadingViews;
@property (strong, nonatomic) MLSPlayerErrorView *errorView;
@property (strong, nonatomic) NSMutableArray <UIImageView *>*birghtnessAndVolumeViews;
@property (weak, nonatomic) UISlider *volumeSlider;
@property(nonatomic, assign) BOOL showVolumeViews;
@property(nonatomic, assign, getter=isLoading) BOOL loading;
@property(nonatomic, assign, getter=isHide) BOOL hide;
@property (strong, nonatomic) NSMutableArray <MLSFastView *> *fastViews;
@end

@implementation MLSStateView
- (void)setState:(MLSState)state
{
        if (_state != state)
        {
                _state = state;
                [self _ReLayout];
        }
}

- (void)_ReLayout
{
	[self _HideSubviews];
	[self setNeedsLayout];
	[self setNeedsDisplay];
}
- (instancetype)init
{
	if (self = [super init])
	{
                self.showVolumeViews = YES;
                self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(_RotateLoading)];
                [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
                [self.displayLink setPaused:YES];
	}
	return self;
}

- (void)_AddSubviewsFromArray:(__kindof NSArray <__kindof UIView *>*)arr
{
	[arr enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		if (![self.subviews containsObject:obj])
		{
			[self addSubview:obj];
		}
	}];
}
- (void)_InitViews
{
	self.alpha = 0.0;
	
	[self _AddSubviewsFromArray:self.loadingViews];
	
	[self _AddSubviewsFromArray:self.birghtnessAndVolumeViews];
        
        [self _AddSubviewsFromArray:self.fastViews];
        
	[self addSubview:self.errorView];
	
	[self _SetupVolumeView];
	
}
// MARK: - 计算中心点
- (CGPoint)_LeftViewCenter
{
	CGFloat centerX = self.bounds.size.width * 0.5;
	CGFloat centerY = self.bounds.size.height * 0.5;
	
	return CGPointMake(centerX, centerY);
}
- (CGPoint)_RightViewCenter
{
	// 默认原片, 显示到中间
	CGFloat centerX = self.bounds.size.width * 0.5;
	CGFloat centerY = self.bounds.size.height * 0.5;
	
	return CGPointMake(centerX, centerY);
}


- (void)layoutSubviews
{
        [super layoutSubviews];
        
        self.userInteractionEnabled = NO;
        if (self.subviews.count < 1)
        {
                [self _InitViews];
        }
        self.backgroundColor = [UIColor clearColor];
        if (self.state == MLSStatePrepare)
        {
                [self _LayoutLoading];
        }
        else if (self.state == MLSStateReady || self.state == MLSStatePlaying)
        {
                [self _Hide];
        }
        else if (self.state == MLSStatePaused)
        {
//                [self _LayoutPaused];
        }
        else if (self.state == MLSStateLoading)
        {
                [self _LayoutLoading];
        }
        else if (self.state == MLSStateCompletion)
        {
                [self _Hide];
        }
        else if (self.state == MLSStateError)
        {
                [self _LayoutError];
                self.userInteractionEnabled = YES;
        }
}
- (void)pausedViewDidClick
{
	
}
// MARK: - 准备
- (void)_LayoutWaiting
{
        SHOW_VIEWS_BOUNDS(self.waitingViews, CGRectMake(0, 0, self.bounds.size.width * 0.25, self.bounds.size.height), (^(MLSWaitingView *obj){
                
                obj.video_name = self.videoName;
        }));
        [self _WaitingViewRotate];
        self.backgroundColor = [UIColor blackColor];
}

- (void)_WaitingViewRotate
{
        [self.waitingViews enumerateObjectsUsingBlock:^(MLSWaitingView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj rotate];
        }];
}

- (MLSWaitingView *)_CreateWaitingView
{
        MLSWaitingView *view = [MLSWaitingView waitingView];
        return view;
}

- (NSMutableArray <MLSWaitingView *>*)waitingViews
{
        if (_waitingViews == nil)
        {
                _waitingViews = [[NSMutableArray alloc] init];
                MLSWaitingView *left = [self _CreateWaitingView];
                left.center = [self _LeftViewCenter];
                
                MLSWaitingView *right = [self _CreateWaitingView];
                right.center = [self _RightViewCenter];
                [_waitingViews addObject:left];
                [_waitingViews addObject:right];
        }
        return _waitingViews;
}

// MARK: - 加载
- (void)_RotateLoading
{
            if (self.isHidden)
            {
                return;
            }
            angle = angle + 0.21; //angle角度 double angle;
            //大于 M_PI*2(360度) 角度再次从0开始
            if (angle > 6.28)
            {
                angle = 0;
            }
            CGAffineTransform transform= CGAffineTransformMakeRotation(angle);
        [self.loadingViews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.transform = transform;
        }];
}
- (void)_LayoutLoading
{
        [self.displayLink setPaused:NO];
	SHOW_VIEWS(self.loadingViews,(^(UIActivityIndicatorView *obj){
//                [obj startAnimating];
	}));
}
- (NSMutableArray<UIView *> *)loadingViews
{
	if (_loadingViews == nil) {
		_loadingViews = [[NSMutableArray alloc] init];
		
		UIView *left = [self _CreateLoadingView];
		left.center = [self _LeftViewCenter];
		
		UIView *right = [self _CreateLoadingView];
		right.center = [self _RightViewCenter];
		
		[_loadingViews addObject:left];
		[_loadingViews addObject:right];
	}
	return _loadingViews;
}
- (UIView *)_CreateLoadingView
{
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage loading_pic]];
        return imgView;
//        UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhite)];
//        activity.hidesWhenStopped = YES;
//        return activity;
}
// MARK: - 亮度
#define KIMAGE_MAX_NUM      (16)
- (void)setBrightness:(CGFloat)brightness
{
	[[UIScreen mainScreen] setBrightness:brightness];
}
- (CGFloat)brightness
{
	return [UIScreen mainScreen].brightness;
}
- (void)setBrightness:(CGFloat)brightness animation:(BOOL)animation
{
	self.brightness = brightness;
	CGRect rect = CGRectZero;
	
	SHOW_VIEWS_BOUNDS(self.birghtnessAndVolumeViews,rect,(^(UIImageView *obj){
		int brightness_index = (int)ceil(brightness * (KIMAGE_MAX_NUM));
		brightness_index = MAX(MIN(brightness_index, KIMAGE_MAX_NUM), 0);
		NSString *imageName = [NSString stringWithFormat:@"player_pic_light%d",brightness_index];
		obj.image = [UIImage imageNamed:imageName];
	}));
	[self _HideDelay:HIDE_DELAY_SECONDS];
}
- (void)addBrightness:(CGFloat)brightness animation:(BOOL)animation
{
	[self setBrightness:(self.brightness + brightness) animation:YES];
}

// MARK: - 音量
- (void)setVolumeView:(MPVolumeView *)volumeView
{
	if (_volumeView != volumeView) {
		_volumeView = volumeView;
		[self _AddHardKeyVolumeListener];
		for (UIView *view in [self.volumeView subviews])
		{
			if ([view.class.description isEqualToString:[NSString stringWithFormat:@"%@%@",@"MPVolume",@"Slider"]])
			{
				self.volumeSlider = (UISlider *)view;
				break;
			}
		}
	}
}
- (void)_SetupVolumeView
{
	if (!self.volumeView) {
		self.volumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(-1000, -1000, 10, 10)];
                [[UIApplication sharedApplication].keyWindow addSubview:self.volumeView];
	}
}

- (CGFloat)volume
{
	return self.volumeSlider.value;
}
- (void)setVolume:(CGFloat)newVolume
{
	CGFloat volume = newVolume;
	if (volume >= 0.9375)
	{
		volume = 0.875;
	}
	else if (volume <= 0.0625)
	{
		volume = 0.125;
	}
	
	[self.volumeSlider setValue:volume animated:NO];
	[self.volumeSlider sendActionsForControlEvents:(UIControlEventTouchUpInside)];
}
- (BOOL)_AddHardKeyVolumeListener
{
	@try {
		[[AVAudioSession sharedInstance] addObserver:self forKeyPath:@"outputVolume" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
	} @catch (NSException *exception) {
		
	} @finally {
		
	}
	return YES;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
	if ([keyPath isEqualToString:@"outputVolume"])
	{
                if (self.showVolumeViews)
                {
                        [self _ShowVolumeViews];
                }
                self.showVolumeViews = YES;
	}
}
- (void)setVolume:(CGFloat)volume animation:(BOOL)animation
{
        self.showVolumeViews = YES;
	self.volume = volume;
        [self showVolumeViews];
}
- (void)_ShowVolumeViews
{
        CGRect rect = CGRectZero;
        SHOW_VIEWS_BOUNDS(self.birghtnessAndVolumeViews,rect,(^(UIImageView *obj){
                /// 最大音量为0.875 最小音量为 0.125
                /// 前后各查两格UI音量, 共计误差4格音量
                /// 每格音量大小是 0.0625, 0-1 共16格
                /// 4格误差均分到 剩余的12格里面 (4 / 12) = 0.3333 约等于 0.3334
                
                /// (self.volume - 0.125) 向左偏移到 0 初始坐标
                /// ((self.volume - 0.125) / 0.0625) 计算出实际在16格 UI 中应该占有的音量格数
                /// ((1  + 0.3334) * ((self.volume - 0.125) / 0.0625))  分配到14格 UI 中, 应该占有的格子数
                /// floor 向下取整. 因为0.3334 误差加了 0.0001
                int volume_index = (int)floor((1  + 0.3334) * ((self.volume - 0.125) / 0.0625));
                volume_index = MAX(MIN(volume_index, KIMAGE_MAX_NUM), 0);
                NSString *imageName = [NSString stringWithFormat:@"player_pic_vol%d",volume_index];
                obj.image = [UIImage imageNamed:imageName];
        }));
        [self _HideDelay:HIDE_DELAY_SECONDS];
}
- (void)addVolume:(CGFloat)volume animation:(BOOL)animation
{
	[self setVolume:(self.volume + volume) animation:YES];
}
- (void)setVolume:(CGFloat)volume showViews:(BOOL)show
{
        self.volume = volume;
        self.showVolumeViews = show;
}
- (NSMutableArray<UIImageView *> *)birghtnessAndVolumeViews
{
	if (_birghtnessAndVolumeViews == nil)
	{
		_birghtnessAndVolumeViews = [[NSMutableArray alloc] init];
		
		
		UIImageView *left = [self _CreateBirghtnessAndVolumeViews];
		left.center = [self _LeftViewCenter];
		
		UIImageView *right = [self _CreateBirghtnessAndVolumeViews];
		right.center = [self _RightViewCenter];
		
		
		[_birghtnessAndVolumeViews addObject:left];
		[_birghtnessAndVolumeViews addObject:right];
	}
	return _birghtnessAndVolumeViews;
}
- (UIImageView *)_CreateBirghtnessAndVolumeViews
{
	UIImageView *imageView = [[UIImageView alloc] init];
	return imageView;
}

// MARK: - 出错
- (void)setError:(NSError *)error noWifi:(BOOL)nowifi confirm:(void (^)())block
{
	self.state = MLSStateError;
	[self.errorView setError:error noWifi:nowifi confirm:block];
}
- (void)setError:(NSError *)error confirm:(void (^)())block
{
	self.state = MLSStateError;
	[self.errorView setError:error confirm:block];
}
- (void)_LayoutError
{
	self.backgroundColor = [UIColor blackColor];
	[self _HideSubviews];
	self.errorView.frame = self.bounds;
	self.errorView.hidden = NO;
	[self _Show];
}
- (MLSPlayerErrorView *)errorView
{
	if (_errorView == nil) {
		_errorView = [self _CreateErrorView];
	}
	return _errorView;
}
- (MLSPlayerErrorView *)_CreateErrorView
{
	MLSPlayerErrorView *errorView = [MLSPlayerErrorView errorView];
	errorView.frame = self.bounds;
	return errorView;
}


// MARK:- View private method
- (void)_HideSubviews
{
	[self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		obj.hidden = YES;
	}];
}
- (void)_Hide
{
        [self.displayLink setPaused:YES];
	[UIView animateWithDuration:__ANIMATAION_DURATION__ animations:^{
		self.alpha = 0.0;
	}];
}
- (void)_HideDelay:(CGFloat)delay
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(_Hide) object:nil];
	[self performSelector:@selector(_Hide) withObject:nil afterDelay:delay];
}
- (void)_Show
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(_Hide) object:nil];
	[self.layer removeAllAnimations];
	[UIView animateWithDuration:__ANIMATAION_DURATION__ animations:^{
		self.alpha = 1.0;
	}];
}
- (void)dealloc
{
	if (self.displayLink != nil)
	{
		[self.displayLink invalidate];
		self.displayLink = nil;
	}
	@try {
		[[AVAudioSession sharedInstance] removeObserver:self forKeyPath:@"outputVolume"];
	} @catch (NSException *exception) {
	} @finally {
	}
}
/// MAKR: - 快进提示
- (void)setFormatTime:(NSString *)formatTime progress:(CGFloat)progress forward:(BOOL)forawrd
{
        SHOW_VIEWS(self.fastViews,(^(MLSFastView *obj){
                //                obj.small = small;
                [obj setFormatTime:formatTime progress:progress forward:forawrd];
        }));
        [self _Hide];
}

- (NSMutableArray<MLSFastView *> *)fastViews
{
        if (_fastViews == nil) {
                _fastViews = [[NSMutableArray alloc] init];
                [_fastViews addObject:[[MLSFastView alloc] init]];
                [_fastViews addObject:[[MLSFastView alloc] init]];
        }
        return _fastViews;
}
@end
