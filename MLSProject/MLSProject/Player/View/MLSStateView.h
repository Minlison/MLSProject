//
//  MLSStateView.h
//  MLSProject
//
//  Created by MinLison on 2017/3/7.
//  Copyright © 2017年 com.minlison.orgz. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  播放器状态
 */
typedef NS_ENUM(int, MLSState)
{
        MLSStateUnKnown = -1,
        // 准备
        MLSStatePrepare = 0,
        // 就绪
        MLSStateReady,
        // 暂停
        MLSStatePaused,
        // 加载
        MLSStateLoading,
        // 正在播放
        MLSStatePlaying,
        // 播放完成
        MLSStateCompletion,
        // 非 Wifi 网络
        MLSStateChangeNetworkWAN,
        // 没有网络
        MLSStateNoNetwork,
        // 播放失败, 读取网络文件失败, 但是有网络
        MLSStateReadFileFailed,
        
        // 播放失败, 需要退出播放器
        MLSStateError,
};


@interface MLSStateView : UIView

/**
 视频名称
 */
@property(nonatomic, copy) NSString *videoName;

/**
 设置亮度
 */
@property (assign, nonatomic) CGFloat brightness;

/**
 设置音量
 */
@property (assign, nonatomic) CGFloat volume;

/**
 音量 view
 可以设置
 */
@property (strong, nonatomic) MPVolumeView *volumeView;

/**
 设置状态
 */
@property(nonatomic, assign) MLSState state;


/**
 播放器错误

 @param error 错误信息
 // 取下面两个 key 的值
 NSLocalizedDescriptionKey;		为错误标题
 NSLocalizedFailureReasonErrorKey	错误信息描述
 @param block 点击确定,回调
 */
- (void)setError:(NSError *)error confirm:(void (^)(void))block;

/**
 播放错误

 @param error 错误信息
 @param nowifi 是否是没有 wifi 了
 @param block 回调
 */
- (void)setError:(NSError *)error noWifi:(BOOL)nowifi confirm:(void (^)())block;


/**
 设置亮度

 @param brightness 亮度
 @param animation 是否动画
 */
- (void)setBrightness:(CGFloat)brightness animation:(BOOL)animation;

/**
 增加亮度

 @param brightness 增加多少亮度
 @param animation 是否动画
 */
- (void)addBrightness:(CGFloat)brightness animation:(BOOL)animation;

/**
 设置音量
 显示音量视图
 @param volume 音量
 @param animation 是否动画
 */
- (void)setVolume:(CGFloat)volume animation:(BOOL)animation;

/**
 增加音量
 显示音量视图
 @param volume 增加多少音量
 @param animation 是否动画
 */
- (void)addVolume:(CGFloat)volume animation:(BOOL)animation;

/**
 设置音量
 animation YES
 @param volume 设置音量
 @param show 是否显示音量视图
 */
- (void)setVolume:(CGFloat)volume showViews:(BOOL)show;

/**
 快进提示

 @param formatTime 格式化后的时间 10:09/20:00
 @param progress 进度 0 - 1
 @param forawrd 是快进还是快退
 */
- (void)setFormatTime:(NSString *)formatTime progress:(CGFloat)progress forward:(BOOL)forawrd;
@end
