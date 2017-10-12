//
//  NetworkRequest.m
//  MLSProject
//
//  Created by MinLison on 2017/9/5.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "NetworkRequest.h"
#import "SignRequest.h"
#import "RequestResponseVerify.h"
#import "SignModel.h"
#import <WZProtocolInterceptor/WZProtocolInterceptor.h>
#import "Cache.h"

@interface NetworkRequest () <YTKRequestDelegate>
@property(nonatomic, strong, readwrite) NSMutableDictionary *params;
@property(nonatomic, strong) NSDictionary *encryptParams;
@property(nonatomic, copy) NSString *url;
@property(nonatomic, assign) NetwrokRequestType requestType;
@property(nonatomic, strong) WZProtocolInterceptor *protocolInterceptor;
@property(nonatomic, assign) NSInteger retryCount; // 重试次数
@property(nonatomic, assign,  readwrite) NSInteger failedRetryCount;
@property(nonatomic, assign, getter=isRetrying) BOOL retrying;
@property(nonatomic, copy) YTKRequestCompletionBlock _failedBlock;
@property(nonatomic, copy) YTKRequestCompletionBlock _successBlock;
@property(nonatomic, copy, readwrite, nullable) NSString *decryptResponseString;
@property(nonatomic, copy, readwrite, nullable) id decryptResponseObject;
@property(nonatomic, copy, readwrite, nullable) NSData *decryptResponseData;
@end

@implementation NetworkRequest
- (instancetype)init
{
        self = [super init];
        if (self) {
                self.netwrokRequestSerializerType = NetwrokRequestSerializerTypeHTTP;
                self.netwrokResponseSerializerType = NetwrokResponseSerializerTypeHTTP;
                self.protocolInterceptor = [[WZProtocolInterceptor alloc] initWithInterceptedProtocol:@protocol(YTKRequestDelegate)];
                self.failedRetryMaxCount = 3;
                self.cacheTimesWithSeconds = 60;
        }
        return self;
}

/// MARK: - 拦截回调函数
/// 这里只拦截非服务器的 error code, 比如网络超时等错误, 会重复请求
- (void)setFailureCompletionBlock:(YTKRequestCompletionBlock)failureCompletionBlock
{
        void(^FailedBlock)(__kindof NetworkRequest *request) = ^(__kindof NetworkRequest *request) {
                if (request.error.code != NSURLErrorCancelled && request.retryCount < request.failedRetryMaxCount)
                {
                        request.retryCount++;
                        request.failedRetryCount = request.retryCount;
                        request.retrying = YES;
                }
                else
                {
                        NSLogVerbose(@"--- Fequest Failed -- \n%@\n--- Fequest Failed -- ",self);
                        request.retrying = NO;
                        request.retryCount = 0;
                        
                        if (request._failedBlock)
                        {
                                request._failedBlock(request);
                        }
                }
        };
        self._failedBlock = failureCompletionBlock;
        [super setFailureCompletionBlock:FailedBlock];
}
- (void)setSuccessCompletionBlock:(YTKRequestCompletionBlock)successCompletionBlock
{
        void(^SuccessBlock)(__kindof NetworkRequest *request) = ^(__kindof NetworkRequest *request) {
                
                if ([self isDataFromCache])
                {
                        NSLogVerbose(@"--- Request From Cache Success -- \n%@\n --- Request From Cache Success -- ",self);
                }
                else
                {
                        NSLogVerbose(@"--- Request From Network Success -- \n%@\n--- Request From Network Success -- ",self);
                }
                
                request.retrying = NO;
                request.retryCount = 0;
                
                if (request._successBlock)
                {
                        request._successBlock(request);
                }
        };
        self._successBlock = successCompletionBlock;
        [super setSuccessCompletionBlock:SuccessBlock];
}
- (void)setDelegate:(id<YTKRequestDelegate>)delegate
{
        self.protocolInterceptor.middleMan = self;
        self.protocolInterceptor.receiver = delegate;
        [super setDelegate:(id<YTKRequestDelegate>)self.protocolInterceptor];
}

