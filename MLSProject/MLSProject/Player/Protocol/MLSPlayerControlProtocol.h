//
//  MLSPlayerControlProtocol.h
//  MLSProject
//
//  Created by MinLison on 2017/9/12.
//  Copyright © 2017年 minlison. All rights reserved.
//

#ifndef MLSPlayerControlProtocol_h
#define MLSPlayerControlProtocol_h

#import <Foundation/Foundation.h>
#import "MLSPlayerControlViewDelegate.h"
#import <IJKMediaFrameworkWithSSL/IJKMediaPlayback.h>
#import "MLSPlayerModel.h"

@protocol IJKMediaPlayback;

@protocol MLSPlayerControlProtocol <NSObject>

/**
 播放的资源模型
 */
@property(nonatomic, strong) MLSPlayerModel *playModel;

/**
 播放器
 */
@property(nonatomic, weak) id <IJKMediaPlayback> delegatePlayer;

/**
 代理对象
 */
@property(nonatomic, weak) id <MLSPlayerControlViewDelegate> delegate;

/**
 当前播放状态
 */
@property(nonatomic, assign) IJKMPMoviePlaybackState playback;

/**
 当前加载状态
 */
@property(nonatomic, assign) IJKMPMovieLoadState loadState;

/**
 是否是全屏
 */
@property(nonatomic, assign, getter=isFullScreen) BOOL fullScreen;

/**
 当期使用的是蜂窝网络
 */
@property(nonatomic, assign) BOOL currentUseCellar;

/**
 没有网络连接
 */
@property(nonatomic, assign) BOOL noNetwork;

/**
 是否允许蜂窝网络
 */
@property(nonatomic, assign) BOOL allowCeller;

/**
 是否正在显示
 */
@property(nonatomic, assign, readonly, getter=isShowing) BOOL showing;

/**
 显示上下栏

 @param animation 是否有过度动画
 */
- (void)showAnimation:(BOOL)animation;

/**
 隐藏上下栏

 @param animation 是否有过度动画
 */
- (void)hideAnimation:(BOOL)animation;

/**
 延时隐藏上下栏

 @param animation 是否动画
 @param delay 延时
 */
- (void)hideAnimation:(BOOL)animation delay:(CGFloat)delay;

/**
 刷新
 */
- (void)refreshMediaControl;

/**
 开始快进
 */
- (void)beginSeek;

/**
 结束快进
 */
- (void)endSeek;

/**
 继续快进(拖动进度条, 或者手势)
 */
- (void)continueSeek;

/**
 设置错误提示
 
 @param error 错误信息
 @param block 点击确定回调, 如果为 nil, 则不显示确定按钮
 */
- (void)setError:(NSError *)error confirm:(void (^)())block;
@end

#endif /* MLSPlayerControlProtocol_h */
