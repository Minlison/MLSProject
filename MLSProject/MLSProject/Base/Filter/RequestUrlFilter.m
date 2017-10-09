//
//  RequestUrlFilter.m
//  MLSProject
//
//  Created by MinLison on 2017/8/31.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "RequestUrlFilter.h"
#import "BaseRequest.h"

@implementation RequestUrlFilter
+ (instancetype)filter
{
        return [[RequestUrlFilter alloc] init];
}
- (NSString *)filterUrl:(NSString *)originUrl withRequest:(BaseRequest *)request {
        NSAssert([request isKindOfClass:[BaseNetworkRequest class]], @"工程内所有的 request 必须继承 BaseNetworkRequest");
        return originUrl;
}
@end
