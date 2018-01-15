//
//  MLSDebugView.m
//  MLSLogger
//
//  Created by MinLison on 16/8/18.
//  Copyright © 2016年 MinLison. All rights reserved.
//

#import "MLSDebugView.h"
#import "MLSDebugInstance.h"

@interface MLSDebugView()
@property (strong, nonatomic) UITextView *textView;
@property (assign, nonatomic) CGFloat pinchLastLength;
@property (copy, nonatomic) NSString *debug_str;
@end

@implementation MLSDebugView
- (instancetype)init
{
        if (self = [super init])
        {
                [self addSubview:self.textView];
                [self setPinchGesture];
        }
        return self;
}
- (void)setPinchGesture
{
        UIPinchGestureRecognizer *pinchGest = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGes:)];
        [self.textView addGestureRecognizer:pinchGest];
}
- (void)handlePinchGes:(UIPinchGestureRecognizer *)gesture
{
        if (gesture.state == UIGestureRecognizerStateChanged)
        {
                
                NSUInteger touches = [gesture numberOfTouches];
                
                if (touches == 2)
                {
                        CGFloat fontSize = self.textView.font.pointSize + gesture.scale * gesture.velocity;
                        self.textView.font = [UIFont fontWithName:self.textView.font.fontName size:fontSize];
                }
        }
}
- (void)clear
{
        self.debug_str = nil;
        self.textView.text = @"";
}
- (void)setString:(NSString *)str
{
        self.debug_str = str;
}
- (void)layoutSubviews
{
        [super layoutSubviews];
        self.textView.frame = self.bounds;
        self.textView.text = self.debug_str;
        [self.textView setContentOffset:CGPointZero];
}
- (void)showDebug
{
        self.textView.hidden = NO;
}
- (void)hideDebug
{
        self.textView.hidden = YES;
}
- (UITextView *)textView
{
        if (_textView == nil) {
                _textView = [[UITextView alloc] init];
                _textView.hidden = YES;
                _textView.editable = NO;
                _textView.selectable = NO;
                _textView.showsVerticalScrollIndicator = NO;
                _textView.font = [[MLSDebugInstance shareInstance] debugTextFont];
                _textView.backgroundColor = [[MLSDebugInstance shareInstance] debugBackgroundColor];
                _textView.alpha = [[MLSDebugInstance shareInstance] debugViewAlpha];
                _textView.textColor = [[MLSDebugInstance shareInstance] debugTextColor];
        }
        return _textView;
}
@end
