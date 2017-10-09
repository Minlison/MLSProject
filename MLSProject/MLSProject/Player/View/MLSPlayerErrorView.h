//
//  MLSPlayerErrorView.h
//  Test
//
//  Created by MinLison on 2017/3/9.
//  Copyright © 2017年 com.minlison.orgz. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface MLSPlayerErrorView : UIView
/**
 播放器错误
 
 @param error 错误信息
 // 取下面两个 key 的值
 NSLocalizedDescriptionKey;		为错误标题
 NSLocalizedFailureReasonErrorKey	错误信息描述
 @param block 点击确定,回调
 */
- (void)setError:(NSError *)error confirm:(void (^)())block;
/**
 播放错误
 
 @param error 错误信息
 @param nowifi 是否是没有 wifi 了
 @param block 回调
 */
- (void)setError:(NSError *)error noWifi:(BOOL)nowifi confirm:(void (^)())block;


/**
 快速创建

 @return MLSPlayerErrorView
 */
+ (instancetype)errorView;
@end
