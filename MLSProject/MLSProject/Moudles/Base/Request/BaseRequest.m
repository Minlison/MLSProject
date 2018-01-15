//
//  BaseRequest.m
//  MinLison
//
//  Created by MinLison on 2017/8/31.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseRequest.h"
#import "AppUnit.h"
#import "EncryptTool.h"
#import "RequestResponseVerify.h"
#import "MLSSignManager.h"
#import "RMUUid.h"
#import "BaseRequestEngine.h"
#import "MLSRefreshTokenRequest.h"
#import "MLSYardModel.h"
@interface BaseRequest (Sign)
- (NSString *)getCacheSign;
- (void)storeCacheSign:(NSString *)sign;
- (void)cleanCacheSign;
@end


#define REQUEST_GET_SIGN_MAX_COUNT 3
#define REQUEST_REFRESH_TOKEN_COUNT 3
@interface BaseRequest <__covariant ContentType> () 
@property(nonatomic, strong, readwrite) NSMutableDictionary *params;
@property(nonatomic, readwrite, strong) NetworkRequest *request;
@property(nonatomic, assign) NSInteger getSignCount;
@property(nonatomic, assign) NSInteger refreshTokenCount;
@property(nonatomic, copy) NSString *sign;
@property(nonatomic, assign, getter=isCacheSign) BOOL cacheSign;
@property(nonatomic, strong) SignRequest *signRequest;
@property(nonatomic, strong) MLSRefreshTokenRequest *refreshTokenRequest;
@property(nonatomic, assign) NSInteger currentPageNumber;
@property(nonatomic, copy) RequestSuccessBlock groupInterSuccess;
@property(nonatomic, copy) RequestFailedBlock groupInterFailed;
@property(nonatomic, copy, readwrite) NSString *uuid;
@property(nonatomic, assign, readwrite, getter=isExecuting) BOOL executing;
@property(nonatomic, assign) BOOL needRefreshToken;
@property(nonatomic, copy, readwrite) NSString *tipString;
@property(nonatomic, strong) BaseRequest *strongSelf;
@end

@implementation BaseRequest

/// MARK: - Public Method
- (void)start
{
        if ([self blockSelfUntilDone])
        {
                self.strongSelf = self;
        }
        if (self.groupRequests)
        {
                [self.groupRequests startRequestWithSuccess:self.groupSuccessCallBack failed:self.groupFailedCallBack];
        }
        else
        {
                DebugAssert(!self.executing, @"request 正在执行");
                
                self.executing = YES;
                
                [BaseRequestEngine startRequest:self];
                /// needRefreshToken 优先级最高
                if (self.needRefreshToken)
                {
                        [self _ResetRefreshTokenCallBack];
                        [self.refreshTokenRequest start];
                }
                else if ( [self needSign] && ![self getCacheSign])
                {
                        [self _ResetSignCallBack];
                        [self.signRequest start];
                }
                else
                {
                        [self _Start];
                }
        }
}

- (void)_Start
{
        [self _ResetRequestCallBack];
        
        if ( [self needCache] && !self.ignoreCache )
        {
                [self.request start];
        }
        else
        {
                [self.request startWithoutCache];
        }
}

