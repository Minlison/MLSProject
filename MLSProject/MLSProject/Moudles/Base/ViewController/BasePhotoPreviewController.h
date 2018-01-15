//
//  BasePhotoPreviewController.h
//  MinLison
//
//  Created by MinLison on 2017/11/27.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseViewController.h"
/// MARK: - Copy from QMUIImagePreviewController
/**
 *  图片预览控件，主要功能由内部自带的 QMUIImagePreviewView 提供，由于以 viewController 的形式存在，所以适用于那种在单独界面里展示图片，或者需要从某张目标图片的位置以动画的形式放大进入预览界面的场景。
 *
 *  使用方式：
 *
 *  1. 使用 init 方法初始化
 *  2. 添加 imagePreviewView 的 delegate
 *  3. 分两种查看方式：
 *      1. 如果是左右 push 进入新界面查看图片，则直接按普通 UIViewController 的方式 push 即可；
 *      2. 如果需要从指定图片位置以动画的形式放大进入预览，则调用 startPreviewFromRectInScreen:，传入一个 rect 即可开始预览，这种模式下会创建一个独立的 UIWindow 用于显示 QMUIImagePreviewViewController，所以可以达到盖住当前界面所有元素（包括顶部状态栏）的效果。
 *
 *  @see QMUIImagePreviewView
 */
@interface BasePhotoPreviewController <__covariant ViewType : UIView <BaseControllerViewProtocol> * > : BaseViewController <ViewType> <QMUIImagePreviewViewDelegate>

@property(nonatomic, strong, readonly) QMUIImagePreviewView *imagePreviewView;
@property(nonatomic, strong) UIColor *backgroundColor UI_APPEARANCE_SELECTOR;
@property(nonatomic, assign, readonly) CGRect previewFromRect;
@property(nonatomic, strong, readonly) TTTAttributedLabel *contentLabel;
@property(nonatomic, strong, readonly) UIPageControl *pageControl;
@end

/**
 *  以 UIWindow 的形式来预览图片，优点是能盖住界面上所有元素（包括状态栏），缺点是无法进行 viewController 的界面切换（因为被 UIWindow 盖住了）
 */
@interface BasePhotoPreviewController (UIWindow)

/**
 *  从指定 rect 的位置以动画的形式进入预览
 *  @param rect 在当前屏幕坐标系里的 rect，注意传进来的 rect 要做坐标系转换，例如：[view.superview convertRect:view.frame toView:nil]
 *  @param cornerRadius 做打开动画时是否要从某个圆角渐变到 0
 */
- (void)startPreviewFromRectInScreen:(CGRect)rect cornerRadius:(CGFloat)cornerRadius;

/**
 *  从指定 rect 的位置以动画的形式进入预览，不考虑圆角
 *  @param rect 在当前屏幕坐标系里的 rect，注意传进来的 rect 要做坐标系转换，例如：[view.superview convertRect:view.frame toView:nil]
 */
- (void)startPreviewFromRectInScreen:(CGRect)rect;

/**
 *  将当前图片缩放到指定 rect 的位置，然后退出预览
 *  @param rect 在当前屏幕坐标系里的 rect，注意传进来的 rect 要做坐标系转换，例如：[view.superview convertRect:view.frame toView:nil]
 */
- (void)endPreviewToRectInScreen:(CGRect)rect;

/**
 *  以渐现的方式开始图片预览
 */
- (void)startPreviewFading;

/**
 *  使用渐隐的动画退出图片预览
 */
- (void)endPreviewFading;
@end

@interface BasePhotoPreviewController (UIAppearance)

+ (instancetype)appearance;
@end
