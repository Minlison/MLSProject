//
//  BaseCommentLoadingView.m
//  MinLison
//
//  Created by MinLison on 2017/11/8.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseCommentLoadingView.h"
@interface BaseCommentLoadingView ()
{
        CGFloat angle;
}
@property(nonatomic, strong) YYAnimatedImageView *animationView;
@end

@implementation BaseCommentLoadingView
- (instancetype)initWithFrame:(CGRect)frame
{
        if (self = [super initWithFrame:frame]) {
                [self _SetupUI];
        }
        return self;
}
- (void)startAnimating
{
        [self.animationView startAnimating];
}
- (void)_SetupUI
{
        [self addSubview:self.animationView];
        [self.animationView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
        }];
}

- (YYAnimatedImageView *)animationView
{
        if (_animationView == nil) {
                _animationView = [[YYAnimatedImageView alloc] init];
                int imgCount = 24;
                NSMutableArray <__kindof UIImage *>*tmp = [NSMutableArray arrayWithCapacity:imgCount];
                for (int i = 0; i < imgCount; i++)
                {
                        UIImage *image = [[UIImage circle_loading] imageByRotate:((M_PI * 2 *   (imgCount - i)) / imgCount) fitSize:NO];
                        [tmp addObject:image];
                }
                _animationView.animationImages = tmp;
        }
        return _animationView;
}
@end
