//
//  NSArray+Request.h
//  MLSProject
//
//  Created by MinLison on 2017/10/09.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BaseRequest;

@interface NSArray<ObjcType> (Request)
typedef void(^GroupRequestSuccessBlock)(NSArray <ObjcType>*requests);
typedef void(^GroupRequestFailedBlock)(NSArray <ObjcType>*requests, NSError *error);

/**
 网络错误
 */
@property(nonatomic, strong) NSError *requestError;

/**
 组访问

 @param success 成功回调, 所有全部成功才会回调
 @param failed 失败回调, 回调最后一个失败的错误消息
 */
- (void)startRequestWithSuccess:(GroupRequestSuccessBlock)success failed:(GroupRequestFailedBlock)failed;
@end
