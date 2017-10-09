//
//  BaseView.m
//  MLSProject
//
//  Created by MinLison on 2017/8/31.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseView.h"

@implementation BaseView
@synthesize controller = _controller;
- (instancetype)initWithFrame:(CGRect)frame
{
        if (self = [super initWithFrame:frame]) {
                self.backgroundColor = QMUICMI.backgroundColor;
        }
        return self;
}

- (UIViewController *)controller
{
        if (!_controller) {
                _controller = self.jk_viewController;
        }
        return _controller;
}
- (void)setupViews{};
@end
