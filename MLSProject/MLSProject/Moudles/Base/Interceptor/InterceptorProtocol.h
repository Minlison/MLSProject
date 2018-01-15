//
//  InterceptorProtocol.h
//  MinLison
//
//  Created by MinLison on 2017/8/31.
//  Copyright © 2017年 minlison. All rights reserved.
//

#ifndef InterceptorProtocol_h
#define InterceptorProtocol_h

#import <Foundation/Foundation.h>
@class ServerModel;
/**
 拦截器
 */
@protocol InterceptorProtocol <NSObject>

/**
 校验数据

 @param data 数据
 @param completion 是否有效
 */
- (void)verify:(ServerModel *)data completion:(void (^)(BOOL valid, NSError *error))completion;
@end

#endif /* InterceptorProtocol_h */
