//
//  MLSTipClass.m
//  MinLison
//
//  Created by minlison on 2017/10/11.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSTipClass.h"

#define WGTipHideDelay 1.5

@implementation MLSTipClass
// MARK: - MinLison add
+ (QMUITips *)showText:(NSString *)text inView:(UIView *)view
{
        return [QMUITips showWithText:text inView:[self getNotNullViewForView:view] hideAfterDelay:WGTipHideDelay];
}
+ (UIView *)getNotNullViewForView:(nullable UIView *)view
{
        UIView *showView = view ?:[UIApplication sharedApplication].keyWindow;
        [QMUITips hideAllToastInView:showView animated:NO];
        return showView;
}
+ (QMUITips *)showText:(NSString *)text
{
        return [self showText:text inView:nil];
}
+ (QMUITips *)showLoadingInView:(UIView * _Nonnull)view
{
        return [QMUITips showLoadingInView:[self getNotNullViewForView:view]];
}
+ (QMUITips *)showSuccessWithText:(nullable NSString *)text inView:(nullable UIView *)view
{
        return [QMUITips showSucceed:text inView:[self getNotNullViewForView:view] hideAfterDelay:WGTipHideDelay];
}
+ (QMUITips *)showErrorWithText:(nullable NSString *)text inView:(nullable UIView *)view
{
        return [QMUITips showError:text inView:[self getNotNullViewForView:view] hideAfterDelay:WGTipHideDelay];
}
+ (void)hideLoadingInView:(UIView * _Nonnull)view
{
        [QMUITips hideAllToastInView:[self getNotNullViewForView:view] animated:YES];
}
@end

