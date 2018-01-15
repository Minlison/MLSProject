//
//  BaseRequest.h
//  MinLison
//
//  Created by MinLison on 2017/8/31.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "EncryptProtocol.h"
#import "BaseModel.h"
#import "NetworkRequest.h"
#import "ServerModel.h"
#import "InterceptorProtocol.h"
#import "NSArray+Request.h"
#import <AFNetworking/AFNetworking.h>
NS_ASSUME_NONNULL_BEGIN
@interface BaseRequest <__covariant ContentType> : NSObject <NetworkRequesSubClassHoldertDelegate>

typedef void (^RequestSuccessBlock)(__kindof BaseRequest *request, __kindof ContentType data);
typedef void (^RequestFailedBlock)(__kindof BaseRequest *request, NSError *error);

/**
 是否正在执行中
 */
@property(nonatomic, assign, readonly, getter=isExecuting) BOOL executing;

/**
 网络返回的数据
 */
@property(nonatomic, strong, nullable) ContentType data;


/**
 HTTP Post 上传文件 AFN block
 */
@property (nonatomic, copy, nullable) AFConstructingBlock constructingBodyBlock;

/**
 请求参数
 会拼接,默认参数了创建时请求的参数
 */
@property(nonatomic, strong, readonly) NSMutableDictionary *params;

/**
 三方请求
 */
@property(nonatomic, readonly, strong, nonnull) NetworkRequest *request;

/**
 唯一标识符
 */
@property(nonatomic, copy, readonly, nonnull) NSString *uuid;

/**
 服务器返回的 根数据结构
 */
@property(nonatomic, strong, nullable) ServerModel *serverRootModel;

/**
 提示消息，无论是成功还是失败，都会有对应的提示消息
 */
@property(nonatomic, copy, readonly) NSString *tipString;

/**
 回调队列，默认是在主线程
 */
@property(nonatomic, assign) dispatch_queue_t callBackQueue;

/**
 成功回调
 */
@property(nonatomic, copy, nullable) RequestSuccessBlock successCallBack;

/**
 失败回调
 */
@property(nonatomic, copy, nullable) RequestFailedBlock failedCallBack;


/**
 成功回调
 */
@property(nonatomic, copy, nullable) GroupRequestSuccessBlock groupSuccessCallBack;

/**
 失败回调
 */
@property(nonatomic, copy, nullable) GroupRequestFailedBlock groupFailedCallBack;

/**
 忽略错误
 在进行一组访问的时候, 这个请求的错误信息不影响成功回调
 */
@property(nonatomic, assign) BOOL groupIgnoreError;

/**
 忽略缓存
 */
@property(nonatomic, assign) BOOL ignoreCache;

/**
 创建 request
 @param params 参数
 @return  request
 */
- (instancetype)initWithParams:(nullable NSDictionary *)params NS_DESIGNATED_INITIALIZER;
+ (instancetype)requestWithParams:(nullable NSDictionary *)params;


/**
 开始
 */
- (void)start;

/**
 开始
 
 @param success 成功回调
 @param failed 失败回调
 */
- (void)startWithSuccess:(nullable RequestSuccessBlock)success failed:(nullable RequestFailedBlock)failed;

/**
 只有 groupRequests 返回不为空的时候，才能调用该方法

 @param success 完全成功回调
 @param failed 失败回调 根据 request.groupIgnoreError 判断是否在一个 request 失败后，直接回调 failed 不回调 success
 */
- (void)groupStartWithSuccess:(nullable GroupRequestSuccessBlock)success failed:(nullable GroupRequestFailedBlock)failed;

/**
 停止
 */
- (void)stop;

/// MARK: - Refresh 刷新

/**
 上拉加载
 页码加 1
 position 为 0
 @return request
 */
- (instancetype)pullUp;

/**
 下拉刷新
 页码为初始页码
 position 为初始 position
 @return request
 */
- (instancetype)pullDown;

/**
 清楚缓存
 */
- (void)clearCache;

/// MARK: Refresh SubClass Hold Or Set
/**
 刷新页码的参数名  @"#pageKey#" : @(1)
 默认是 @"page"
 */
@property(nonatomic, copy) NSString *pageKey;

/**
 起始页码编号
 默认为1
 */
@property(nonatomic, assign) NSInteger startPageNum;

