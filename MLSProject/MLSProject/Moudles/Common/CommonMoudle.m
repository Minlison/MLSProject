//
//  CommonMoudle.m
//  MinLison
//
//  Created by MinLison on 2017/9/6.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "CommonMoudle.h"
#import "MLSWebViewController.h"
#import "TURLSessionProtocol.h"
@MOUDLE_REGISTER(CommonMoudle)
@implementation CommonMoudle
- (void)modSetUp:(BHContext *)context
{
        [NSURLProtocol registerClass:[TURLSessionProtocol class]];
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        config.protocolClasses = @[[TURLSessionProtocol class]];
        [AppShareRouterService addRoute:AppRoutePatternStringWithURI(kMLSWebViewControllerURI) handlerClass:[MLSWebViewController class]];
}
@end