- (void)startWithSuccess:(RequestSuccessBlock)success failed:(RequestFailedBlock)failed
{
        self.successCallBack = success;
        self.failedCallBack = failed;
        [self start];
}
- (void)groupStartWithSuccess:(GroupRequestSuccessBlock)success failed:(GroupRequestFailedBlock)failed
{
        self.groupSuccessCallBack = success;
        self.groupFailedCallBack = failed;
        [self start];
}
- (void)groupInterSuccess:(RequestSuccessBlock)success failed:(RequestFailedBlock)failed
{
        self.groupInterSuccess = success;
        self.groupInterFailed = failed;
        [self start];
}
- (void)stopWithError:(NSError *)error
{
        if (self.failedCallBack)
        {
                self.failedCallBack(self, error);
        }
        if (self.groupInterFailed)
        {
                self.groupInterFailed(self, error);
        }
        [self stop];
}
- (void)stop
{
        [self.signRequest stop];
        [self.request stop];
        [self.refreshTokenRequest stop];
        [self cleanBlocks];
}
- (void)cleanBlocks
{
        self.strongSelf = nil;
        self.failedCallBack = nil;
        self.successCallBack = nil;
        self.groupInterFailed = nil;
        self.groupInterSuccess = nil;
        [self.signRequest.request clearCompletionBlock];
        [self.request clearCompletionBlock];
        [self.refreshTokenRequest.request clearCompletionBlock];
        self.executing = NO;
        self.needRefreshToken = NO;
        self.refreshTokenCount = 0;
        self.getSignCount = 0;
        [BaseRequestEngine finishRequest:self];
}
/// MARK: - Init Method
- (instancetype)init
{
        return [self initWithParams:nil];
}
- (instancetype)initWithParams:(NSDictionary *)params
{
        if (self = [super init])
        {
                self.params = [[NSMutableDictionary alloc] init];
                self.currentPageNumber = [self startPageNum];
                if (params)
                {
                        [self.params addEntriesFromDictionary:params];
                }
                NSMutableDictionary *defaultParams = [self defaultParams];
                if (defaultParams)
                {
                        [self.params addEntriesFromDictionary:defaultParams];
                }
        }
        return self;
}

+ (instancetype)requestWithParams:(nullable NSDictionary *)params
{
        return [[self alloc] initWithParams:params];
}
- (void)paramInsert:(id)obj forKey:(NSString *)key
{
        if (obj && key)
        {
                [self.params jk_setObj:obj forKey:key];
        }
        [self.request paramInsert:obj forKey:key];
}

- (void)paramDelForKey:(NSString *)key
{
        if (key)
        {
                [self.params removeObjectForKey:key];
        }
        [self.request paramDelForKey:key];
}
- (void)requestError:(NSError *)error
{
        
}
- (void)requestSuccess
{
        
}
- (instancetype)pullUp
{
        self.currentPageNumber = self.currentPageNumber + 1;
        
        [self paramInsert:@(self.currentPageNumber) forKey:self.pageKey];
        [self paramInsert:@(0) forKey:self.startPositionKey];
        return self;
}
- (instancetype)pullDown
{
        self.currentPageNumber = [self startPageNum];
        
        [self paramInsert:@(self.currentPageNumber) forKey:self.pageKey];
        [self paramInsert:@(self.startPosition) forKey:self.startPositionKey];
        return self;
}
- (void)clearCache
{
        [self.request clearCache];
        [self.signRequest clearCache];
        [self.refreshTokenRequest clearCache];
}
/// MARK: - LazyMethod
- (NetworkRequest *)request
{
        if ( _request == nil )
        {
                _request = [NetworkRequest request:[self requestType] withParams:self.params url:[self url]];
                _request.netwrokRequestSerializerType = [self requestSerializerType];
                _request.netwrokResponseSerializerType = [self responseSerializerType];
                _request.failedRetryMaxCount = [self maxRetryCount];
                _request.appID = [self appID];
        }
        _request.ignoreCache = ![self needCache];
        _request.encryptTool = [self encryptTool];
        _request.baseUrl = [self baseUrl];
        _request.subClassHoldertDelegate = self;
        return _request;
}
- (SignRequest *)signRequest
{
        if (_signRequest == nil && [self needSign])
        {
                NSString *version = [self methodVersion];
                DebugAssert(version != nil, @"方法版本号没有设置");
                _signRequest = [SignRequest requestWithVersion:version appID:self.appID?:[AppUnit buldleID]];
        }
        return _signRequest;
}
- (MLSRefreshTokenRequest *)refreshTokenRequest
{
        if (_refreshTokenRequest == nil && self.needRefreshToken) {
                NSString *version = [self methodVersion];
                DebugAssert(version != nil, @"方法版本号没有设置");
                _refreshTokenRequest = [MLSRefreshTokenRequest requestWithParams:nil];
        }
        return _refreshTokenRequest;
}
- (NSString *)uuid
{
        if (!_uuid) {
                NSString *encodeString = [self.params jk_URLQueryStringWithSortedKeys:YES].md5String ?: self.request.cacheIdentifier;
                _uuid = [encodeString stringByAppendingFormat:@"%@_%@",self.baseUrl,self.url].md5String;
        }
        return _uuid;
}
- (NSString *)pageKey
{
        if (!_pageKey)
        {
                _pageKey = kRequestKeyPage;
        }
        return _pageKey;
}

