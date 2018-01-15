//
//  RequestUrlFilter.h
//  MinLison
//
//  Created by MinLison on 2017/8/31.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 全局对 网络请求 增加或者删除参数
 */
@interface RequestUrlFilter : NSObject <YTKUrlFilterProtocol>
+ (instancetype)filter;
@end
