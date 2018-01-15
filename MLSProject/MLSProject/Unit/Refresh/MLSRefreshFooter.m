//
//  CZVerticalListRefreshFooter.m
//  MinLison
//
//  Created by Apple on 15/9/29.
//  Copyright © 2015年 MinLison. All rights reserved.
//

#import "MLSRefreshFooter.h"

#define ANIMATION_IMAGE_SIZE (REFRESH_HEIGHT - ANIMATION_IMAGE_TOP_MARGIN - ANIMATION_IMAGE_BOTTOM_MARGIN)

@interface MLSRefreshFooter()
@property (strong, nonatomic) UILabel *	textTipLabel;
@property (strong, nonatomic) NSMutableDictionary *stateTitles;
@property (assign, nonatomic) CGFloat lastBottomDelta;
@property (weak, nonatomic) UIActivityIndicatorView *loadingView;
@end

@implementation MLSRefreshFooter
- (NSMutableDictionary *)stateTitles
{
	if (_stateTitles == nil) {
		_stateTitles = [[NSMutableDictionary alloc] init];
	}
	return _stateTitles;
}
- (void)setTitle:(NSString *)title forState:(MJRefreshState)state
{
	if (title == nil) return;
	self.stateTitles[@(state)] = title;
	self.textTipLabel.text = self.stateTitles[@(self.state)];
}
- (void)prepare {
        [super prepare];
        self.mj_h = REFRESH_HEIGHT;
        [self addSubview:self.textTipLabel];
        [self addSubview:self.loadingView];
        
        self.triggerAutomaticallyRefreshPercent = -50;
	
	[self setTitle:[NSString aPP_upLoadMore] forState:MJRefreshStateIdle];
	[self setTitle:[NSString aPP_stopForRefresh] forState:MJRefreshStatePulling];
	[self setTitle:[NSString aPP_refreshIng] forState:MJRefreshStateRefreshing];
	[self setTitle:[NSString aPP_endRefresh] forState:MJRefreshStateNoMoreData];
	
}
- (void)placeSubviews
{
        [super placeSubviews];
//        self.backgroundColor = UIColorFromRGB(__VIEW_BACK_COLOR__);
	if (self.state != MJRefreshStateNoMoreData) {
		
		self.backgroundColor = [UIColor clearColor];
		CGRect textRect = [self.textTipLabel.text boundingRectWithSize:CGSizeMake(__MAIN_SCREEN_WIDTH__, REFRESH_HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : WGSystem13Font} context:nil];
		CGFloat width = textRect.size.width + ANIMATION_IMAGE_SIZE;
		CGFloat imgX = (self.frame.size.width - width) * 0.5;
		CGRect imgRect = CGRectMake(imgX, ANIMATION_IMAGE_TOP_MARGIN, ANIMATION_IMAGE_SIZE, ANIMATION_IMAGE_SIZE);
		
		CGFloat labelX = CGRectGetMaxX(imgRect) + 5;
		CGFloat labelY = imgRect.origin.y;
		CGFloat labelW = textRect.size.width;
		CGFloat labelH = imgRect.size.height;
		CGRect labelFrame = CGRectMake(labelX, labelY, labelW, labelH);
		self.loadingView.frame = imgRect;
		self.textTipLabel.frame = labelFrame;
	} else {
		self.backgroundColor = [UIColor clearColor];
		CGRect textRect = [self.textTipLabel.text boundingRectWithSize:CGSizeMake(__MAIN_SCREEN_WIDTH__, REFRESH_HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : WGSystem13Font} context:nil];
		self.loadingView.frame = CGRectZero;
		self.textTipLabel.bounds = textRect;
		self.textTipLabel.center = CGPointMake(CGRectGetWidth(self.bounds) * 0.5, CGRectGetHeight(self.bounds) * 0.5);
	}
        
}
- (UILabel *)textTipLabel {
        if (_textTipLabel == nil) {
                _textTipLabel = [[UILabel alloc] init];
                _textTipLabel.font = WGSystem13Font;
                _textTipLabel.textColor = UIColorHex(0xb8b8b8);
                _textTipLabel.textAlignment = NSTextAlignmentCenter;
        }
        return _textTipLabel;
}
- (UIActivityIndicatorView *)loadingView
{
	if (!_loadingView) {
		UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
		loadingView.hidesWhenStopped = YES;
		CGAffineTransform transform = CGAffineTransformMakeScale(0.8f, 0.8f);
		loadingView.transform = transform;
		loadingView.color = UIColorHex(0x9e9e9e);
		[self addSubview:_loadingView = loadingView];
	}
	return _loadingView;
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
	[super scrollViewContentOffsetDidChange:change];
        _scrollViewOriginalInset = self.scrollView.contentInset;
	CGPoint newOffset = [[change objectForKey:@"new"] CGPointValue];
	CGPoint oldOffset = [[change objectForKey:@"old"] CGPointValue];
	
        
	if ((newOffset.y - oldOffset.y) > 0)
	{
		[self setTitle:[NSString aPP_upLoadMore] forState:MJRefreshStateIdle];
	}
        // 如果已全部加载,然后返回
        if (self.state == MJRefreshStateNoMoreData)
        {
                return;
        }
        
}
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
        [super scrollViewContentSizeDidChange:change];
        // 内容的高度
        CGFloat contentHeight = self.scrollView.mj_contentH + self.scrollView.mj_insetB + self.ignoredScrollViewContentInsetBottom;
        // 表格的高度
        CGFloat scrollHeight = self.scrollView.mj_h + self.ignoredScrollViewContentInsetBottom;
        // 设置位置和尺寸
        self.mj_y = MAX(contentHeight, scrollHeight);
}
#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
        MJRefreshCheckState;
        self.textTipLabel.text = self.stateTitles[@(self.state)];
        [self placeSubviews];
        switch (state) {
                case MJRefreshStateIdle:
                {
                        [self.loadingView stopAnimating];
                        break;
                }
                case MJRefreshStatePulling:
                        [self.loadingView stopAnimating];
                        break;
                case MJRefreshStateRefreshing:
                {
                        [self.loadingView startAnimating];
			[self setTitle:@"刷新成功" forState:MJRefreshStateIdle];
                        break;
                }
                case MJRefreshStateNoMoreData:
                {
                        [self.loadingView stopAnimating];
                        break;
                }
                default:
                        break;
        }
}

@end
