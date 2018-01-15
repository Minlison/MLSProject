//
//  MLSDebugControl.m
//  MLSLogger
//
//  Created by MinLison on 16/8/18.
//  Copyright © 2016年 MinLison. All rights reserved.
//

#import "MLSDebugControl.h"
#import "MLSMenuButtonView.h"
#import "MLSLogDataManager.h"
#import "MLSDebugInstance.h"
@interface MLSDebugControl()
@property (copy, nonatomic) void (^ShowBlock)(BOOL isShow);
@property (weak, nonatomic) UIButton *debugBtn;
@property (assign, nonatomic) BOOL touchMoved;
@end
@implementation MLSDebugControl
+ (instancetype)debugControlWithShowDebugViewBlock:(void (^)(BOOL isShow))block
{
        MLSDebugControl *control = [[MLSDebugControl alloc] init];
        control.backgroundColor = [UIColor clearColor];
        control.ShowBlock = block;
        return control;
}
- (instancetype)init
{
        if (self = [super init])
        {
                [self setupButton];
        }
        return self;
}

- (void)layoutSubviews
{
        [super layoutSubviews];
        self.debugBtn.layer.cornerRadius = CGRectGetWidth(self.bounds) * 0.5;
}

- (void)resetFrame
{
        CGRect frame = self.frame;
        frame.size.width = [MLSDebugInstance shareInstance].radius * 2;
        frame.size.height = frame.size.width;
        
        CGRect superFrame = [UIScreen mainScreen].bounds;
        
        CGFloat minY = 0;
        CGFloat maxY = superFrame.size.height - frame.size.height;
        CGFloat minX = 0;
        CGFloat maxX = superFrame.size.width - frame.size.width;
        
        // 判断靠左，还是靠右
        CGFloat halfMargin = (CGRectGetWidth(superFrame) - CGRectGetWidth(frame)) * 0.5;
        
        // 靠右
        CGFloat leftOrigin = self.frame.origin.x + self.window.frame.origin.x;
        if (leftOrigin > halfMargin)
        {
                // 放到右边
                CGPoint origin = frame.origin;
                origin.x = 0;
                self.frame = CGRectMake(superFrame.size.width - frame.size.width, origin.y, frame.size.width, frame.size.height);
        }
        else
        {
                // 放到左边
                CGPoint origin = frame.origin;
                origin.x = 0;
                
                self.frame = CGRectMake(0, origin.y, frame.size.width, frame.size.height);
        }
        if (![self isShow])
        {
                CGRect windowRect = self.window.frame;
                CGRect selfFrame = self.frame;
                
                
                CGFloat x = selfFrame.origin.x;
                x = x < minX ? minX : x;
                x = x > maxX ? maxX : x;
                
                CGFloat y = windowRect.origin.y + selfFrame.origin.y;
                y = y < minY ? minY : y;
                y = y > maxY ? maxY : y;
                
                windowRect = CGRectMake(x, y, selfFrame.size.width, selfFrame.size.height);
                
                self.window.frame = windowRect;
                self.frame = self.bounds;
        }
}

- (void)touch:(UIButton *)btn event:(UIEvent *)event
{
        self.touchMoved = NO;
}
- (void)move:(UIButton *)btn event:(UIEvent *)event
{
        UITouch *touch = event.allTouches.anyObject;
        CGPoint touchLoc = [touch locationInView:self.superview];
        if (ABS(ABS(touchLoc.x) - ABS(btn.center.x)) > 10 || ABS(touchLoc.y) - ABS(btn.center.y))
        {
                self.touchMoved = YES;
        }
        self.center = touchLoc;
}
- (BOOL)isShow
{
        return self.debugBtn.selected;
}
- (void)touchUP:(UIButton *)btn event:(UIEvent *)event
{
        if (!self.touchMoved)
        {
                if (![self isShow])
                {
                        CGRect windRect = self.window.frame;
                        self.window.frame = [UIScreen mainScreen].bounds;
                        self.frame = windRect;
                        
                        self.debugBtn.selected = !self.debugBtn.selected;
                        if (self.ShowBlock)
                        {
                                self.ShowBlock([self isShow]);
                        }
                        
                }
                else
                {
                        if ([MLSMenuButtonView standardMenuView].isShowing)
                        {
                                [[MLSMenuButtonView standardMenuView] dismiss];
                        }
                        else
                        {
                                [[MLSMenuButtonView standardMenuView] setClickAddButton:^(NSInteger index, id item) {
                                        // 清除
                                        if (index == 1)
                                        {
                                                
                                                [[MLSLogDataManager shareManager] clear];
                                        }
                                        // 隐藏
                                        else if (index == 2)
                                        {
                                                
                                                self.window.frame = self.frame;
                                                self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
                                                
                                                self.debugBtn.selected = !self.debugBtn.selected;
                                                if (self.ShowBlock)
                                                {
                                                        self.ShowBlock([self isShow]);
                                                }
                                        }
                                }];
                                [MLSMenuButtonView standardMenuView].ShowInSuperView = self.window;
                                [MLSMenuButtonView standardMenuView].centerPoint = self.center;
                                [MLSMenuButtonView standardMenuView].menuBounds = self.bounds;
                                
                                [[MLSMenuButtonView standardMenuView] showItems];
                        }
                        
                }
        }
        [self resetFrame];
}

- (void)setupButton
{
        UIButton *DebugButton = [[UIButton alloc] init];
        DebugButton.backgroundColor = [UIColor blueColor];
        [DebugButton addTarget:self action:@selector(touch:event:) forControlEvents:(UIControlEventTouchDown)];
        [DebugButton addTarget:self action:@selector(move:event:) forControlEvents:(UIControlEventTouchDragInside)];
        [DebugButton addTarget:self action:@selector(touchUP:event:) forControlEvents:(UIControlEventTouchUpInside)];
        self.debugBtn = DebugButton;
        DebugButton.titleLabel.font = [UIFont systemFontOfSize:12];
        
        [DebugButton setTitleShadowColor:nil forState:UIControlStateSelected];
        
        [DebugButton setTitle:@"显示" forState:(UIControlStateNormal)];
        [DebugButton setTitle:@"更多" forState:(UIControlStateSelected)];
        DebugButton.backgroundColor = [UIColor colorWithRed:0 green:206 blue:209 alpha:1];
        [self addSubview:DebugButton];
        
        DebugButton.translatesAutoresizingMaskIntoConstraints = NO;
        NSDictionary *views = NSDictionaryOfVariableBindings(DebugButton);
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[DebugButton]-0-|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[DebugButton]-0-|" options:0 metrics:nil views:views]];
}
@end
