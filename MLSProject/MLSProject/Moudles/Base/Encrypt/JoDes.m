//
//  JoDes.m
//  test
//
//  Created by Apple on 15/9/12.
//  Copyright (c) 2015年 MinLison. All rights reserved.
//

#import "JoDes.h"
@interface JoDes()

+ (NSString *) encodeBase64WithString:(NSString *)strData;
+ (NSString *) encodeBase64WithData:(NSData *)objData;
+ (NSData *) decodeBase64WithString:(NSString *)strBase64;
@end
static const char* encryptWithKeyAndType(const char *text,CCOperation encryptOperation,char *key);
@implementation JoDes
/** 加密 */
+ (NSString *) encode:(NSString *)str key:(NSString *)key
{
    const char *charStr = encryptWithKeyAndType([str cStringUsingEncoding:NSUTF8StringEncoding], kCCEncrypt, (char *)[key cStringUsingEncoding:NSUTF8StringEncoding]);

    if (charStr == NULL)
    {
        return @"";
    }

    NSString *ocStr = [[NSString alloc] initWithCString:charStr encoding:NSUTF8StringEncoding];
    
    return ocStr;
}
/** 解密 */
+ (NSString *) decode:(NSString *)str key:(NSString *)key
{
    const char *charStr = encryptWithKeyAndType([str cStringUsingEncoding:NSUTF8StringEncoding], kCCDecrypt, (char *)[key cStringUsingEncoding:NSUTF8StringEncoding]);

    if (charStr == NULL)
    {
        return @"";
    }

    NSString *ocStr = [[NSString alloc] initWithCString:charStr encoding:NSUTF8StringEncoding];
    
    return ocStr;
}

+ (NSString *)encodeBase64WithString:(NSString *)strData {
    return [JoDes encodeBase64WithData:[strData dataUsingEncoding:NSUTF8StringEncoding]];
}
+ (NSString *)encodeBase64WithData:(NSData *)objData {
    return [objData base64EncodedStringWithOptions:0];
}

+ (NSData *)decodeBase64WithString:(NSString *)strBase64 {
    return [[NSData alloc] initWithBase64EncodedString:strBase64 options:0];
}


static const char* encryptWithKeyAndType(const char *text,CCOperation encryptOperation,char *key)
{
    if (text == NULL || key == NULL)
    {
        return NULL;
    }

    NSString *textString=[[NSString alloc]initWithCString:text encoding:NSUTF8StringEncoding];
    const void *dataIn;
    size_t dataInLength;
    
    if (encryptOperation == kCCDecrypt)//传递过来的是decrypt 解码
    {
        //解码 base64
        NSData *decryptData = [JoDes decodeBase64WithString:textString];
        dataInLength = [decryptData length];
        dataIn = [decryptData bytes];
    }
    else  //encrypt
    {
        NSData* encryptData = [textString dataUsingEncoding:NSUTF8StringEncoding];
        dataInLength = [encryptData length];
        dataIn = (const void *)[encryptData bytes];
    }
    
    
    uint8_t *dataOut = NULL;                                    //  可以理解位type/typedef 的缩写（有效的维护了代码，比如：一个人用int，一个人用long。最好用typedef来定义）
    size_t dataOutAvailable = 0;                                //  size_t  是操作符sizeof返回的结果类型
    size_t dataOutMoved = 0;
    
    dataOutAvailable = (dataInLength + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    dataOut = malloc( dataOutAvailable * sizeof(uint8_t));
    memset((void *)dataOut, 00, dataOutAvailable);              //  将已开辟内存空间buffer的首 1 个字节的值设为值 0
    
    //NSString *initIv = @"12345678";
    const void *vkey = key;
    const void *iv = (const void *) key;                        //  [initIv UTF8String];
    
    //CCCrypt函数 加密/解密
    CCCrypt(encryptOperation,                                   //  加密 / 解密
                       kCCAlgorithmDES,                         //  加密根据哪个标准（des，3des，aes。。。。）
                       kCCOptionPKCS7Padding,                   //  选项分组密码算法(des:对每块分组加一次密  3DES：对每块分组加三个不同的密)
                       vkey,                                    //  密钥    加密和解密的密钥必须一致
                       kCCKeySizeDES,                           //  DES 密钥的大小（kCCKeySizeDES=8）
                       iv,                                      //  可选的初始矢量
                       dataIn,                                  //  数据的存储单元
                       dataInLength,                            //  数据的大小
                       (void *)dataOut,                         //  用于返回数据
                       dataOutAvailable,
                       &dataOutMoved);
    
    NSString *result = nil;
    
    if (encryptOperation == kCCDecrypt)//encryptOperation==1  解码
    {
        //得到解密出来的data数据，改变为utf-8的字符串
        result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved] encoding:NSUTF8StringEncoding];
        
    }
    else //encryptOperation==0  （加密过程中，把加好密的数据转成base64的）
    {
        //编码 base64
        NSData *data = [NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved];
        //        result = [GTMBase64 stringByEncodingData:data];
        result = [JoDes encodeBase64WithData:data];
    }
    if(dataOut != NULL) {
        free(dataOut);
        dataOut=NULL;
    }
    return [result UTF8String];
}

+(NSString*)encryptWithContent:(NSString*)content type:(CCOperation)type key:(NSString*)aKey
{
    const char * contentChar =[content UTF8String];
    char * keyChar =(char*)[aKey UTF8String];
    const char *miChar;
    miChar = encryptWithKeyAndType(contentChar, type, keyChar);
    if (miChar == NULL)
    {
        return @"";
    }
    return  [NSString stringWithCString:miChar encoding:NSUTF8StringEncoding];
}

@end
