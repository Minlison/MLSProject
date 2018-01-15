//
//  RequestResponseVerify.m
//  MinLison
//
//  Created by MinLison on 2017/9/6.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "RequestResponseVerify.h"


@implementation RequestResponseVerify

+ (void)verifyRequest:(__kindof NetworkRequest *)request contentType:(Class)contentType contentKeyPath:(nullable NSString *)keyPath completion:(void (^)(ServerModel *serverModel, id data, NSError *error))completion
{
        /// 获取服务器模型
        ServerModel *serverModel = [ServerModel modelWithJSON:request.decryptResponseString];
        if (serverModel == nil)
        {
                if (completion)
                {
                        completion(nil,nil,[NSError appErrorWithCode:APP_ERROR_CODE_REPONSE_ERROR msg:nil remark:nil]);
                }
                return;
        }
        /// 获取内容模型
        id data = nil;
        if (keyPath) {
                data = [self _GetModelFormJsonObject:[request.decryptResponseObject valueForKeyPath:keyPath] contentClass:contentType];
        } else {
                data = [self _GetModelFormJsonObject:serverModel.content contentClass:contentType];
        }
        serverModel.modelContent = data;
        completion(serverModel, data, [serverModel validError]);
}

+ (void)verifyRequest:(__kindof NetworkRequest *)request contentType:(Class)contentType completion:(void (^)(ServerModel *serverModel, id data, NSError *error))completion
{
        [self verifyRequest:request contentType:contentType contentKeyPath:nil completion:completion];
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
