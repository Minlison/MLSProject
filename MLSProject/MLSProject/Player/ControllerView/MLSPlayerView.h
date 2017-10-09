//
//  MLSPlayerView.h
//  MLSProject
//
//  Created by MinLison on 2017/9/12.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseView.h"

@protocol MLSPlayerControlProtocol;

@interface MLSPlayerView : BaseView
/**
 设置 播放器 的视图
 */
@property(nonatomic, weak) UIView *playerView;

/**
 设置播放器的控制视图
 */
@property(nonatomic, weak) UIView <MLSPlayerControlProtocol> *playerControlView;

/**
 旋转内容视图

 @param orientation 方向
 */
- (void)rotateContentViewToOrientation:(UIInterfaceOrientation)orientation;
@end
