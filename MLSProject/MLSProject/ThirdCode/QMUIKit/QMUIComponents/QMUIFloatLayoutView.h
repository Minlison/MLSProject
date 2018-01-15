//
//  QMUIFloatLayoutView.h
//  qmui
//
//  Created by MoLice on 2016/11/10.
//  Copyright © 2016年 QMUI Team. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 用于属性 maximumItemSize，是它的默认值。表示 item 的最大宽高会自动根据当前 floatLayoutView 的内容大小来调整，从而避免 item 内容过多时可能溢出 floatLayoutView。
extern const CGSize QMUIFloatLayoutViewAutomaticalMaximumItemSize;

/**
 *  做类似 CSS 里的 float:left 的布局，自行使用 addSubview: 将子 View 添加进来即可。
 *
 *  支持通过 `contentMode` 属性修改子 View 的对齐方式，目前仅支持 `UIViewContentModeLeft` 和 `UIViewContentModeRight`，默认为 `UIViewContentModeLeft`。
 */
@interface QMUIFloatLayoutView : UIView

/**
 *  QMUIFloatLayoutView 内部的间距，默认为 UIEdgeInsetsZero
 */
@property(nonatomic, assign) UIEdgeInsets padding;

/**
 *  item 的最小宽高，默认为 CGSizeZero，也即不限制。
 */
@property(nonatomic, assign) IBInspectable CGSize minimumItemSize;

/**
 * 是否把满行居中分散显示
 */
@property(nonatomic, assign) BOOL centerFillLineView;

/**
 * 分割线的内间距，相对于分割的 view
 */
@property(nonatomic, assign) UIEdgeInsets separatorPadding;

/**
 * 指定 item 之间的分隔线宽度，默认为 0
 */
@property(nonatomic, assign) IBInspectable CGFloat separatorWidth;

/**
 * 指定 item 之间的分隔线颜色，默认为 UIColorSeparator
 */
@property(nonatomic, strong) IBInspectable UIColor *separatorColor;

/**
 * item 之间的分隔线是否要用虚线显示，默认为 NO
 */
@property(nonatomic, assign) IBInspectable BOOL separatorDashed;


/**
 *  item 的最大宽高，默认为 QMUIFloatLayoutViewAutomaticalMaximumItemSize，也即不超过 floatLayoutView 自身最大内容宽高。
 */
@property(nonatomic, assign) IBInspectable CGSize maximumItemSize;

/**
 *  item 之间的间距，默认为 UIEdgeInsetsZero。
 *
 *  @warning 上、下、左、右四个边缘的 item 布局时不会考虑 itemMargins.left/bottom/left/right。
 */
@property(nonatomic, assign) UIEdgeInsets itemMargins;
@end

