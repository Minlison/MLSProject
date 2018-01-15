//
//  MLSWebView.m
//  MinLison
//
//  Created by MinLison on 2017/9/7.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSWebView.h"
#import "IMYWebView.h"
#import "TURLSessionProtocol.h"
@interface MLSWebView () <IMYWebViewDelegate>
@property(nonatomic, strong, readwrite) IMYWebView *webView;
@property(nonatomic, copy) WGWebViewLoadCompletionBlock successCallBack;
@property(nonatomic, copy) WGWebViewLoadCompletionBlock failedCallBack;
@end

@implementation MLSWebView
- (void)loadUrlString:(NSString *)urlString success:(WGWebViewLoadCompletionBlock)success failed:(WGWebViewLoadCompletionBlock)failed
{
        [self loadUrl:[NSURL URLWithString:NOT_NULL_STRING_DEFAULT_EMPTY(urlString)] success:success failed:failed];
}
- (void)loadUrl:(NSURL *)url success:(WGWebViewLoadCompletionBlock)success failed:(WGWebViewLoadCompletionBlock)failed
{
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setValue:@"1" forHTTPHeaderField:KProtocolHttpHeadKey];
        [self.webView loadRequest:request];
        self.successCallBack = success;
        self.failedCallBack = failed;
}


- (void)webViewDidFinishLoad:(IMYWebView *)webView
{
        if (self.successCallBack)
        {
                self.successCallBack(YES, nil);
        }
        [self cleanBlock];
}

- (void)webView:(IMYWebView *)webView didFailLoadWithError:(NSError *)error
{
        /// ([error.domain isEqualToString:@"WebKitErrorDomain"] && error.code == 204) 表示插件加载错误，不处理
        if(error.code == NSURLErrorCancelled)
        {
                 return;
        }
        if (([error.domain isEqualToString:@"WebKitErrorDomain"] && error.code == 204))
        {
                if (self.successCallBack)
                {
                        self.successCallBack(YES, nil);
                }
        }
        else
        {
                if (self.failedCallBack)
                {
                        self.failedCallBack(NO, [NSError appErrorWithCode:APP_ERROR_CODE_ERR msg:nil remark:error.localizedDescription]);
                }
                [self cleanBlock];
        }
        
}
- (void)cleanBlock
{
        self.failedCallBack = nil;
        self.successCallBack = nil;
}
/// MARK: - Super method
- (void)setupView
{
        [super setupView];
        self.webView = [[IMYWebView alloc] initWithFrame:self.bounds usingUIWebView:YES]; // 暂时直接使用 UIWebView
        self.webView.scalesPageToFit = YES;
        self.webView.delegate = self;
        [self addSubview:self.webView];
        [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
                if (@available(iOS 11.0,*))
                {
                        make.top.equalTo(self.mas_safeAreaLayoutGuideTop);
                        make.left.equalTo(self.mas_safeAreaLayoutGuideLeft);
                        make.right.equalTo(self.mas_safeAreaLayoutGuideRight);
                        make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom);
                }
                else
                {
                        make.top.equalTo(self.controller.mas_topLayoutGuideBottom);
                        make.left.right.equalTo(self);
                        make.bottom.equalTo(self.controller.mas_bottomLayoutGuideTop);
                }
        }];
}
@end
