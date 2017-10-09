//
//  UIViewController+TopTip.h
//  minlison
//
//  Created by qcm on 16/12/23.
//  Copyright © 2016年 minlison. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (TopTip)

/**
 显示内容的 label
 */
@property(nonatomic, strong) UILabel *tipLabel;

/**
 显示文字
 bkColor UIColorFromRGB(0x7F7F7F) textColor [UIColor whiteColor] delay 0

 @param text 文字
 @param animated 是否有动画效果
 */
- (void)showText:(NSString *)text animated:(BOOL)animated;

/**
 显示提示文字
 bkColor UIColorFromRGB(0x7F7F7F) textColor [UIColor whiteColor]

 @param text 文字
 @param animated 是否动画效果
 @param showTime 时间
 */
- (void)showText:(NSString *)text animated:(BOOL)animated showTime:(CGFloat)showTime;

/**
 显示提示文字

 @param text 文字
 @param color 文字颜色
 @param bkColor 背景颜色
 @param offset 偏移量
 @param animated 是否有动画效果
 @param showTime 显示时间
 */
- (void)showText:(NSString *)text textColor:(UIColor *)color backgroundColor:(UIColor *)bkColor offset:(CGPoint)offset animated:(BOOL)animated showTime:(CGFloat)showTime;


/**
 在导航栏/状态栏上显示提示

 @param text 文字
 */
- (void)showTextAtNavbar:(NSString *)text;
/**
 隐藏提示
 */
- (void)hideTip;
@end
