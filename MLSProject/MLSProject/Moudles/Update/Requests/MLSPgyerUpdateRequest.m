//
//  MLSPgyerUpdateRequest.m
//  MinLison
//
//  Created by MinLison on 2017/11/20.
//  Copyright © 2017年 minlison. All rights reserved.
//
#import "MLSPgyerUpdateRequest.h"

#if WGEnablePgyerSDK

@implementation MLSPgyerUpdateRequest
- (Class)contentType
{
        return [MLSPgyerUpdateModel class];
}
- (NetwrokRequestType)requestType
{
        return NetwrokRequestTypePOST;
}
//- (NetwrokRequestSerializerType)requestSerializerType
//{
//        return NetwrokRequestSerializerTypeJSON;
//}
- (NetwrokResponseSerializerType)responseSerializerType
{
        return NetwrokResponseSerializerTypeJSON;
}
- (BOOL)blockSelfUntilDone
{
        return YES;
}
- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary
{
        [super requestHeaderFieldValueDictionary];
        return @{};
}
- (NSMutableDictionary *)defaultParams
{
        return @{
                 @"appKey" : PGYER_APP_KEY,
                 @"_api_key" : PGYER_API_KEY
                 }.mutableCopy;
}
- (NSString *)baseUrl
{
        return @"https://www.pgyer.com/";
}
- (NSString *)url
{
        return @"apiv2/app/view";
}
- (BOOL)needSign
{
        return NO;
}
- (BOOL)needCache
{
        return NO;
}
- (id<EncryptProtocol>)encryptTool
{
        return nil;
}
@end
#endif
