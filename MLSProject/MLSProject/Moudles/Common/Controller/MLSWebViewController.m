//
//  MLSWebViewController.m
//  MinLison
//
//  Created by MinLison on 2017/9/7.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSWebViewController.h"
#import "TURLSessionProtocol.h"
@interface MLSWebViewController ()
@property(nonatomic, strong) NSURL *url;
@end

@implementation MLSWebViewController
+ (instancetype)webViewControllerWithUrlString:(NSString *)urlString
{
        DebugAssert(urlString, @"字符串不能为空");
        return [self webViewControllerWithUrl:[NSURL URLWithString:NOT_NULL_STRING_DEFAULT_EMPTY(urlString)]];
}
+ (instancetype)webViewControllerWithUrl:(NSURL *)url
{
        DebugAssert(url, @"URL不能为空");
        MLSWebViewController *vc = [[MLSWebViewController alloc] init];
        vc.url = url;
        vc.hidesBottomBarWhenPushed = YES;
        return vc;
}
- (void)viewDidLoad
{
        [super viewDidLoad];
        if (!self.url)
        {
                [self setError:[NSError appErrorWithCode:APP_ERROR_CODE_ERR msg:[NSString app_RequestNormalError] remark:@"url 为空"]];
                return;
        }
        BOOL customCached =[TURLSessionProtocol isCachedForUrl:self.url.absoluteString];
        BOOL urlCache = [[NSURLCache sharedURLCache] cachedResponseForRequest:[NSURLRequest requestWithURL:self.url]] != nil;
        if ( !customCached && !urlCache)
        {
                [self setLoading:YES animation:YES];
        }
        else
        {
                [self loadData];
        }
}
- (void)viewDidAppear:(BOOL)animated
{
        [super viewDidAppear:animated];
        if (self.isFirstAppear)
        {
                [self loadData];
        }
}
- (void)reloadData
{
        [self loadData];
}
- (void)loadData
{
        if (!self.url)
        {
                [self setError:[NSError appErrorWithCode:APP_ERROR_CODE_ERR msg:[NSString app_RequestNormalError] remark:@"url 为空"]];
                return;
        }
        @weakify(self);
        [self.controllerView loadUrl:self.url success:^(BOOL success, NSError *error) {
                @strongify(self);
                [self setSuccess];
        } failed:^(BOOL success, NSError *error) {
                @strongify(self);
                [self setError:error];
        }];
}
- (void)viewDidDisappear:(BOOL)animated
{
        [super viewDidDisappear:animated];
        [self.controllerView loadUrl:self.url success:nil failed:nil];
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
        return UIStatusBarStyleDefault;
}
+ (UIViewController<JLRRouteDefinitionTargetController> *)targetControllerWithParams:(NSDictionary *)parameters
{
        NSString *urlString = [parameters objectForKey:kRequestKeyUrl];
        if (!urlString) {
                return nil;
        }
        return [self webViewControllerWithUrlString:urlString];
}
@end
