//
//  RequestResponseVerify.h
//  MLSProject
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

 @param request 服务器请求
 @param contentType ServerModel.content 的类型
 @param completion 完成回调
 */
+ (void)verifyRequest:(__kindof NetworkRequest *)request contentType:(Class)contentType completion:(void (^)(ServerModel *serverModel, id data, NSError *error))completion;
@end
