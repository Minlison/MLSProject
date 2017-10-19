//
//  BaseRequest.m
//  MLSProject
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

@interface BaseRequest (Sign)
- (NSString *)getCacheSign;
- (void)storeCacheSign:(NSString *)sign;
- (void)cleanCacheSign;
@end


#define REQUEST_GET_SIGN_MAX_COUNT 3

@interface BaseRequest <__covariant ContentType> ()
@property(nonatomic, strong, readwrite) NSMutableDictionary *params;
@property(nonatomic, readwrite, strong) NetworkRequest *request;
@property(nonatomic, assign) NSInteger getSignCount;
@property(nonatomic, copy) NSString *sign;
@property(nonatomic, assign, getter=isCacheSign) BOOL cacheSign;
@property(nonatomic, strong) SignRequest *signRequest;
@property(nonatomic, assign) NSInteger currentPageNumber;
@property(nonatomic, copy) RequestSuccessBlock groupInterSuccess;
@property(nonatomic, copy) RequestFailedBlock groupInterFailed;
@end

@implementation BaseRequest

/// MARK: - Public Method
- (void)start
{
        DebugAssert(!self.request.isExecuting, @"request 正在执行");
        
        if ( [self needSign] && ![self getCacheSign])
        {
                [self _ResetSignCallBack];
                [self.signRequest start];
        }
        else
        {
                [self _Start];
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
        [self stop];
}
- (void)stop
{
        [self.signRequest stop];
        [self.request stop];
        [self cleanBlocks];
}
- (void)cleanBlocks
{
        self.failedCallBack = nil;
        self.successCallBack = nil;
        self.groupInterFailed = nil;
        self.groupInterSuccess = nil;
        [self.signRequest.request clearCompletionBlock];
        [self.request clearCompletionBlock];
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
                
                NSMutableDictionary *defaultParams = [self defaultParams];
                if (params)
                {
                        [self.params addEntriesFromDictionary:params];
                }
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

/// MARK: - LazyMethod
- (NetworkRequest *)request
{
        if ( _request == nil )
        {
                _request = [NetworkRequest request:[self requestType] withParams:self.params url:[self url]];
                _request.ignoreCache = ![self needCache];
                _request.netwrokRequestSerializerType = [self requestSerializerType];
                _request.netwrokResponseSerializerType = [self responseSerializerType];
                _request.encryptTool = [self encryptTool];
                _request.baseUrl = [self baseUrl];
                _request.failedRetryMaxCount = [self maxRetryCount];
                _request.appID = [self appID];
        }
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

- (instancetype)pullUp
{
        self.currentPageNumber = self.currentPageNumber + 1;
        [self.params setObject:@(self.currentPageNumber) forKey:self.pageKey];
        [self.params setObject:@(0) forKey:self.startPositionKey];
        
        [self.request paramInsert:@(self.currentPageNumber) forKey:self.pageKey];
        [self.request paramInsert:@(0) forKey:self.startPositionKey];
        return self;
}
- (instancetype)pullDown
{
        self.currentPageNumber = [self startPageNum];
        [self.params jk_setObj:@(self.currentPageNumber) forKey:self.pageKey];
        [self.params jk_setObj:@(0) forKey:self.startPositionKey];
        
        [self.request paramInsert:@(self.currentPageNumber) forKey:self.pageKey];
        [self.request paramInsert:@(self.startPosition) forKey:self.startPositionKey];
        return self;
}
- (NSString *)pageKey
{
        if (!_pageKey)
        {
                _pageKey = kRequestKeyPage;
        }
        return _pageKey;
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
                _startPositionKey = kRequestKeyPosition;
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

/// MARK: - SubClass Holder
- (Class)contentType
{
        return nil;
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
        return kRequestUrlInter;
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
        [paramsM jk_setObj:[self methodValue] forKey:kRequestKeyMethod];
        [paramsM jk_setObj:[self methodVersion] forKey:kRequestKeyMethodVersion];
        [paramsM jk_setObj:kRequestKeyValueSystemType forKey:kRequestKeySysType];
        [paramsM jk_setObj:@([AppUnit currentNetworkStatus]) forKey:kRequestKeyNetType];
        [paramsM jk_setObj:[AppUnit versionNumberString] forKey:kRequestKeyAppVersionCode];
        [paramsM jk_setObj:MLSUserManager.user_id forKey:kRequestKeyUserID];
        /// 页码
        [paramsM jk_setObj:@(self.currentPageNumber) forKey:self.pageKey];
        [paramsM jk_setObj:@(self.startPosition) forKey:self.startPositionKey];
        return paramsM;
}


- (BOOL)needSign
{
        return YES;
}

- (BOOL)needCache
{
        return YES;
}
- (NSInteger)maxRetryCount
{
        return 3;
}

- (id<EncryptProtocol>)encryptTool
{
        return [EncryptTool sharedInstance];
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
        return NetwrokResponseSerializerTypeHTTP;
}
- (NSUInteger)cacheTimeInSeconds
{
        return 600; // 10 min
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
                        /// 重新获取签名
                        if (error.code == APP_ERROR_CODE_SIGN_ERROR && self.getSignCount < REQUEST_GET_SIGN_MAX_COUNT && [self needSign])
                        {
                                self.getSignCount++;
                                [self restartWithRegetSign];
                                return;
                        }
                        
                        NSLogError(@"%@",self);
                        
                        NSError *appError = error;
                        
                        if ( error.domain == YTKRequestCacheErrorDomain || error.domain == YTKRequestValidationErrorDomain )
                        {
                                appError = [NSError appErrorWithCode:APP_ERROR_CODE_ERR msg:[NSString app_NeworkError] remark:[NSString app_NeworkError]];
                        }
                        
                        self.getSignCount = 0;
                        
                        if (self.failedCallBack)
                        {
                                self.failedCallBack(self, appError);
                        }
                        
                        if (self.groupInterFailed)
                        {
                                self.groupInterFailed(self, appError);
                        }
                        
                        [self cleanBlocks];
                }
                else
                {
                        NSLogDebug(@"%@",self);
                        
                        self.getSignCount = 0;
                        
                        if (self.successCallBack)
                        {
                                self.successCallBack(self, model);
                        }
                        
                        if (self.groupInterSuccess)
                        {
                                self.groupInterSuccess(self, model);
                        }
                        [self cleanBlocks];
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
                [RequestResponseVerify verifyRequest:self.request contentType:[self contentType] completion:^(ServerModel *serverModel, id data, NSError *error) {
                        self.serverRootModel = serverModel;
                        [self _CallBlockWithModel:[self _GetArrayModelOrSingleModelFormContent:data] error:error];
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
- (void)restartWithRegetSign
{
        [self cleanCacheSign];
        self.request.ignoreCache = YES;
        self.signRequest.ignoreCache = YES;
        [self start];
}

- (void)startWithNocache
{
        self.ignoreCache = YES;
        [self start];
}
- (NSString *)description
{
        if ( [self needSign] )
        {
                if (self.isCacheSign)
                {
                        return [NSString stringWithFormat:@"<%@: %p>\nSign Use Cache==%@\nRequest==%@",NSStringFromClass([self class]),self,self.sign,self.request];
                }
                return [NSString stringWithFormat:@"<%@: %p>\nnSign Use Network==%@\nSign Request==%@\nRequest==%@",NSStringFromClass([self class]),self,self.sign,self.signRequest,self.request];
        }
        return [NSString stringWithFormat:@"<%@: %p>\nNot Need Sign Request==%@",NSStringFromClass([self class]),self,self.request];
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
