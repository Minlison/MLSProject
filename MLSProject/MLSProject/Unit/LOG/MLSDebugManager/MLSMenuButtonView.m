//
//  TLMenuButtonView.m
//  MiShu
//
//  Created by tianlei on 16/6/24.
//  Copyright © 2016年 Qzy. All rights reserved.
//

#import "MLSMenuButtonView.h"
#import "MLSMenuButton.h"

#define ColorWithRGB(r, g, b) [UIColor colorWithRed:r/256.0 green:g/256.0 blue:b/256.0 alpha:0.9]
UIWindow *(^ShowWindow)() = ^() {
        __block UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [[UIApplication sharedApplication].windows enumerateObjectsUsingBlock:^(__kindof UIWindow * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.windowLevel > window.windowLevel)
                {
                        window = obj;
                }
        }];
        return window;
};

#define kWindow  ShowWindow()
typedef NS_ENUM(NSInteger, MLSMenuDirection)
{
        MLSMenuDirectionTopLeft,
        MLSMenuDirectionTopRight,
        MLSMenuDirectionBootomLeft,
        MLSMenuDirectionBootomRight
};


@interface MLSMenuButtonView ()

@property (strong, nonatomic) NSMutableArray <NSValue *>*CenterPoints;


@property (assign, nonatomic) MLSMenuDirection direction;

@end

@implementation MLSMenuButtonView
- (instancetype)init{
        if (self = [super init])
        {
                
                self.menuBounds = CGRectMake(0, 0, 80, 80);
                self.itemMargin = 8;
                
                NSMutableArray *buttons = [[NSMutableArray alloc] init];
                
                MLSMenuButton *menu1 = [MLSMenuButton buttonWithTitle:@"清除" imageTitle:nil color:ColorWithRGB(93,198,78)];
                menu1.tag = 1;
                [menu1 addTarget:self action:@selector(_addExamApprovel:) forControlEvents:UIControlEventTouchUpInside];
                
                [buttons addObject:menu1];
                
                
                MLSMenuButton *menu2 = [MLSMenuButton buttonWithTitle:@"隐藏" imageTitle:nil color:ColorWithRGB(242,104,90)];
                menu2.tag = 2;
                [menu2 addTarget:self action:@selector(_addExamApprovel:) forControlEvents:UIControlEventTouchUpInside];
                [buttons addObject:menu2];
                
                
                self.menuItems = buttons;
        }
        return self;
}
- (void)setMenuItems:(NSArray<UIButton *> *)menuItems
{
        if (_menuItems != menuItems)
        {
                _menuItems = menuItems;
                [self clear];
                [self prepare];
        }
}
- (void)setCenterPoint:(CGPoint)centerPoint
{
        if (!CGPointEqualToPoint(_centerPoint, centerPoint))
        {
                _centerPoint = centerPoint;
                [self clear];
                [self prepare];
        }
}
- (void)setMenuBounds:(CGRect)menuBounds
{
        if (!CGRectEqualToRect(_menuBounds, menuBounds))
        {
                _menuBounds = menuBounds;
                [self clear];
                [self prepare];
        }
}
- (void)setItemMargin:(CGFloat)itemMargin
{
        if (_itemMargin != itemMargin)
        {
                _itemMargin = itemMargin;
                [self clear];
                [self prepare];
        }
}
- (void)setShowInSuperView:(UIView *)ShowInSuperView
{
        if (_ShowInSuperView != ShowInSuperView)
        {
                _ShowInSuperView = ShowInSuperView;
                [self clear];
                [self prepare];
        }
}
- (void)caculateDirection:(CGFloat)r
{
        CGRect superFrame = [UIScreen mainScreen].bounds;
        CGFloat x = self.centerPoint.x - self.menuBounds.size.width * 0.5;
        CGFloat y = self.centerPoint.y - self.menuBounds.size.height * 0.5;
        CGRect currentFrame = CGRectMake(x, y, self.menuBounds.size.width, self.menuBounds.size.height);
        
        CGFloat topMargin = y;
        CGFloat leftMargin = x;
        CGFloat bootomMargin = superFrame.size.height - currentFrame.size.height - y;
        CGFloat rightMargin = superFrame.size.width - currentFrame.size.width - x;
        
        if (topMargin > r && leftMargin > r)
        {
                self.direction = MLSMenuDirectionTopLeft;
        }
        else if (topMargin > r && rightMargin > r)
        {
                self.direction = MLSMenuDirectionTopRight;
        }
        else if (bootomMargin > r && leftMargin > r)
        {
                self.direction = MLSMenuDirectionBootomLeft;
        }
        else if (bootomMargin > r && rightMargin > r)
        {
                self.direction = MLSMenuDirectionBootomRight;
        }
}