- (void)requestFailed:(__kindof NetworkRequest *)request
{
        if (request.error.code != NSURLErrorCancelled && request.retryCount < request.failedRetryMaxCount)
        {
                request.retryCount++;
                request.failedRetryCount = request.retryCount;
                request.retrying = YES;
        }
        else
        {
                NSLogVerbose(@"--- Fequest Failed -- \n%@\n--- Fequest Failed -- ",self);
                request.retrying = NO;
                request.retryCount = 0;
                
                if ([self.delegate respondsToSelector:@selector(requestFailed:)])
                {
                        [self.delegate requestFailed:request];
                }
        }
        
}
- (void)requestFinished:(__kindof NetworkRequest *)request
{
        if ([self isDataFromCache])
        {
                NSLogVerbose(@"--- Request From Cache Success -- \n%@\n --- Request From Cache Success -- ",self);
        }
        else
        {
                NSLogVerbose(@"--- Request From Network Success -- \n%@\n--- Request From Network Success -- ",self);
        }
        
        request.retrying = NO;
        request.retryCount = 0;
        
        if ([self.delegate respondsToSelector:@selector(requestFinished:)])
        {
                [self.delegate requestFinished:request];
        }
}
/// MARK: Encrypt and Decrypt
- (NSData *)decryptResponseData
{
        if (!_decryptResponseData)
        {
                if ( self.encryptTool )
                {
                        if ( self.responseData )
                        {
                                _decryptResponseData = [self.encryptTool decryptDataFromResponseData:self.responseData];
                        }
                        else
                        {
                                _decryptResponseData = [self.encryptTool decryptDataFromResponseString:self.responseString];
                        }
                }
                else
                {
                        _decryptResponseData = self.responseData;
                }
        }
        return _decryptResponseData;
}
- (id)decryptResponseObject
{
        if (!_decryptResponseObject)
        {
                if ( self.encryptTool )
                {
                        if ( self.responseData )
                        {
                               _decryptResponseObject = [self.encryptTool decryptObjectFromResponseData:self.responseData];
                        }
                        else
                        {
                                _decryptResponseObject = [self.encryptTool decryptObjectFromResponseString:self.responseString];
                        }
                }
                else
                {
                        _decryptResponseObject = self.responseObject?:(self.responseString?:self.responseData);
                }
        }
        return _decryptResponseObject;
}
- (NSString *)decryptResponseString
{
        if (!_decryptResponseString)
        {
                
                if ( self.encryptTool )
                {
                        if ( self.responseData )
                        {
                                _decryptResponseString = [self.encryptTool decryptStringFromResponseData:self.responseData];
                        }
                        else
                        {
                                _decryptResponseString = [self.encryptTool decryptStringFromResponseString:self.responseString];
                        }
                }
                else
                {
                        _decryptResponseString = self.responseString;
                }
        }
        return _decryptResponseString;
}
/// MARK: - 参数配置
// 懒加载
- (NSMutableDictionary *)params
{
        if (!_params) {
                _params = [[NSMutableDictionary alloc] init];
        }
        return _params;
}
+ (instancetype)request:(NetwrokRequestType)type withParams:(NSDictionary *)params url:(NSString *)url
{
        NetworkRequest *request = [[NetworkRequest alloc] init];
        request.url = url;
        request.requestType = type;
        [request.params addEntriesFromDictionary:params?:@{}];
        request.encryptParams = request.params;
        return request;
}
+ (instancetype)requestWithParams:(NSDictionary *)params url:(NSString *)url
{
        return [self request:(NetwrokRequestTypePOST) withParams:params url:url];
}
+ (instancetype)requestWithParams:(NSDictionary *)params
{
        return [self requestWithParams:params url:kRequestUrlInter];
}
- (void)paramInsert:(id)obj forKey:(NSString *)key
{
        DebugAssert(!self.isExecuting, @"开始请求后, 不允许添加参数");
        [self.params jk_setObj:obj forKey:key];
        [self clearMemoryStoreData];
}