/**
 开始位置的参数名  @"#startPositionKey#" : @(1)
 默认是 @"position"
 */
@property(nonatomic, copy) NSString *startPositionKey;

/**
 每页获取数量
 默认 @"limit"
 */
@property(nonatomic, copy) NSString *pageLimitKey;

/**
 每页获取数量 pageLimitKey 的 value
 */
@property(nonatomic, assign) NSInteger pageLimitCount;

/**
 开始的起点数量
 */
@property(nonatomic, assign) NSInteger startPosition;

/// MARK: -Group Requests 优先级最高
@property(nonatomic, strong) NSArray <BaseRequest *>*groupRequests;

/// MARK: - SubClass Holde
/**
 加密解密工具
 如果返回 nil, 则属于不加密
 默认 [EncryptTool shareInstance]
 @return 加密解密工具
 */
- (nullable id <EncryptProtocol> )encryptTool;

/**
 网络请求内容 class
 */
- (Class)contentType;

/**
 对应 contentType 的服务器返回数据模型中的 keyPath 默认是 data

 @return keyPath
 */
- (NSString *)contentKeyPath;

/**
 内容是否是数组
 不是根据服务器返回的内容是否为数组来判断, 而是根据泛型设置的模型来设置.
 如果返回 NO , 服务器返回的内容是数组, 则取第一个来转模型 (回调里面体现)
 如果返回的是 YES, 服务器返回的内容不是数组, 则会创建一个数组返回 (回调里面体现)
 @return 是否是数组
 */
- (BOOL)contentIsArray;

/**
 baseUrl
 如果为空, 则默认是 Config 里面的baseUrl
 @return baseUrl
 */
- (NSString *)baseUrl;
/**
 url

 @return url
 */
- (NSString *)url;

/**
 方法版本号

 @return 方法版本号 @"20170824"
 */
- (NSString *)methodVersion;

/**
 方法编号

 @return 方法编号 @"100"
 */
- (NSString *)methodValue;

/**
 应用标识
 用于获取签名 默认是 BundleID
 @return 应用标识
 */
- (NSString *)appID;

/**
 是否需要签名
 默认为 YES
 @return 是否需要签名
 */
- (BOOL)needSign;

/**
 是否需要缓存

 @return 是否需要缓存
 */
- (BOOL)needCache;

/**
 在回调之前，强引用自己，不释放

 @return 是否在回调之前不释放自己
 */
- (BOOL)blockSelfUntilDone;

/**
 默认参数
 如果子类重新该方法, 则父类不再增加默认的参数, 如果需要增加默认参数, 请调用 [super defaultParams] 获取父类的默认参数
 @return 默认参数
 */
- (NSMutableDictionary *)defaultParams;

/**
 最大尝试次数
 default 3
 @return 最大尝试次数
 */
- (NSInteger)maxRetryCount;

/**
 拦截器, 主要用于校验数据信息, 校验的数据是经过解密的数据
 */
- (id <InterceptorProtocol>)interceptor;

/**
 请求类型
 默认 YTKRequestMethodPOST
 @return 请求类型
 */
- (NetwrokRequestType)requestType;

/**
 请求解析类型

 @return 请求解析类型
 */
- (NetwrokRequestSerializerType)requestSerializerType;

/**
 响应解析类型

 @return 响应解析类型
 */
- (NetwrokResponseSerializerType)responseSerializerType;

/**
 缓存时间

 @return 缓存时间
 */
- (NSUInteger)cacheTimeInSeconds;
/**
 插入参数
 
 @param obj 参数
 @param key 对应键
 */
- (void)paramInsert:(id)obj forKey:(NSString *)key;

/**
 删除参数
 
 @param key 对应键
 */
- (void)paramDelForKey:(NSString *)key;

/// MARK: - SubClassHolder
/**
 请求失败

 @param error 请求失败
 */
- (void)requestError:(NSError *)error;

/**
 请求成功
 */
- (void)requestSuccess;

/**
 请求头配置，要调用父类方法
 */
- (nullable NSArray<NSString *> *)requestAuthorizationHeaderFieldArray NS_REQUIRES_SUPER;
- (nullable NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary NS_REQUIRES_SUPER;
@end


NS_ASSUME_NONNULL_END
