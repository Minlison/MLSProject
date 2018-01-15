//
//  MLSRefreshHeader.m
//  MinLison
//
//  Created by MinLison on 16/2/29.
//  Copyright © 2016年 MinLison. All rights reserved.
//

#import "MLSRefreshHeader.h"
#import "MLSRefreshLoadingView.h"
@interface MLSRefreshHeader ()
@property (weak, nonatomic) MLSRefreshLoadingView *loadingView;
@end


@implementation MLSRefreshHeader

#pragma mark - 重写父类的方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
	[super prepare];
        // 设置控件的高度
        self.mj_h = 56;
	//加载动画视图
        MLSRefreshLoadingView *loadingView = [[MLSRefreshLoadingView alloc] initWithFrame:CGRectMake(0, 0, __WGWidth(23.0f), __WGWidth(23.0f))];
        loadingView.layer.cornerRadius = __WGWidth(11.5f);
        loadingView.layer.borderWidth = __WGWidth(1.0f);
        loadingView.layer.borderColor = UIColorHex(0xdddddd).CGColor;
        loadingView.clipsToBounds = YES;
        [self addSubview:loadingView];
        self.loadingView = loadingView;
}


#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
	[super placeSubviews];
	self.backgroundColor = UIColorHex(0xf1f1f1);
        self.lastUpdatedTimeLabel.hidden = YES;
        self.stateLabel.hidden = YES;
	//加载动画视图位置
        self.loadingView.center = CGPointMake(self.mj_w * 0.5, self.mj_h * 0.5);
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
	/// MJ 防止重复刷新
	MJRefreshCheckState;
        
        switch (state) {
                case MJRefreshStateIdle:
                        [self.loadingView stopAnimating];//停止 赶紧下拉
                        break;
                case MJRefreshStatePulling:
                        [self.loadingView stopAnimating];//停止 赶紧放开
                        break;
                case MJRefreshStateRefreshing:
                        [self.loadingView startAnimating];//动画 正在刷新
                        break;
                default:
                        break;
        }
	
	
}
#pragma mark 自定义

@end
