//
//  MLSSecurityTools.h
//  MLSProject
//
//  Created by MinLison on 15/9/11.
//  Copyright (c) 2015年 minlison. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (MLSSecurity)
/**
 aes_base64 加密后的字符串
 */
@property(nonatomic, copy, readonly) NSString *aes_base64_encryptString;
/**
 aes_base64 加密后的数据
 */
@property(nonatomic, strong, readonly) NSData *aes_base64_encryptData;

/**
 aes_base64 解密后的字符串
 */
@property(nonatomic, copy, readonly) NSString *aes_base64_decryptString;

/**
 aes_base64 解密后的数据
 */
@property(nonatomic, strong, readonly) NSData *aes_base64_decryptData;

@end

@interface NSString (MLSSecurity)
/**
 aes_base64 加密后的字符串
 */
@property(nonatomic, copy, readonly) NSString *aes_base64_encryptString;
/**
 aes_base64 加密后的数据
 */
@property(nonatomic, strong, readonly) NSData *aes_base64_encryptData;

/**
 aes_base64 解密后的字符串
 */
@property(nonatomic, copy, readonly) NSString *aes_base64_decryptString;

/**
 aes_base64 解密后的数据
 */
@property(nonatomic, strong, readonly) NSData *aes_base64_decryptData;

@end

@interface NSArray (MLSSecurity)
/**
 aes_base64 加密后的字符串
 */
@property(nonatomic, copy, readonly) NSString *aes_base64_encryptString;
/**
 aes_base64 加密后的数据
 */
@property(nonatomic, strong, readonly) NSData *aes_base64_encryptData;

/**
 aes_base64 解密后的字符串
 */
@property(nonatomic, copy, readonly) NSString *aes_base64_decryptString;

/**
 aes_base64 解密后的数据
 */
@property(nonatomic, strong, readonly) NSData *aes_base64_decryptData;

@end

@interface NSDictionary (MLSSecurity)

/**
 aes_base64 加密后的字符串
 */
@property(nonatomic, copy, readonly) NSString *aes_base64_encryptString;
/**
 aes_base64 加密后的数据
 */
@property(nonatomic, strong, readonly) NSData *aes_base64_encryptData;

/**
 aes_base64 解密后的字符串
 */
@property(nonatomic, copy, readonly) NSString *aes_base64_decryptString;

/**
 aes_base64 解密后的数据
 */
@property(nonatomic, strong, readonly) NSData *aes_base64_decryptData;

@end

/**
 加密解密工具
 */
@interface MLSSecurityTools : NSObject

/// MARK: - 加密
/**
 加密
 aes加密后, base64 encode 的字符串
 @param obj NSString, NSData, 可序列化对象(NSArray, NSDictionary)
 @return 加密后的字符串
 */
+ (NSString *)aes_base64_encryptStringWithObject:(id)obj;

/**
 加密
 aes加密后, base64 encode 的 NSData
 @param obj NSString, NSData , 可序列化对象(NSArray, NSDictionary)
 @return 加密后的NSData
 */
+ (NSData *)aes_base64_encryptDataWithObject:(id)obj;


/// MARK: - 解密
/**
 解密
 先 base64 decode 然后进行 aes 解密后的 NSData
 @param obj 需要解密的数据 NSString, NSData
 @return 解密后的字符串
 */
+ (NSString *)aes_base64_decryptStringWithObject:(id)obj;

/**
 解密
 先 base64 decode 然后进行 aes 解密后的 NSData
 @param obj 需要解密的数据 NSString, NSData
 @return 解密后的字符串
 */
+ (NSData *)aes_base64_decryptDataWithObject:(id)obj;

@end
