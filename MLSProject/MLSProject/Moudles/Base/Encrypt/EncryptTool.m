//
//  EncryptTool.m
//  MinLison
//
//  Created by MinLison on 2017/8/31.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "EncryptTool.h"
#import "MLSSecurityTools.h"
#import "RMUUid.h"
#import "MLSSignManager.h"

@implementation EncryptTool
+ (instancetype)sharedInstance {
        static dispatch_once_t onceToken;
        static EncryptTool *instance = nil;
        dispatch_once(&onceToken,^{
                instance = [[super alloc] init];
        });
        return instance;
}

- (NSDictionary *)encryptParam:(NSDictionary *)param
{
        NSString *sign = [MLSSignManager getSignForVersion:param.versionValue];
        
        if ( NULLString(sign) )
        {
                return param;
        }
        
        NSMutableDictionary *entryPara = nil;
        
        NSString *paramsStr = [param jsonStringEncoded];
        
        NSMutableString *signStringM = [[NSMutableString alloc] initWithString:paramsStr];
        
        if (signStringM)
        {
                /// 保证最后一个参数是 sign
                NSString *keyStr = [NSString stringWithFormat:@",\"key\":\"%@\"",sign];
                
                [signStringM insertString:keyStr atIndex:signStringM.length - 1];
                
                
                NSString *signStr = signStringM.md5String.md5String;
                
                entryPara = @{
                              kRequestKeyParam : paramsStr.aes_base64_encryptString?:@"",
                              kRequestKeySign : signStr.aes_base64_encryptString?:@"",
                              kRequestKeyTrace_Id : [AppUnit getAUniqueString]
                              }.mutableCopy;
        }
//        NSLogDebug(@"Encrypt Param - %@\nsign - %@\nencryptParam - %@\n",param,sign,entryPara);
        return entryPara;
}

- (id)decryptObjectFromResponseString:(NSString *)responseString
{
        NSString *decryptString = responseString.aes_base64_decryptString;
        return decryptString.jsonValueDecoded;
}
- (NSData *)decryptDataFromResponseString:(NSString *)responseString
{
        return responseString.aes_base64_decryptData;
}

- (NSString *)decryptStringFromResponseString:(NSString *)responseString
{
        return responseString.aes_base64_decryptString;
}
- (NSString *)decryptStringFromResponseData:(NSData *)responseData
{
        return responseData.aes_base64_decryptString;
}
- (NSData *)decryptDataFromResponseData:(NSData *)responseData
{
        return responseData.aes_base64_decryptData;
}
- (id)decryptObjectFromResponseData:(NSData *)responseData
{
        NSString *decryptString = responseData.aes_base64_decryptString;
        return decryptString.jsonValueDecoded;
}

@end
