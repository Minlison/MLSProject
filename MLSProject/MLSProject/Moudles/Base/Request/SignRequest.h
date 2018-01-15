//
//  SignRequest.h
//  MinLison
//
//  Created by MinLison on 2017/9/6.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseRequest.h"
#import "SignModel.h"
@interface SignRequest : BaseRequest <SignModel *>

/**
 创建签名请求
 
 @param version 版本号
 @param appID 应用的 bundleID
 @return  request
 */
+ (instancetype)requestWithVersion:(NSString *)version appID:(NSString *)appID;

/**
 创建签名请求
 
 @param version 版本号
 @param appID 应用的 bundleID
 @return  request
 */
+ (instancetype)requestWithVersion:(NSString *)version;
@end
