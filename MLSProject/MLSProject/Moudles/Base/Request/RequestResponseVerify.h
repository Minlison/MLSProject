//
//  RequestResponseVerify.h
//  MinLison
//
//  Created by MinLison on 2017/9/6.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerModel.h"
#import "NetworkRequest.h"

@interface RequestResponseVerify : NSObject

/**
 校验服务器返回信息

 @param response 服务器返回数据
 @param contentType ServerModel.content 的类型
 @param data contentType 模型数据
 @param completion 完成回调
 */
+ (void)verifyRequest:(__kindof NetworkRequest *)request contentType:(Class)contentType completion:(void (^)(ServerModel *serverModel, id data, NSError *error))completion;
+ (void)verifyRequest:(__kindof NetworkRequest *)request contentType:(Class)contentType contentKeyPath:(nullable NSString *)keyPath completion:(void (^)(ServerModel *serverModel, id data, NSError *error))completion;
@end
