//
//  MLSSecurityTools.m
//  MLSProject
//
//  Created by MinLison on 15/9/11.
//  Copyright (c) 2015年 minlison. All rights reserved.
//

#import "MLSSecurityTools.h"
#import "JoDes.h"
#define __EMPTY_STRING__        nil
#define __EMPTY_DATA__          nil
#define __PASSWORD_KEY__        @"AqbR6zEYOGSvRek1NWWFuy=="
#define __IV_KEY__              @"0807060504030201"

static NSDataBase64EncodingOptions const kBase64EncodeOption = 0;
static NSDataBase64DecodingOptions const kBase64DecodeOption = 0;
#ifdef DEBUG

#define SecurityAssert(condition, desc, ...) NSAssert(condition, desc, ##__VA_ARGS__)

#else

#define SecurityAssert(condition, desc, ...)

#endif

@implementation MLSSecurityTools

/**
 获取字符串
 如果对象可序列化, 序列化成字符串
 @param obj 对象
 @param jsonSerialization 是否序列化对象
 @return 字符串
 */
+ (NSString *)getStringFromObj:(id)obj jsonSerialization:(BOOL)jsonSerialization
{
        SecurityAssert(obj != nil, @"加密数据格式不正确");
        
        if (obj == nil)
        {
                return nil;
        }
        else if ([obj isKindOfClass:[NSString class]]) // 字符串
        {
                return obj;
        }
        else if ([obj isKindOfClass:[NSData class]]) // 二进制数据
        {
                return [[NSString alloc] initWithData:obj encoding:(NSUTF8StringEncoding)];
        }
        else if (jsonSerialization && [obj isValidJSONObject:obj]) // NSArray, NSDictionary
        {
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:0 error:nil];
                if (jsonData == nil)
                {
                        return nil;
                }
                return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
        else
        {
                SecurityAssert(NO, @"加密/解密 数据格式不正确");
                return nil;
        }
}
+ (NSString *)aes_base64_encryptStringWithObject:(id)obj
{
        NSString *base64String = [self aes_encryptWithText:[self getStringFromObj:obj jsonSerialization:YES] key:[self getKey]];
        return base64String;
}

+ (NSData *)aes_base64_encryptDataWithObject:(id)obj
{
        NSString *encryptString = [self aes_base64_encryptStringWithObject:obj];
        return [encryptString dataUsingEncoding:NSUTF8StringEncoding];
}

+ (NSString *)aes_base64_decryptStringWithObject:(id)obj
{
        NSString *aesDecryptString = [self aes_decryptWithText:[self getStringFromObj:obj jsonSerialization:NO] key:[self getKey]];
        return aesDecryptString;
}


+ (NSData *)aes_base64_decryptDataWithObject:(id)obj
{
        NSString *decryptString = [self aes_base64_decryptStringWithObject:obj];
        return [decryptString dataUsingEncoding:NSUTF8StringEncoding];
}

/**
 加密字符串
 
 @param sText 带加密的字符串
 @return 加密后的字符串
 */
+ (NSString *)encryptWithText:(NSString *)sText
{
        return [self aes_encryptWithText:sText key:[self getKey]];;
}

/**
 解密字符串

 @param sText 加密的字符串
 @return 解密后的字符串
 */
+ (NSString *)decryptWithText:(NSString *)sText
{
        return [self aes_decryptWithText:sText key:[self getKey]];
}

/**
 aes 加密秘钥 key

 @return key data
 */
+ (NSData *)getKey
{
        return [[NSData alloc] initWithBase64EncodedString:__PASSWORD_KEY__ options:0];
}

/**
 aes 加密 iv

 @return iv data
 */
+ (NSData *)getIV
{
        return [__IV_KEY__ dataUsingEncoding:NSUTF8StringEncoding];
}

/**
 *  AES加密
 *  1、NSString -utf8-> NSData
 *  2、NSData -加密-> NSData(Encrypt)
 *  3、NSData(Encrypt) -base64-> NSString
 *
 *  @param sText 需要加密的字符串
 *  @param key 秘钥key
 *
 *  @return NSString
 */
