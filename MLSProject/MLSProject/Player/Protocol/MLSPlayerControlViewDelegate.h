//
//  MLSPlayerControlViewDelegate.h
//  MLSProject
//
//  Created by MinLison on 2017/9/12.
//  Copyright © 2017年 minlison. All rights reserved.
//

#ifndef MLSPlayerControlViewDelegate_h
#define MLSPlayerControlViewDelegate_h

#import <UIKit/UIKit.h>
#import "MLSPlayerControlProtocol.h"

@protocol MLSPlayerControlProtocol;

@protocol MLSPlayerControlViewDelegate <NSObject>

/**
 点击全屏按钮
 
 @param control controView
 @param fullScreen 全屏还是小屏
 */
- (void)playerControl:(UIView <MLSPlayerControlProtocol> *)control clickFullScreen:(BOOL)fullScreen;

/**
 点击返回按钮
 
 @param control controView
 */
- (void)playerControlClickBack:(UIView <MLSPlayerControlProtocol> *)control;

/**
 点击播放按钮 (delegatePlayer 内部已经实现)
 
 @param control  controView
 @param play  YES播放/NO暂停
 */
- (void)playerControl:(UIView <MLSPlayerControlProtocol> *)control clickPlay:(BOOL)play;

/**
 进度条将要点击 (delegatePlayer 内部已经实现)

 @param control controView
 */
- (void)playerControlWillSeek:(UIView <MLSPlayerControlProtocol> *)control;

/**
 进度条正在改变值 (delegatePlayer 内部已经实现)

 @param control controView
 @param value 值 (0-duration)
 */
- (void)playerControl:(UIView <MLSPlayerControlProtocol> *)control seekingValue:(CGFloat)value;

/**
 进度条值改变完成 (delegatePlayer 内部已经实现)

 @param control controView
 @param value 值 (0-duration)
 */
- (void)playerControl:(UIView <MLSPlayerControlProtocol> *)control seekEndValue:(CGFloat)value;

/**
 是否要显示

 @param control  controlView
 @param show  是否显示 YES 显示 NO 隐藏
 */
- (void)playerControl:(UIView <MLSPlayerControlProtocol> *)control willShow:(BOOL)show;


/**
 是否显示 HUD 视图, 调试信息

 @param control  controlView
 @param show  是否显示 HUD 视图
 */
- (void)playerControl:(UIView <MLSPlayerControlProtocol> *)control showHUDView:(BOOL)show;

/**
 点击了允许蜂窝网络播放

 @param control controlView
 @param allowCellerNetwork 是否允许蜂窝网络播放
 */
- (void)playerControl:(UIView <MLSPlayerControlProtocol> *)control allowCellerNetwork:(BOOL)allowCellerNetwork;
@end

#endif /* MLSPlayerControlViewDelegate_h */
