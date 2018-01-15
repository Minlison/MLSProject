//
//  NSArray+Request.h
//  MinLison
//
//  Created by MinLison on 2017/9/22.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BaseRequest;

@interface NSArray<ObjcType> (Request)
typedef void(^GroupRequestSuccessBlock)(NSArray <ObjcType>*requests);
typedef void(^GroupRequestFailedBlock)(NSArray <ObjcType>*requests, NSError *error);

@property(nonatomic, assign, getter=isSync) BOOL sync;

/**
 组访问
 @param order 是否顺序执行
 @param success 成功回调, 所有全部成功才会回调
 @param failed 失败回调, 回调最后一个失败的错误消息
 */
- (void)startSync:(BOOL)sync requestWithSuccess:(GroupRequestSuccessBlock)success failed:(GroupRequestFailedBlock)failed;
/**
 组访问
 并发执行
 @param success 成功回调, 所有全部成功才会回调
 @param failed 失败回调, 回调最后一个失败的错误消息
 */
- (void)startRequestWithSuccess:(GroupRequestSuccessBlock)success failed:(GroupRequestFailedBlock)failed;
@end
