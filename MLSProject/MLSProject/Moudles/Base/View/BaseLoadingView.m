//
//  BaseLoadingView.m
//  MinLison
//
//  Created by MinLison on 2017/9/13.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseLoadingView.h"

@interface BaseLoadingView ()
@property(nonatomic, strong) YYAnimatedImageView *animationView;
@end

@implementation BaseLoadingView
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
                make.center.equalTo(self);
                make.width.mas_equalTo(55);
                make.height.mas_equalTo(55);
        }];
}

- (YYAnimatedImageView *)animationView
{
        if (_animationView == nil) {
                _animationView = [[YYAnimatedImageView alloc] initWithFrame:CGRectZero];
                int imgCount = 24;
                NSMutableArray <__kindof UIImage *>*tmp = [NSMutableArray arrayWithCapacity:imgCount];
                for (int i = 0; i < imgCount; i++)
                {
                        NSString *imgName = [NSString stringWithFormat:@"loading000%02d",i];
                        UIImage *image = [UIImage imageNamed:imgName];
                        [tmp addObject:image];
                }
                _animationView.animationImages = tmp;
        }
        return _animationView;
}
@end
