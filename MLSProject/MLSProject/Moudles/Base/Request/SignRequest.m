//
//  SignRequest.m
//  MinLison
//
//  Created by MinLison on 2017/9/6.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "SignRequest.h"
#import "Cache.h"
#import "RMUUid.h"
#import "Cache.h"

@interface SignRequest ()

@end

@implementation SignRequest
+ (instancetype)requestWithVersion:(NSString *)version
{
        return [self requestWithVersion:version appID:[AppUnit buldleID]];
}
+ (instancetype)requestWithVersion:(NSString *)version appID:(NSString *)appID
{
        return [self requestWithParams:[self getSignParam:version appID:appID]];
}
+ (NSDictionary *)getSignParam:(NSString *)version appID:(NSString *)appID
{
        // 取值
        NSString * _appID = [appID stringByAppendingString:version];
        NSString *deviceID = [RMUUid getUUid];
        
        UIDevice *device = [UIDevice currentDevice];
        NSDictionary *deviceInfo = @{
                                     @"os_version" : [NSString stringWithFormat:@"%@%@",device.systemName,device.systemVersion],
                                     @"brand" : @"Apple",
                                     @"model" : device.model
                                     };
        NSData *data = [NSJSONSerialization dataWithJSONObject:deviceInfo options:0 error:NULL];
        NSString *deviceInfoStr = [[NSString alloc] initWithData:data encoding:(NSUTF8StringEncoding)];
        
        // 加密
        
        NSDictionary *params = @{
                                 kRequestKeyMethodVersion : [version base64EncodedString],
                                 kRequestKeyApp_ID : _appID.md5String.md5String,
                                 kRequestKeyUUID: deviceID,
                                 kRequestKeyDevice_Info : deviceInfoStr,
                                 kRequestKeySys_Type : kRequestKeyValueSystemType,
                                 kRequestKeyTrace_Id : [AppUnit getAUniqueString],
                                 kRequestKeyUser_ID : NOT_NULL_STRING(LNUserManager.uid, @"0"),
                                 };
        
        return params;
}
- (NSString *)appID
{
        return [AppUnit buldleID];
}
- (id<EncryptProtocol>)encryptTool
{
        return nil;
}
- (Class)contentType
{
        return [SignModel class];
}
- (NSString *)url
{
        return kRequestUrlSign;
}
- (NSMutableDictionary *)defaultParams
{
        return nil;
}

- (BOOL)needCache
{
        return YES;
}

- (BOOL)needSign
{
        return NO;
}

@end
