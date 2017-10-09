//
//  MLSRouterURIConst.h
//  MLSProject
//
//  Created by MinLison on 2017/9/7.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef MLSRouterURIConst_h
#define MLSRouterURIConst_h

/// MARK: - MLSWebViewController
/*
 Create MLSWebViewController
 NSURL *url = AppRouteURLWithURIFormat(kMLSWebViewControllerURI, @"url=%@",@"https://www.baidu.com");
 
 [AppShareRouterService routeURL:url handler:^(NSDictionary<NSString *,id> * _Nullable parameters, UIViewController<JLRRouteDefinitionTargetController> * _Nullable targetVC) {
        NSLog(@"%@__%@",parameters,targetVC);
 }];
 */
FOUNDATION_EXTERN NSString *const kMLSWebViewControllerURI;
FOUNDATION_EXTERN NSString *const kMLSWebViewControllerParamKey_URL;


/// MARK: - MLSPlayerViewController
/*
 Create MLSPlayerViewController
 NSURL *url = AppRouteURLWithURIFormat(kMLSWebViewControllerURI, @"url=%@",@"https://www.baidu.com");
 
 [AppShareRouterService routeURL:url handler:^(NSDictionary<NSString *,id> * _Nullable parameters, UIViewController<JLRRouteDefinitionTargetController> * _Nullable targetVC) {
 NSLog(@"%@__%@",parameters,targetVC);
 }];
 */
FOUNDATION_EXTERN NSString *const kMLSPlayerViewControllerURI;
FOUNDATION_EXTERN NSString *const kMLSPlayerViewControllerParamKey_URL;
FOUNDATION_EXTERN NSString *const kMLSPlayerViewControllerParamKey_VIDEO_NAME;

#endif
