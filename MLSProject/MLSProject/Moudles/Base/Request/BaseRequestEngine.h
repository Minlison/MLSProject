//
//  BaseRequestEngine.h
//  MinLison
//
//  Created by MinLison on 2017/11/1.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
@interface BaseRequestEngine : NSObject

/**
 开始请求

 @param request 网络请求
 */
+ (void)startRequest:(__kindof BaseRequest *)request;

/**
 完成请求

 @param request 网络请求
 */
+ (void)finishRequest:(__kindof BaseRequest *)request;
@end
