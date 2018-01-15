//
//  QMUIFloatLayoutView.m
//  qmui
//
//  Created by MoLice on 2016/11/10.
//  Copyright © 2016年 QMUI Team. All rights reserved.
//

#import "QMUIFloatLayoutView.h"
#import "QMUICore.h"
#import "CALayer+QMUI.h"

#define ValueSwitchAlignLeftOrRight(valueLeft, valueRight) ([self shouldAlignRight] ? valueRight : valueLeft)

const CGSize QMUIFloatLayoutViewAutomaticalMaximumItemSize = {-1, -1};
@interface QMUIFloatLayoutView ()
@property(nonatomic, strong) CAShapeLayer *separatorLayer;
@end

@implementation QMUIFloatLayoutView

- (instancetype)initWithFrame:(CGRect)frame {
        self = [super initWithFrame:frame];
        if (self) {
                [self didInitialized];
        }
        return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
        if (self = [super initWithCoder:aDecoder]) {
                [self didInitialized];
        }
        return self;
}
- (CAShapeLayer *)recreateLayerWithPath:(UIBezierPath *)path
{
        if (!path)
        {
                self.separatorLayer.path = nil;
                [self.separatorLayer removeFromSuperlayer];
                self.separatorLayer = nil;
        }
        if (self.separatorLayer)
        {
                self.separatorLayer.path = nil;
                [self.separatorLayer removeFromSuperlayer];
                self.separatorLayer = nil;
        }
        self.separatorLayer = [CAShapeLayer layer];
        [self.layer insertSublayer:self.separatorLayer atIndex:0];
        self.separatorLayer.strokeColor = _separatorColor.CGColor;
        self.separatorLayer.lineWidth = _separatorWidth;
        self.separatorLayer.lineDashPhase = _separatorDashed ? 3 : 0;
        self.separatorLayer.path = path.CGPath;
        return self.separatorLayer;
}
- (void)didInitialized {
        self.centerFillLineView = YES;
        self.contentMode = UIViewContentModeLeft;
        self.minimumItemSize = CGSizeZero;
        self.maximumItemSize = QMUIFloatLayoutViewAutomaticalMaximumItemSize;
        self.separatorColor = UIColorSeparator;
}

- (CGSize)systemLayoutSizeFittingSize:(CGSize)targetSize
{
        return [self layoutSubviewsWithSize:targetSize shouldLayout:NO];
}
- (CGSize)sizeThatFits:(CGSize)size {
        return [self layoutSubviewsWithSize:size shouldLayout:NO];
}