- (NSString *)pageLimitKey
{
        if (!_pageLimitKey) {
                _pageLimitKey = kRequestKeyLimit;
        }
        return _pageLimitKey;
}

- (NSInteger)startPageNum
{
        if (_startPageNum <= 0)
        {
                _startPageNum = 1;
        }
        return _startPageNum;
}

- (NSString *)startPositionKey
{
        if (!_startPositionKey) {
                _startPositionKey = kRequestKeyStart_Position;
        }
        return _startPositionKey;
}

- (NSInteger)startPosition
{
        if (_startPosition < 0)
        {
                _startPosition = 0;
        }
        return _startPosition;
}

/// MARK: - Setter
- (void)setConstructingBodyBlock:(AFConstructingBlock)constructingBodyBlock
{
        [self.request setConstructingBodyBlock:constructingBodyBlock];
}

- (AFConstructingBlock)constructingBodyBlock
{
        return self.request.constructingBodyBlock;
}
/// MARK: -Getter
- (NSString *)tipString
{
        if (self.serverRootModel) {
                return self.serverRootModel.msg;
        }
        return self.request.error.localizedDescription;
}
- (dispatch_queue_t)callBackQueue
{
        if (_callBackQueue == nil) {
                _callBackQueue = dispatch_get_main_queue();
        }
        return _callBackQueue;
}
/// MARK: - Private Method
- (void)_CallBackInner
{
        [self _CompleteWithError:self.request.error];
}

- (void)_CallBlockWithModel:(id)model error:(NSError *)error
{
        @weakify(self);
        void(^CallBackBlock)(id model ,NSError *error) = ^(id model, NSError *error) {
                @strongify(self);
                
                if (error)
                {
                        NSLogError(@"%@",self);
                        
                        NSError *appError = error;
                        
                        if ( error.domain == YTKRequestCacheErrorDomain || error.domain == YTKRequestValidationErrorDomain )
                        {
                                appError = [NSError appErrorWithCode:APP_ERROR_CODE_ERR msg:[NSString app_NeworkError] remark:[NSString app_NeworkError]];
                        }
                        
                        /// 清楚当前 request 的缓存
                        [self.request clearCache];
//                        [self.signRequest clearCache];
//                        [self.refreshTokenRequest clearCache];
                        
//                        /// 重新获取签名
//                        if (error.code == APP_ERROR_CODE_SIGN_ERROR && self.getSignCount < REQUEST_GET_SIGN_MAX_COUNT && [self needSign] && ![self isKindOfClass:[SignRequest class]])
//                        {
//                                self.getSignCount++;
//                                [self restartWithRegetSign];
//                                return;
//                        }
//                        // 重新刷新 token
//                        // token 失效， token 错误， 获取次数在范围内， 并且当前不是 refreshToken 在请求
//                        else
                        if ((error.code == APP_ERROR_CODE_TOKEN_OUTTIME) && ( self.refreshTokenCount < REQUEST_REFRESH_TOKEN_COUNT ))
                        {
//                                if ( [self isKindOfClass:[MLSRefreshTokenRequest class]] )
//                                {
                                        [self _LogoutAndStopWithError:appError];
//                                }
//                                else
//                                {
//                                        self.refreshTokenCount++;
//                                        [self restartWithRefreshToken];
//                                }
                                return;
                        }
                        /// refresh Token 过期，需要重新登录
//                        else if (error.code == APP_ERROR_CODE_REFRESH_TOKEN_PASSDATE)
//                        {
//                                [self _LogoutAndStopWithError:appError];
//                                return;
//                        }
                        
                        /// 失败以后，如果当前的页码不是初始页码，那么就要减 1 恢复上次的刷新界面，防止下次刷新失败
                        if (self.currentPageNumber > self.startPageNum)
                        {
                                self.currentPageNumber -= 1;
                        }
                        dispatch_async(self.callBackQueue, ^{
                                
                                [self requestError:appError];
                                
                                if (self.failedCallBack)
                                {
                                        self.failedCallBack(self, appError);
                                }
                                
                                if (self.groupInterFailed)
                                {
                                        self.groupInterFailed(self, appError);
                                }
                                [self cleanBlocks];
                                
                        });
                }
                else
                {
                        NSLogDebug(@"%@",self);
                        dispatch_async(self.callBackQueue, ^{
                                
                                [self requestSuccess];
                                
                                if (self.successCallBack)
                                {
                                        self.successCallBack(self, model);
                                }
                                
                                if (self.groupInterSuccess)
                                {
                                        self.groupInterSuccess(self, model);
                                }
                                [self cleanBlocks];
                        });
                }
        };
        
        id<InterceptorProtocol> interceptor = [self interceptor];
        
        if (interceptor)
        {
                [interceptor verify:self.serverRootModel completion:^(BOOL valid, NSError *error) {
                        CallBackBlock(model,error);
                }];
        }
        else
        {
                CallBackBlock(model,error);
        }
}

