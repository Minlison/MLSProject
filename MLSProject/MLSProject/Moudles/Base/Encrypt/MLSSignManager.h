//
//  MLSSignManager.h
//  MinLison
//
//  Created by MinLison on 2017/9/22.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDictionary+Sign.h"
NS_ASSUME_NONNULL_BEGIN

@interface MLSSignManager : NSObject

/**
 根据 version 获取 sign

 @param version  方法版本号
 @return 签名
 */
+ (nullable NSString *)getSignForVersion:(NSString *)version;

/**
 存储 sign 本地 + 内存

 @param sign 签名
 @param version 方法版本号
 */
+ (void)storeSign:(NSString *)sign forVersion:(NSString *)version;

/**
 清楚 sign

 @param version  方法版本号
 */
+ (void)cleanSignForVersion:(NSString *)version;

/**
 清楚所有 sign
 */
+ (void)cleanAllSign;
@end
NS_ASSUME_NONNULL_END
