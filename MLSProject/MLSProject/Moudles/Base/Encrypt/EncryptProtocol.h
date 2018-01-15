//
//  EncryptProtocol.h
//  MinLison
//
//  Created by MinLison on 2017/8/31.
//  Copyright © 2017年 minlison. All rights reserved.
//

#ifndef EncryptToolProtocol_h
#define EncryptToolProtocol_h
#import <Foundation/Foundation.h>
@protocol  EncryptProtocol <NSObject>

/**
 加密参数
 
 @param param 参数
 @return 加密后的参数
 */
- (NSDictionary *)encryptParam:(NSDictionary *)param;

/**
 解密服务器返回的数据
 
 @param responseString 服务器返回的加密数据
 @return 解密后的数据 (NSArray, NSDictionary, NSString)
 */
- (id)decryptObjectFromResponseString:(NSString *)responseString;

/**
 解密服务器返回的数据
 
 @param responseString 服务器返回的加密数据
 @return 解密后的数据 (NSData)
 */
- (NSData *)decryptDataFromResponseString:(NSString *)responseString;

/**
 解密服务器返回的数据
 
 @param responseString 服务器返回的加密数据
 @return 解密后的数据 (NSString)
 */
- (NSString *)decryptStringFromResponseString:(NSString *)responseString;

/**
 解密服务器返回的数据
 
 @param responseString 服务器返回的加密数据
 @return 解密后的数据 (NSString)
 */
- (NSString *)decryptStringFromResponseData:(NSData *)responseData;

/**
 解密服务器返回的数据
 
 @param responseString 服务器返回的加密数据
 @return 解密后的数据 (NSData)
 */
- (NSData *)decryptDataFromResponseData:(NSData *)responseData;

/**
 解密服务器返回的数据
 
 @param responseString 服务器返回的加密数据
 @return 解密后的数据 (NSArray, NSDictionary, NSString)
 */
- (id)decryptObjectFromResponseData:(NSData *)responseData;

@end
#endif