- (void)_CompleteWithError:(NSError *)error
{
        if (error)
        {
                [self _CallBlockWithModel:nil error:error];
        }
        else
        {
                [RequestResponseVerify verifyRequest:self.request contentType:[self contentType] contentKeyPath:[self contentKeyPath] completion:^(ServerModel *serverModel, id data, NSError *error) {
                        self.serverRootModel = serverModel;
                        self.serverRootModel.modelContent = [self _GetArrayModelOrSingleModelFormContent:serverModel.modelContent];
                        [self _CallBlockWithModel:self.serverRootModel.modelContent error:error];
                }];
        }
}
- (id)_GetArrayModelOrSingleModelFormContent:(id)content
{
        if (!content)
        {
                return nil;
        }
        if ( [self contentIsArray] )
        {
                if ( [content isKindOfClass:[NSArray class]] )
                {
                        return content;
                }
                else
                {
                        return @[content];
                }
        }
        else
        {
                if ( [content isKindOfClass:[NSArray class]] )
                {
                        return [(NSArray *)content firstObject];
                }
                else
                {
                        return content;
                }
        }
        return nil;
}
- (void)_ResetRequestCallBack
{
        self.request.forceRefuseCleanBlock = YES;
        @weakify(self);
        self.request.successCompletionBlock = ^(__kindof YTKRequest * _Nonnull request) {
                @strongify(self);
                [self _CompleteWithError:nil];
        };
        self.request.failureCompletionBlock = ^(__kindof YTKBaseRequest * _Nonnull request) {
                @strongify(self);
                [self _CompleteWithError:request.error];
        };
}
- (void)_ResetSignCallBack
{
        self.signRequest.request.forceRefuseCleanBlock = YES;
        @weakify(self);
        [self.signRequest setSuccessCallBack:^(__kindof BaseRequest * _Nonnull request, __kindof SignModel * _Nonnull data) {
                @strongify(self);
                /// 获取签名成功, 则加密开始请求
                [self storeCacheSign:data.key];
                [self _Start];
        }];
        [self.signRequest setFailedCallBack:^(__kindof BaseRequest * _Nonnull request, NSError * _Nonnull error) {
                @strongify(self);
                /// 获取签名错误, 直接 stop
                [self stopWithError:error];
        }];
}
- (void)_ResetRefreshTokenCallBack
{
        self.refreshTokenRequest.request.forceRefuseCleanBlock = YES;
        @weakify(self);
        [self.refreshTokenRequest setSuccessCallBack:^(__kindof BaseRequest * _Nonnull request, __kindof MLSUserModel * _Nonnull data) {
                @strongify(self);
                
                /// 刷新 token， data 只有 token 有值
                if (!NULLString(data.token))
                {
                        LNUserManager.token = data.token;
                        self.needRefreshToken = NO;
                        /// 更新 token
                        [self paramInsert:data.token forKey:kRequestKeyToken];
                        [self _Start];
                }
                else
                {
                        [self _LogoutAndStopWithError:nil];
                }
        }];
        
        [self.refreshTokenRequest setFailedCallBack:^(__kindof BaseRequest * _Nonnull request, NSError * _Nonnull error) {
                @strongify(self);
                /// 刷新 token 失败
                [self stopWithError:error];
//                [self _LogoutAndStopWithError:error];
        }];
}
- (void)_LogoutAndStopWithError:(NSError *)error
{
        [self paramInsert:@"" forKey:kRequestKeyToken];
        @weakify(self);
        [LNUserManager logOut:nil success:^(NSString * _Nonnull sms) {
                @strongify(self);
                [self stopWithError:error?:[NSError appErrorWithCode:APP_ERROR_CODE_ERR msg:[NSString app_NeworkError] remark:sms]];
                self.needRefreshToken = NO;
                self.refreshTokenCount = 0;
                /// 弹出登录界面
                [LNUserManager pushOrPresentLoginIfNeed:YES inViewController:nil completion:nil dismiss:nil];
        } failed:^(NSError * _Nonnull error) {
                @strongify(self);
                [self stopWithError:error];
                self.needRefreshToken = NO;
                self.refreshTokenCount = 0;
        }];
}
- (void)restartWithRegetSign
{
        [self.signRequest clearCache];
        [self cleanCacheSign];
        self.request.ignoreCache = YES;
        self.signRequest.ignoreCache = YES;
        self.executing = NO;
        [self start];
}

