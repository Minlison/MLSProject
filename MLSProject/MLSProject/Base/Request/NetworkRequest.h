//
//  NetworkRequest.h
//  MLSProject
//
//  Created by MinLison on 2017/9/5.
//  Copyright © 2017年 minlison. All rights reserved.
//



#import "BaseNetworkRequest.h"

typedef NS_ENUM(NSInteger, NetwrokRequestType)
{
        NetwrokRequestTypeGET = YTKRequestMethodGET,
        NetwrokRequestTypePOST = YTKRequestMethodPOST,
        NetworkRequestHEAD = YTKRequestMethodHEAD,
        NetwrokRequestTypePUT = YTKRequestMethodPUT,
        NetwrokRequestTypeDELETE = YTKRequestMethodDELETE,
        NetwrokRequestTypePATCH = YTKRequestMethodPATCH,
};

typedef NS_ENUM(NSInteger,NetwrokRequestSerializerType)
{
        NetwrokRequestSerializerTypeHTTP = YTKRequestSerializerTypeHTTP,
        NetwrokRequestSerializerTypeJSON = YTKRequestSerializerTypeJSON,
};


typedef NS_ENUM(NSInteger, NetwrokResponseSerializerType) {
        NetwrokResponseSerializerTypeHTTP = YTKResponseSerializerTypeHTTP,
        NetwrokResponseSerializerTypeJSON = YTKResponseSerializerTypeJSON,
        NetwrokResponseSerializerTypeXMLParser =YTKResponseSerializerTypeXMLParser,
};

NS_ASSUME_NONNULL_BEGIN

@interface NetworkRequest : BaseNetworkRequest

/**
 请求序列化类型
 默认是 NetwrokRequestSerializerTypeHTTP
 */
@property(nonatomic, assign) NetwrokRequestSerializerType netwrokRequestSerializerType;

/**
 响应序列化类型
 默认 NetwrokResponseSerializerTypeHTTP
 */
@property(nonatomic, assign) NetwrokResponseSerializerType netwrokResponseSerializerType;

/**
 加密工具
 */
@property(nonatomic, strong, nullable) id <EncryptProtocol> encryptTool;

/**
 解密后的数据(字符串)
 */
@property(nonatomic, copy, readonly, nullable) NSString *decryptResponseString;

/**
 解密后的数据(NSDictionary, NSArray, NSString)
 */
@property(nonatomic, copy, readonly, nullable) id decryptResponseObject;

/**
 解密后的数据(NSData)
 */
@property(nonatomic, copy, readonly, nullable) NSData *decryptResponseData;

/**
 请求参数
 */
@property(nonatomic, strong, readonly)  NSMutableDictionary *params;

/**
 重新定义 baseUrl
 会强制覆盖 config 的 baseUrl
 */
@property(nonatomic, copy) NSString *baseUrl;

/**
 错误失败后, 重试次数
 默认是3次
 */
@property(nonatomic, assign) NSInteger failedRetryMaxCount;

/**
 错误重试次数
 */
@property(nonatomic, assign,  readonly) NSInteger failedRetryCount;

/**
 应用标识 默认为 BundleID
 用于获取签名 Sign
 */
@property(nonatomic, copy, nullable) NSString *appID;

/**
 强制禁止清理 block(处理循环引用)
 默认为 NO
 在第一次判断之后, 会主动设置成 YES ,以便在下次start 之后自动清理 block
 为了防止同样的 request, 第二次开始的时候, 第一次的 block 并没有清理, 导致第二次开始不会回调
 因为 YTKNetwork 清理 block 是在异步线程清理的.
 如果设置为 YES , 要及时调用 -clearCompletionBlock 方法, 防止 block 循环引用, 如果在 block 中使用了 __weak 修饰, 无需理会
 */
@property(nonatomic, assign, getter=isForceRefuseCleanBlock) BOOL forceRefuseCleanBlock;

/**
  缓存时间
  默认是60s
 */
@property(nonatomic, assign) NSUInteger cacheTimesWithSeconds;

/**
 创建网络请求
 
 @param params 参数
 @param type 请求类型 默认 NetwrokRequestTypePOST
 @param url 网络地址默认 inter
 @return 网络请求
 */
+ (instancetype)request:(NetwrokRequestType)type withParams:(nullable NSDictionary *)params url:(NSString *)url;

/**
 创建网络请求
 used : [self request:NetwrokRequestTypePOST withParams:params url:url]
 @param params 参数
 @param url 网络地址默认 inter
 @return 网络请求
 */
+ (instancetype)requestWithParams:(nullable NSDictionary *)params url:(NSString *)url;

/**
 创建网络请求
 used : [self requestWithParams:params url:url]
 @param params 参数
 @return 网络请求
 */
+ (instancetype)requestWithParams:(nullable NSDictionary *)params;


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

@end

NS_ASSUME_NONNULL_END
