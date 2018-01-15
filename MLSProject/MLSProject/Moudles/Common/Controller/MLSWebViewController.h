//
//  MLSWebViewController.h
//  MinLison
//
//  Created by MinLison on 2017/9/7.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseViewController.h"
#import "MLSWebView.h"
#import "BaseViewModel.h"
@interface MLSWebViewController : BaseViewController <MLSWebView *>


/**
 创建控制器

 @param url  网页地址
 
 @return 控制器
 */
+ (instancetype)webViewControllerWithUrl:(NSURL *)url;
+ (instancetype)webViewControllerWithUrlString:(NSString *)urlString;
@end