- (void)restartWithRefreshToken
{
        [self.refreshTokenRequest clearCache];
        self.needRefreshToken = YES;
        [self cleanCacheSign];
        self.request.ignoreCache = YES;
        self.signRequest.ignoreCache = YES;
        self.refreshTokenRequest.ignoreCache = YES;
        self.executing = NO;
        [self start];
}

- (void)startWithNocache
{
        self.ignoreCache = YES;
        [self start];
}


/// MARK: - SubClass Holder
- (Class)contentType
{
//        NSString *requesClassName = NSStringFromClass([self class]);
//        requesClassName =  [requesClassName stringByReplacingOccurrencesOfString:@"Request" withString:@"Model"];
//        return NSClassFromString(requesClassName);
        return nil;
}
- (NSString *)contentKeyPath
{
        return @"data";
}
- (BOOL)contentIsArray
{
        return NO;
}

- (NSString *)baseUrl
{
        return [YTKNetworkConfig sharedConfig].baseUrl;
}
- (NSString *)url
{
        return @"";
}
- (NSString *)methodVersion
{
        return @"";
}
- (NSString *)methodValue
{
        return @"";
}
- (NSString *)appID
{
        return [AppUnit buldleID];
}

- (NSMutableDictionary *)defaultParams
{
        NSMutableDictionary *paramsM = [NSMutableDictionary dictionary];
        /// 默认的一些参数
        [paramsM setObject:[RMUUid getUUid] forKey:kRequestKeyUUID];
//        [paramsM jk_setObj:kRequestKeyValueSystemType forKey:kRequestKeySys_Type];
        [paramsM jk_setObj:@([AppUnit currentNetworkStatus]) forKey:kRequestKeyNetType];
//        [paramsM jk_setObj:[AppUnit versionNumberString] forKey:kRequestKeyApp_Version_Code];
//        [paramsM jk_setObj:NOT_NULL_STRING(LNUserManager.uid, @"0") forKey:kRequestKeyUser_ID];
//        [paramsM jk_setObj:NOT_NULL_STRING(LNUserManager.token, @"") forKey:kRequestKeyToken];
        
        /// 页码
        [paramsM jk_setObj:@(self.currentPageNumber) forKey:self.pageKey];
        [paramsM jk_setObj:@(self.startPosition) forKey:self.startPositionKey];
        [paramsM jk_setObj:@(self.pageLimitCount) forKey:self.pageLimitKey];
        
        // 位置信息
        [paramsM jk_setObj:LNUserManager.longitude forKey:kRequestKeyLng];
        [paramsM jk_setObj:LNUserManager.latitude forKey:kRequestKeyLat];
        [paramsM jk_setObj:LNUserManager.token forKey:kRequestKeyToken];
        // 最近园区信息
        [paramsM jk_setObj:LNUserManager.currentYardModel.area_id forKey:kRequestKeyAreaID];

        return paramsM;
}


