//
//  RequestResponseVerify.m
//  MLSProject
//
//  Created by MinLison on 2017/9/6.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "RequestResponseVerify.h"


@implementation RequestResponseVerify
+ (void)verifyRequest:(__kindof NetworkRequest *)request contentType:(Class)contentType completion:(void (^)(ServerModel *serverModel, id data, NSError *error))completion
{
        /// 获取服务器模型
        ServerModel *serverModel = [ServerModel modelWithJSON:request.decryptResponseString];
        /// 获取内容模型
        id data = [self _GetModelFormJsonObject:serverModel.content contentClass:contentType];
        serverModel.modelContent = data;
        completion(serverModel, data, [serverModel validError]);
}

/// 生成 model
/// MARK: - Private Method
+ (id)_GetModelFormJsonObject:(id)json contentClass:(Class)contentClass
{
        id jsonObject = json;
        
        if (contentClass)
        {
                if ([jsonObject isKindOfClass:[NSArray class]])
                {
                        return [NSArray modelArrayWithClass:contentClass json:jsonObject];
                }
                else
                {
                        return [contentClass modelWithJSON:jsonObject];
                }
                
        }
        return jsonObject;
}
@end
