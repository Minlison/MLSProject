//
//  BaseView.m
//  MinLison
//
//  Created by MinLison on 2017/8/31.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseControllerView.h"

@implementation BaseControllerView
@synthesize controller = _controller;
- (instancetype)initWithFrame:(CGRect)frame
{
        if (self = [super initWithFrame:frame]) {
                self.backgroundColor = UIColorForBackground;
        }
        return self;
}

- (BaseViewController *)controller
{
        if (!_controller) {
                _controller = (BaseViewController *)self.jk_viewController;
        }
        return _controller;
}
- (void)setupView
{
}
- (void)dealloc
{
        NSLogDebug(@"------ %@ ------- dealloc",self);
}
@end
