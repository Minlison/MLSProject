//
//  MLSWebView.h
//  MinLison
//
//  Created by MinLison on 2017/9/7.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseControllerView.h"


/**
 加载完成回调

 @param success 是否成功
 @param error 错误信息
 */
typedef void (^WGWebViewLoadCompletionBlock)(BOOL success, NSError *error);

@interface MLSWebView : BaseControllerView
@property(nonatomic, strong, readonly) IMYWebView *webView;
/**
 加载网页内容

 @param url 网页内容
 @param completion 完成回调
 */
- (void)loadUrlString:(NSString *)urlString success:(WGWebViewLoadCompletionBlock)success failed:(WGWebViewLoadCompletionBlock)failed;
- (void)loadUrl:(NSURL *)url success:(WGWebViewLoadCompletionBlock)success failed:(WGWebViewLoadCompletionBlock)failed;
@end