+ (NSString *)aes_encryptWithText:(NSString *)sText key:(NSData *)key
{
        
        if (sText == nil || sText.length == 0)
        {
                return __EMPTY_STRING__;
        }
        
        NSData *sTextData = [sText dataUsingEncoding:NSUTF8StringEncoding];
        
        if (sTextData.length == 0 || sTextData == nil)
        {
                return __EMPTY_STRING__;
        }
        
        NSData *data = [self aes256EncryptData:sTextData WithKey:key iv:[self getIV]];
        
        if (data.length == 0 || data == nil)
        {
                return __EMPTY_STRING__;
        }
        
        return [data base64EncodedStringWithOptions:kBase64EncodeOption];
}

/**
 *  AES加密
 *  1、NSData -加密-> NSData(Encrypt)
 *  2、NSData(Encrypt) -base64-> NSData
 *
 *  @param data 需要加密的数据
 *  @param key 秘钥key
 *
 *  @return NSData
 */
+ (NSData *)aes_encryptWithData:(NSData *)data key:(NSData *)key
{
        if (data == nil || data.length == 0)
        {
                return __EMPTY_DATA__;
        }
        
        NSData *encryptData = [self aes256EncryptData:data WithKey:key iv:[self getIV]];
        
        if (encryptData.length == 0 || encryptData == nil)
        {
                return __EMPTY_DATA__;
        }
        
        return [encryptData base64EncodedDataWithOptions:kBase64EncodeOption];
}


/**
 *  AES解密
 *  1、NSString -base64 decode    -> NSData
 *  2、NSData -aes 解密            -> NSData(Decrypt)
 *  3、NSData(Decrypt) -utf8      -> NSString
 *
 *  @param sText 需要解密的字符串
 *  @param key 秘钥key
 *
 *  @return NSString *
 */
+ (NSString *)aes_decryptWithText:(NSString *)sText key:(NSData *)key
{
        if (sText == nil || sText.length == 0)
        {
                return __EMPTY_STRING__;
        }
        
        NSData *base64DecodeData = [[NSData alloc] initWithBase64EncodedString:sText options:kBase64DecodeOption];
        
        if (base64DecodeData.length == 0 || base64DecodeData == nil)
        {
                return __EMPTY_STRING__;
        }
        
        NSData *decryptData = [self aes256DecryptData:base64DecodeData Withkey:key iv:[self getIV]];
        
        if (decryptData.length == 0 || decryptData == nil)
        {
                return __EMPTY_STRING__;
        }

        return [[NSString alloc] initWithData:decryptData encoding:NSUTF8StringEncoding];
}

/**
 *  AES解密
 *  1、NSData -base64 decode      -> NSData
 *  2、NSData -aes 解密            -> NSData(Decrypt)
 *
 *  @param base64Data 需要解密的base64 encode 的数据
 *  @param key 秘钥key
 *
 *  @return NSString *
 */
+ (NSData *)aes_decryptWithData:(NSData *)base64Data key:(NSData *)key
{
        if (base64Data.length == 0 || base64Data == nil)
        {
                return __EMPTY_DATA__;
        }
        
        NSData *base64DecodeData = [[NSData alloc] initWithBase64EncodedData:base64Data options:kBase64DecodeOption];
        
        return [self aes256DecryptData:base64DecodeData Withkey:key iv:[self getIV]];
}



/**
 aes256 加密

 @param data 数据
 @param key  key
 @param iv iv
 @return  加密的数据
 */
+ (NSData *)aes256EncryptData:(NSData *)data WithKey:(NSData *)key iv:(NSData *)iv {
        if (data == nil || data.length <= 0) {
                return nil;
        }
        if (key.length != 16 && key.length != 24 && key.length != 32) {
                return nil;
        }
        if (iv.length != 16 && iv.length != 0) {
                return nil;
        }
        
        NSData *result = nil;
        size_t bufferSize = data.length + kCCBlockSizeAES128;
        void *buffer = malloc(bufferSize);
        if (!buffer) return nil;
        size_t encryptedSize = 0;
        
        CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                              kCCAlgorithmAES128,
                                              kCCOptionPKCS7Padding | kCCOptionECBMode,
                                              key.bytes,
                                              key.length,
                                              iv.bytes,
                                              data.bytes,
                                              data.length,
                                              buffer,
                                              bufferSize,
                                              &encryptedSize);
        if (cryptStatus == kCCSuccess) {
                result = [[NSData alloc]initWithBytes:buffer length:encryptedSize];
		
                free(buffer);
                return result;
        } else {
                free(buffer);
                return nil;
        }
}

