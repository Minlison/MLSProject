//
//  MLSRefreshLoadingView.m
//  MinLison
//
//  Created by minlison on 2017/11/23.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSRefreshLoadingView.h"
#define KHWInstallViewMargin __WGWidth(3.0f)
#define KHLineMargin __WGWidth(3.0f)
#define KHWInstallColor UIColorHex(0xdddddd)
@interface MLSRefreshLoadingView()
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIColor *contentColor;

@end
@implementation MLSRefreshLoadingView

- (instancetype)initWithFrame:(CGRect)frame
{
        if (self = [super initWithFrame:frame]) {
                self.backgroundColor = [UIColor clearColor];
                self.contentColor = UIColorHex(0xdddddd);
        }
        return self;
}

-(void)startAnimating
{
        self.contentColor = UIColorHex(0xdddddd);
        self.progress = 0;
        [self setNeedsDisplay];
        _timer = [NSTimer timerWithTimeInterval:0.0065 target:self selector:@selector(displayLinkAction) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        [_timer fire];
        
}
-(void)stopAnimating
{
        self.contentColor = [UIColor clearColor];
        [self setNeedsDisplay];
        [_timer invalidate];
        _timer = nil;
}
- (void)displayLinkAction
{
        if (self.progress <= 1.0)
        {
                self.progress = self.progress+0.01;
        }
        else
        {
                self.progress = 0;
        }
        
        [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{

        //    定义扇形中心
        CGFloat xCenter = rect.size.width * 0.5;
        CGFloat yCenter = rect.size.height * 0.5;
        //    定义扇形半径
        CGFloat radius = MIN(rect.size.width, rect.size.height) * 0.5 - KHWInstallViewMargin;
        //    设定扇形起点位置
        CGFloat startAngle = - M_PI_2;
        //    根据进度计算扇形结束位置
        CGFloat endAngle = startAngle - self.progress * M_PI * 2;
//        1.图形上下文
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        //背景遮罩
//        [self.contentColor set];
//        CGFloat lineW = MAX(rect.size.width, rect.size.height) * 0.5;
//        CGContextSetLineWidth(context, lineW);
//        CGContextAddArc(context, xCenter, yCenter, radius + lineW * 0.5 + KHLineMargin, 0, M_PI * 2, 1);
//        CGContextStrokePath(context);
//
//        //进程圆
//        CGContextSetLineWidth(context, 1);
//        CGContextMoveToPoint(context, xCenter, yCenter);
//        CGContextAddLineToPoint(context, xCenter, 0);
//        CGContextAddArc(context, xCenter, yCenter, radius, - M_PI * 0.5, endAngle, 1);
//        CGContextFillPath(context);
        
        //2.贝塞尔
        CGPoint origin = CGPointMake(xCenter, yCenter);
        //    根据起始点、原点、半径绘制弧线
        UIBezierPath *sectorPath = [UIBezierPath bezierPathWithArcCenter:origin radius:radius startAngle:endAngle endAngle:startAngle clockwise:YES];
        //    从弧线结束为止绘制一条线段到圆心。这样系统会自动闭合图形，绘制一条从圆心到弧线起点的线段。
        [sectorPath addLineToPoint:origin];
        //    设置扇形的填充颜色
        [self.contentColor set];
        //    设置扇形的填充模式
        [sectorPath fill];
        
        
}

@end