- (void)clear
{
        [self.CenterPoints removeAllObjects];
        self.CenterPoints = nil;
}
- (MLSMenuButtonView *)prepare
{
        
        if (!self.ShowInSuperView)
        {
                return nil;
        }
        
        NSInteger centers = self.CenterPoints.count;
        NSInteger items = self.menuItems.count;
        
        if (items <= 0)
        {
                return nil;
        }
        
        if (centers > 0 && items > 0 && (centers == items))
        {
                return self;
        }
        
        
        [self.CenterPoints removeAllObjects];
        self.CenterPoints = nil;
        
        CGPoint center = self.centerPoint;
        CGFloat count = self.menuItems.count * 1.0;
        CGFloat radius = M_PI_2 / (count - 1);
        CGFloat cornerRadius = self.menuBounds.size.width * 0.5;
        // 计算扩散半径
        CGFloat r = 0.5 * (self.menuBounds.size.width + self.itemMargin) / ABS(sin(radius * 0.5));
        CGFloat minR = self.menuBounds.size.width + self.itemMargin;
        r = r < minR ? minR : r;
        
        [self caculateDirection:r];
        
        self.CenterPoints = [NSMutableArray array];
        
        switch (self.direction) {
                case MLSMenuDirectionTopLeft: {
                        for (int i = 0; i < count; i++)
                        {
                                CGFloat x = ABS(center.x) - ABS(r * cos( i * radius ));
                                CGFloat y = ABS(center.y) - ABS(r * sin( i * radius ));
                                CGPoint point = CGPointMake(x, y);
                                
                                UIButton *btn = self.menuItems[i];
                                btn.frame = self.menuBounds;
                                btn.center = self.centerPoint;
                                btn.alpha = 0;
                                btn.hidden = YES;
                                btn.layer.cornerRadius = cornerRadius;
                                [self.ShowInSuperView addSubview:btn];
                                [self.CenterPoints addObject:[NSValue valueWithCGPoint:point]];
                        }
                        break;
                }
                case MLSMenuDirectionTopRight: {
                        for (int i = 0; i < count; i++)
                        {
                                
                                CGFloat x = ABS(center.x) + ABS(r * cos( i * radius ));
                                CGFloat y = ABS(center.y) - ABS(r * sin( i * radius ));
                                CGPoint point = CGPointMake(x, y);
                                
                                UIButton *btn = self.menuItems[i];
                                btn.frame = self.menuBounds;
                                btn.center = self.centerPoint;
                                btn.alpha = 0;
                                btn.hidden = YES;
                                btn.layer.cornerRadius = cornerRadius;
                                [self.ShowInSuperView addSubview:btn];
                                [self.CenterPoints addObject:[NSValue valueWithCGPoint:point]];
                        }
                        break;
                }
                case MLSMenuDirectionBootomLeft: {
                        for (int i = 0; i < count; i++)
                        {
                                
                                CGFloat x = ABS(center.x) - ABS(r * cos( i * radius ));
                                CGFloat y = ABS(center.y) + ABS(r * sin( i * radius ));
                                CGPoint point = CGPointMake(x, y);
                                
                                UIButton *btn = self.menuItems[i];
                                btn.frame = self.menuBounds;
                                btn.center = self.centerPoint;
                                btn.alpha = 0;
                                btn.hidden = YES;
                                btn.layer.cornerRadius = cornerRadius;
                                [self.ShowInSuperView addSubview:btn];
                                [self.CenterPoints addObject:[NSValue valueWithCGPoint:point]];
                        }
                        break;
                }
                case MLSMenuDirectionBootomRight: {
                        for (int i = 0; i < count; i++)
                        {
                                
                                CGFloat x = ABS(center.x) + ABS(r * cos( i * radius ));
                                CGFloat y = ABS(center.y) + ABS(r * sin( i * radius ));
                                CGPoint point = CGPointMake(x, y);
                                
                                UIButton *btn = self.menuItems[i];
                                btn.frame = self.menuBounds;
                                btn.center = self.centerPoint;
                                btn.alpha = 0;
                                btn.hidden = YES;
                                btn.layer.cornerRadius = cornerRadius;
                                [self.ShowInSuperView addSubview:btn];
                                [self.CenterPoints addObject:[NSValue valueWithCGPoint:point]];
                        }
                        break;
                }
        }
        
        
        return self;
}

- (void)_showItems
{
        [UIView animateWithDuration:0.2 animations:^{
                for (int i = 0; i < self.menuItems.count; i++)
                {
                        UIButton *btn = self.menuItems[i];
                        btn.hidden = NO;
                        btn.alpha = 1;
                        btn.center = [self.CenterPoints[i] CGPointValue];
                }
        }];
}
- (void)showItems
{
        if (self.isShowing)
        {
                return;
        }
        self.showing = YES;
        return [[self prepare] _showItems];
}

- (void)dismiss
{
        if (!self.isShowing)
        {
                return;
        }
        self.showing = NO;
        [UIView animateWithDuration:0.2 animations:^{
                
                for (int i = 0; i < self.menuItems.count; i++)
                {
                        UIButton *btn = self.menuItems[i];
                        btn.alpha = 0;
                        btn.center = self.centerPoint;;
                }
        } completion:^(BOOL finished) {
                for (int i = 0; i < self.menuItems.count; i++)
                {
                        UIButton *btn = self.menuItems[i];
                        btn.hidden = YES;
                }
        }];
}

- (void)_addExamApprovel:(UIButton *)sender
{
        
        if (self.clickAddButton)
        {
                self.clickAddButton(sender.tag, sender );
        }
        [self dismiss];
        // 防止循环引用
        self.clickAddButton = nil;
}
+ (instancetype)standardMenuView{
        static MLSMenuButtonView *instanceMenuView;
        static dispatch_once_t predicate;
        dispatch_once(&predicate, ^{
                instanceMenuView = [[self alloc] init];
        });
        return instanceMenuView;
}
@end
