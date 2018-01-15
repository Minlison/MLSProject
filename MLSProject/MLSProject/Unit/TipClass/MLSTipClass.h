//
//  MLSTipClass.h
//  MinLison
//
//  Created by minlison on 2017/10/11.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface MLSTipClass : NSObject
+ (QMUITips *)showText:(nullable NSString *)text inView:(nullable UIView *)view;
+ (QMUITips *)showText:(nullable NSString *)text;
+ (QMUITips *)showLoadingInView:(UIView * _Nonnull)view;
+ (QMUITips *)showSuccessWithText:(nullable NSString *)text inView:(nullable UIView *)view;
+ (QMUITips *)showErrorWithText:(nullable NSString *)text inView:(nullable UIView *)view;
+ (void)hideLoadingInView:(UIView * _Nonnull)view;
@end

NS_ASSUME_NONNULL_END
