//
//  MLSExcelViewCollectionHeaderView.m
//  MLSExcelViewSample
//
//  Created by MinLison on 16/4/7.
//  Copyright © 2017年 yizmh. All rights reserved.
//

#import "MLSExcelViewCollectionHeaderView.h"

@interface MLSExcelViewCollectionHeaderView ()

@property (nonatomic, strong) CAShapeLayer *rowSeparatorLayer;

@end

@implementation MLSExcelViewCollectionHeaderView

#pragma mark - override
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateFrame];
}

#pragma mark - private
- (void)setup {
    self.backgroundColor = [UIColor clearColor];
    [self.layer addSublayer:self.rowSeparatorLayer];
}

- (void)updateFrame {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, self.bounds.size.height/2)];
    [path addLineToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height/2)];
    
    _rowSeparatorLayer.path = path.CGPath;
}

#pragma mark - getter
- (CAShapeLayer *)rowSeparatorLayer {
    if (!_rowSeparatorLayer) {
        _rowSeparatorLayer = [CAShapeLayer layer];
        _rowSeparatorLayer.strokeColor = [UIColor lightGrayColor].CGColor;
        _rowSeparatorLayer.lineWidth = 1;
    }
    return _rowSeparatorLayer;
}

#pragma mark - setter

- (void)setRowSeparatorStyle:(MLSExcelViewSeparatorStyle)rowSeparatorStyle {
    if (_rowSeparatorStyle != rowSeparatorStyle) {
        _rowSeparatorStyle = rowSeparatorStyle;
        
        _rowSeparatorLayer.hidden = NO;
        [self layoutIfNeeded];
        if (rowSeparatorStyle == MLSExcelViewSeparatorStyleNone) {
            _rowSeparatorLayer.hidden = YES;
        } else if (rowSeparatorStyle == MLSExcelViewSeparatorStyleDotted) {
            _rowSeparatorLayer.lineDashPattern = @[@2];
        } else if (rowSeparatorStyle == MLSExcelViewSeparatorStyleSolid){
            _rowSeparatorLayer.lineDashPattern = nil;
        }
    }
}

- (void)setRowSeparatorColor:(UIColor *)rowSeparatorColor {
    if (_rowSeparatorColor != rowSeparatorColor) {
        _rowSeparatorColor = rowSeparatorColor;
        
        _rowSeparatorLayer.strokeColor = rowSeparatorColor.CGColor;
    }
}



@end