- (void)paramDelForKey:(NSString *)key
{
        DebugAssert(!self.isExecuting, @"开始请求后, 不允许删除参数");
        [self.params removeObjectForKey:key];
        [self clearMemoryStoreData];
}

/// MARK: - 拦截 start 方法, 获取 sign
- (void)start
{
        [self _Start];
}
- (void)_Start
{
        if ( self.encryptTool )
        {
                self.encryptParams = [self.encryptTool encryptParam:self.params];
        }
        [super start];
}

/// MARK:  - 拦截清理回到 block ,防止 retry 的时候, block 丢失
- (void)clearCompletionBlock
{
        // 如果是重试状态, 就直接 start, 不清理 block
        if (self.isRetrying)
        {
                /// 只有整个 reques 结束后, 才能再次发起请求
                NSLogVerbose(@"---Retry Request -- %@ --- Retry Request -- ",self);
                [self start];
                return;
        }
        
        /// 如果是强制不让清理 block, 就 return, 下次在清理
        if ( self.isForceRefuseCleanBlock )
        {
                self.forceRefuseCleanBlock = NO;
                NSLogVerbose(@"--- ForceRefuseCleanBlock -- \n");
                return;
        }
        NSLogVerbose(@"--- ClearCompletionBlock -- \n");
        self._successBlock = nil;
        self._failedBlock = nil;
        [super clearCompletionBlock];
}
- (void)clearMemoryStoreData
{
        _decryptResponseData = nil;
        _decryptResponseObject = nil;
        _decryptResponseString = nil;
}
/// MARK: -- YTKNetwork SubClass Hold
- (nullable id)requestArgument
{
        return self.encryptParams;
}
- (NSTimeInterval)requestTimeoutInterval
{
        return 10.0;
}
- (NSString *)baseUrl
{
        return _baseUrl;
}
- (NSString *)requestUrl
{
        return self.url ?:kRequestUrlInter;
}
- (YTKRequestMethod)requestMethod
{
        return (YTKRequestMethod)self.requestType;
}

- (YTKRequestSerializerType)requestSerializerType
{
        return (YTKRequestSerializerType)(self.netwrokRequestSerializerType);
}

- (YTKResponseSerializerType)responseSerializerType
{
        return (YTKResponseSerializerType)(self.netwrokResponseSerializerType);
}

- (nullable NSArray<NSString *> *)requestAuthorizationHeaderFieldArray
{
        return nil;
}

- (nullable NSDictionary<NSString *, NSString *> *)requestHeaderFieldValueDictionary
{
        return @{
                 @"User-Agent" : [AppUnit userAgentString],
                 @"minlison" : @"2"
                 };
}
- (NSInteger)cacheTimeInSeconds
{
        return self.cacheTimesWithSeconds;
}
- (long long)cacheVersion
{
        return [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] longLongValue];
}
- (id)cacheSensitiveData
{
        return self.encryptParams;
}
- (NSString *)description
{
        /// 失败
        if ( self.error )
        {
                return [NSString stringWithFormat:@"<%@: %p>\n== 失败 ==\n接口===%@%@\n参数===%@\n加密后参数===%@\n错误信息===%@\n内容===%@\n重试次数===%d\n", NSStringFromClass([self class]), self,self.baseUrl,self.url,self.params,self.encryptParams,self.error,self.responseString,(int)self.failedRetryCount];
        }
        /// 成功
        if ( [self isDataFromCache] )
        {
                return [NSString stringWithFormat:@"<%@: %p>\n== 缓存内容 ==\n接口===%@%@\n参数===%@\n内容===%@\n重试次数===%d\n", NSStringFromClass([self class]), self,self.baseUrl,self.url,self.params,self.decryptResponseString,(int)self.failedRetryCount];
        }
        return [NSString stringWithFormat:@"<%@: %p>\n== 网络内容 ==\n接口===%@%@\n参数===%@\n加密后参数===%@\n内容===%@\n重试次数===%d\n", NSStringFromClass([self class]), self,self.baseUrl,self.url,self.params,self.encryptParams,self.decryptResponseString,(int)self.failedRetryCount];
}
- (NSString *)debugDescription
{
        return self.description;
}
@end