/**
 aes256 解密

 @param data 待解密的数据
 @param key  key
 @param iv iv
 @return 解密后的数据
 */
+ (NSData *)aes256DecryptData:(NSData *)data Withkey:(NSData *)key iv:(NSData *)iv {
        if (key.length != 16 && key.length != 24 && key.length != 32) {
                return nil;
        }
        if (iv.length != 16 && iv.length != 0) {
                return nil;
        }
        
        NSData *result = nil;
        size_t bufferSize = data.length + kCCBlockSizeAES128;
        void *buffer = malloc(bufferSize);
        if (!buffer) return nil;
        size_t encryptedSize = 0;
        CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                              kCCAlgorithmAES128,
                                              kCCOptionPKCS7Padding | kCCOptionECBMode,
                                              key.bytes,
                                              key.length,
                                              iv.bytes,
                                              data.bytes,
                                              data.length,
                                              buffer,
                                              bufferSize,
                                              &encryptedSize);
        if (cryptStatus == kCCSuccess) {
                result = [[NSData alloc]initWithBytes:buffer length:encryptedSize];
                free(buffer);
                return result;
        } else {
                free(buffer);
                return nil;
        }
}


@end

@implementation NSDictionary (MLSSecurity)

/**
 aes_base64 加密后的字符串
 */
- (NSString *)aes_base64_encryptString
{
        return [MLSSecurityTools aes_base64_encryptStringWithObject:self];
}

/**
 aes_base64 加密后的数据
 */
- (NSData *)aes_base64_encryptData
{
        return [MLSSecurityTools aes_base64_encryptDataWithObject:self];
}

/**
 aes_base64 解密后的字符串
 */
- (NSString *)aes_base64_decryptString
{
        return [MLSSecurityTools aes_base64_decryptStringWithObject:self];
}

/**
 aes_base64 解密后的数据
 */
- (NSData *)aes_base64_decryptData
{
        return [MLSSecurityTools aes_base64_decryptDataWithObject:self];
}


@end

@implementation NSData (MLSSecurity)

/**
 aes_base64 加密后的字符串
 */
- (NSString *)aes_base64_encryptString
{
        return [MLSSecurityTools aes_base64_encryptStringWithObject:self];
}

/**
 aes_base64 加密后的数据
 */
- (NSData *)aes_base64_encryptData
{
        return [MLSSecurityTools aes_base64_encryptDataWithObject:self];
}

/**
 aes_base64 解密后的字符串
 */
- (NSString *)aes_base64_decryptString
{
        return [MLSSecurityTools aes_base64_decryptStringWithObject:self];
}

/**
 aes_base64 解密后的数据
 */
- (NSData *)aes_base64_decryptData
{
        return [MLSSecurityTools aes_base64_decryptDataWithObject:self];
}


@end

@implementation NSString (MLSSecurity)

/**
 aes_base64 加密后的字符串
 */
- (NSString *)aes_base64_encryptString
{
        return [MLSSecurityTools aes_base64_encryptStringWithObject:self];
}

/**
 aes_base64 加密后的数据
 */
- (NSData *)aes_base64_encryptData
{
        return [MLSSecurityTools aes_base64_encryptDataWithObject:self];
}

/**
 aes_base64 解密后的字符串
 */
- (NSString *)aes_base64_decryptString
{
        return [MLSSecurityTools aes_base64_decryptStringWithObject:self];
}

/**
 aes_base64 解密后的数据
 */
- (NSData *)aes_base64_decryptData
{
        return [MLSSecurityTools aes_base64_decryptDataWithObject:self];
}


@end

@implementation NSArray (MLSSecurity)
/**
 aes_base64 加密后的字符串
 */
- (NSString *)aes_base64_encryptString
{
        return [MLSSecurityTools aes_base64_encryptStringWithObject:self];
}

/**
 aes_base64 加密后的数据
 */
- (NSData *)aes_base64_encryptData
{
        return [MLSSecurityTools aes_base64_encryptDataWithObject:self];
}

/**
 aes_base64 解密后的字符串
 */
- (NSString *)aes_base64_decryptString
{
        return [MLSSecurityTools aes_base64_decryptStringWithObject:self];
}

/**
 aes_base64 解密后的数据
 */
- (NSData *)aes_base64_decryptData
{
        return [MLSSecurityTools aes_base64_decryptDataWithObject:self];
}

@end