- (BOOL)needSign
{
        return NO;
}

- (BOOL)needCache
{
        return YES;
}
- (BOOL)blockSelfUntilDone
{
        return YES;
}
- (NSInteger)maxRetryCount
{
        return 3;
}

- (id<EncryptProtocol>)encryptTool
{
        return nil;
}

- (id<InterceptorProtocol>)interceptor
{
        return nil;
}
//// 网络请求方法
- (NetwrokRequestType)requestType
{
        return NetwrokRequestTypePOST;
}

- (NetwrokRequestSerializerType)requestSerializerType
{
        return NetwrokRequestSerializerTypeHTTP;
}

- (NetwrokResponseSerializerType)responseSerializerType
{
        return NetwrokResponseSerializerTypeJSON;
}
- (nullable NSSet <NSString *>*)acceptableContentTypes
{
        return [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain",@"text/xml",@"image/*", nil];
}
- (nullable NSString *)queryStringSerializationRequest:(NSURLRequest *)request param:(NSDictionary *)param error:(NSError **)error
{
        NSString *token = [param jk_stringForKey:kRequestKeyToken];
        
        NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithDictionary:param];
        [dictM removeObjectForKey:kRequestKeyToken];
        
        NSString *queryStr = [NSString stringWithFormat:@"%@&token=%@",AFQueryStringFromParameters(dictM),token];
        
        return queryStr;
}
- (NSUInteger)cacheTimeInSeconds
{
        return 600; // 10 min
}
- (NSTimeInterval)requestTimeoutInterval
{
        return 10.0;
}
- (NSDictionary *)requestParams
{
        NSMutableDictionary *defaultParams = [self defaultParams];
        if (defaultParams)
        {
                [self.params addEntriesFromDictionary:defaultParams];
        }
        return self.params;
}
- (nullable NSArray<NSString *> *)requestAuthorizationHeaderFieldArray
{
        return nil;
}
- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary
{
        if (LNUserManager.isLogin)
        {
                return @{
                         @"Authorization" : [NSString stringWithFormat:@"Bearer %@",LNUserManager.token]
                         };
        }
        return @{};
        
}
- (NSString *)description
{
        if ( [self needSign] )
        {
                if (self.isCacheSign)
                {
                        return [NSString stringWithFormat:@"{<%@: %p>\n重新获取 token 的次数%d\n网络请求==%@\n签名使用缓存==%@\n }",NSStringFromClass([self class]),self,(int)self.refreshTokenCount,self.request,self.sign];
                }
                return [NSString stringWithFormat:@"{<%@: %p>\n重新获取签名的次数%d\n重新获取 token 的次数%d\n网络请求==%@\n签名使用网络接口==%@\n签名获取请求==%@}",NSStringFromClass([self class]),self,(int)self.getSignCount,(int)self.refreshTokenCount,self.request,self.sign,self.signRequest];
        }
        return [NSString stringWithFormat:@"{<%@: %p>\n普通网络请求==%@}",NSStringFromClass([self class]),self,self.request];
}
- (void)dealloc
{
        NSLogDebug(@"-----Request Dealloc %@---",NSStringFromClass([self class]));
}
@end


@implementation BaseRequest(Sign)

- (NSString *)getCacheSign
{
        NSString *sign = (NSString *)[MLSSignManager getSignForVersion:self.params.versionValue];
        self.sign = sign;
        self.cacheSign = (sign != nil);
        return self.sign;
}
- (void)storeCacheSign:(NSString *)sign
{
        self.sign = sign;
        [MLSSignManager storeSign:sign forVersion:self.params.versionValue];
}
- (void)cleanCacheSign
{
        self.sign = nil;
        [MLSSignManager cleanSignForVersion:self.params.versionValue];
}
@end