- (void)layoutSubviews {
        [super layoutSubviews];
        [self layoutSubviewsWithSize:self.bounds.size shouldLayout:YES];
}
- (CGSize)layoutSubviewsWithSize:(CGSize)size shouldLayout:(BOOL)shouldLayout {
        NSArray<UIView *> *visibleItemViews = [self visibleSubviews];
        BOOL shouldShowSeparator = self.separatorWidth > 0;
        UIBezierPath *separatorPath = shouldShowSeparator ? [UIBezierPath bezierPath] : nil;
        if (visibleItemViews.count == 0)
        {
                [self recreateLayerWithPath:separatorPath];
                return CGSizeMake(UIEdgeInsetsGetHorizontalValue(self.padding), UIEdgeInsetsGetVerticalValue(self.padding));
        }
        
        NSMutableArray *fillLineViews = [NSMutableArray array];
        // 如果是左对齐，则代表 item 左上角的坐标，如果是右对齐，则代表 item 右上角的坐标
        CGPoint itemViewOrigin = CGPointMake(ValueSwitchAlignLeftOrRight(self.padding.left, size.width - self.padding.right), self.padding.top);
        CGFloat currentRowMaxY = itemViewOrigin.y;
        CGSize maximumItemSize = CGSizeEqualToSize(self.maximumItemSize, QMUIFloatLayoutViewAutomaticalMaximumItemSize) ? CGSizeMake(size.width - UIEdgeInsetsGetHorizontalValue(self.padding), size.height - UIEdgeInsetsGetVerticalValue(self.padding)) : self.maximumItemSize;
        
        for (NSInteger i = 0, l = visibleItemViews.count; i < l; i ++) {
                UIView *itemView = visibleItemViews[i];
                
//                CGSize itemViewSize = [itemView systemLayoutSizeFittingSize:maximumItemSize];
                                        CGSize itemViewSize = [itemView sizeThatFits:maximumItemSize];
                itemViewSize.width = fmax(self.minimumItemSize.width, itemViewSize.width);
                itemViewSize.height = fmax(self.minimumItemSize.height, itemViewSize.height);
                itemViewSize.width = fmin(maximumItemSize.width, itemViewSize.width);
                itemViewSize.height = fmin(maximumItemSize.height, itemViewSize.height);
                
                BOOL shouldBreakline = i == 0 ? YES : ValueSwitchAlignLeftOrRight(itemViewOrigin.x + self.itemMargins.left + itemViewSize.width + self.padding.right > size.width,
                                                                                  itemViewOrigin.x - self.itemMargins.right - itemViewSize.width - self.padding.left < 0);
                if (shouldBreakline) {
                        
                        // 换行，每一行第一个 item 是不考虑 itemMargins 的
                        [self reDrawSeparatorPath:fillLineViews separatorPath:separatorPath];
                        if (shouldLayout) {
                                [self relayoutFillLineView:fillLineViews separatorPath:separatorPath];
                                [fillLineViews removeAllObjects];
                                [fillLineViews addObject:itemView];
                                itemView.frame = CGRectMake(ValueSwitchAlignLeftOrRight(self.padding.left, size.width - self.padding.right - itemViewSize.width), currentRowMaxY + self.itemMargins.top, itemViewSize.width, itemViewSize.height);
                        }
                        
                        itemViewOrigin.x = ValueSwitchAlignLeftOrRight(self.padding.left + itemViewSize.width + self.itemMargins.right, size.width - self.padding.right - itemViewSize.width - self.itemMargins.left);
                        itemViewOrigin.y = currentRowMaxY;
                        
                } else {
                        
                        // 当前行放得下
                        if (shouldLayout) {
                                // 记录当前未满行的view
                                [fillLineViews addObject:itemView];
                                itemView.frame = CGRectMake(ValueSwitchAlignLeftOrRight(itemViewOrigin.x + self.itemMargins.left, itemViewOrigin.x - self.itemMargins.right - itemViewSize.width), itemViewOrigin.y + self.itemMargins.top, itemViewSize.width, itemViewSize.height);
                        }
                        
                        itemViewOrigin.x = ValueSwitchAlignLeftOrRight(itemViewOrigin.x + UIEdgeInsetsGetHorizontalValue(self.itemMargins) + itemViewSize.width,
                                                                       itemViewOrigin.x - itemViewSize.width - UIEdgeInsetsGetHorizontalValue(self.itemMargins));
                }
                
                currentRowMaxY = fmax(currentRowMaxY, itemViewOrigin.y + UIEdgeInsetsGetVerticalValue(self.itemMargins) + itemViewSize.height);
        }
        /// 最后一行
        [self reDrawSeparatorPath:fillLineViews separatorPath:separatorPath];
        if (shouldLayout) {
                [self relayoutFillLineView:fillLineViews separatorPath:separatorPath];
                [fillLineViews removeAllObjects];
        }
        
        // 最后一行不需要考虑 itemMarins.bottom，所以这里减掉
        currentRowMaxY -= self.itemMargins.bottom;
        
        CGSize resultSize = CGSizeMake(size.width, currentRowMaxY + self.padding.bottom);
        
        if (shouldShowSeparator) {
                [self recreateLayerWithPath:separatorPath];
        }
        return resultSize;
}
- (void)relayoutFillLineView:(NSMutableArray <UIView *>*)array separatorPath:(UIBezierPath *)separatorPath 
{
        if (self.centerFillLineView && array.count >= 2)
        {
                UIView *lastView = array.lastObject;
                CGFloat maxX = CGRectGetMaxX(lastView.frame);
                CGFloat spilthLeftMargin = self.bounds.size.width - maxX - self.padding.left;
                CGFloat eachMargin = spilthLeftMargin / (array.count - 1.0);
                [array enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        obj.frame = CGRectMake(obj.frame.origin.x + eachMargin * idx, obj.frame.origin.y, obj.frame.size.width, obj.frame.size.height);
                }];
        }
        
}
- (void)reDrawSeparatorPath:(NSMutableArray <UIView *>*)array separatorPath:(UIBezierPath *)separatorPath
{
        if (separatorPath)
        {
                [array enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (idx < array.count - 1 )
                        {
                                UIView *lastView = [array objectAtIndex:(idx + 1)];
                                CGFloat rightTopPointX = CGRectGetMaxX(obj.frame) + (CGRectGetMinX(lastView.frame) - CGRectGetMaxX(obj.frame) - self.separatorWidth) * 0.5;
                                CGPoint rightTopPoint = CGPointMake(rightTopPointX, CGRectGetMinY(obj.frame) + self.separatorPadding.top);
                                CGPoint rightBottomPoint = CGPointMake(rightTopPointX, CGRectGetMaxY(obj.frame) - self.separatorPadding.bottom);
                                [separatorPath moveToPoint:rightTopPoint];
                                [separatorPath addLineToPoint:rightBottomPoint];
                        }
                }];
        }
}
- (NSArray<UIView *> *)visibleSubviews {
        NSMutableArray<UIView *> *visibleItemViews = [[NSMutableArray alloc] init];
        
        for (NSInteger i = 0, l = self.subviews.count; i < l; i++) {
                UIView *itemView = self.subviews[i];
                if (!itemView.hidden) {
                        [visibleItemViews addObject:itemView];
                }
        }
        
        return visibleItemViews;
}

- (BOOL)shouldAlignRight {
        return self.contentMode == UIViewContentModeRight;
}

@end

