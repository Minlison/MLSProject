//
//  UIView+LNSameBounds.m
//  MLSProject
//
//  Created by MinLison on 2017/12/8.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "UIView+LNSameBounds.h"

YYSYNTH_DUMMY_CLASS(UIView_LNSameBounds)

@implementation UIView (LNSameBounds)
- (UIView *)sameBoundsSubView
{
        __block UIView *view = nil;
        [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (CGRectEqualToRect(obj.bounds, self.bounds)) {
                        view = obj;
                        *stop = YES;
                }
        }];
        return view;
}
@end
