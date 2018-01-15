//
//  MLSDebugInstance.h
//  MLSLogger
//
//  Created by MinLison on 16/8/18.
//  Copyright © 2016年 MinLison. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLSDebugInstance : NSObject
/**
 *  default white
 */
@property (strong, nonatomic) UIColor *debugTextColor;
/**
 *  default [UIFont systemFontOfSize:15]
 */
@property (strong, nonatomic) UIFont *debugTextFont;
/**
 *  default black
 */
@property (strong, nonatomic) UIColor *debugBackgroundColor;
/**
 *  default 0.7
 */
@property (assign, nonatomic) CGFloat debugViewAlpha;
/**
 *  最大保留输出LOG数量（防止内存过大） 默认 100 条
 */
@property (assign, nonatomic) NSInteger maxLogCount;
/**
 *  最大占用内存数 默认2MB (单位 KB)
 */
@property (assign, nonatomic) CGFloat maxMemory;
/** 小球的半径 */
@property (assign, nonatomic) CGFloat radius;
/**
 *  是否是debug模式(是否在终端输出) default NO
 */
@property (assign, nonatomic, getter=isDebug) BOOL debug;

@property (assign, nonatomic, readonly, getter=isRunning) BOOL running;
+ (instancetype)shareInstance;
/**
 *  开启debugView
 */
- (void)start;
/**
 *  停止debugView
 */
- (void)stop;

@end
