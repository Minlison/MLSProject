//
//  RouterServiceProtocol.h
//  MinLison
//
//  Created by MinLison on 2017/9/6.
//  Copyright © 2017年 minlison. All rights reserved.
//

#ifndef RouterServiceProtocol_h
#define RouterServiceProtocol_h
#ifdef __OBJC__
#import "BaseServiceProtocol.h"
#import "RouterHandleProtocol.h"

/*
 注: 
 route url 的处理方式
 route url 的创建方式 使用宏定义 AppRouteWithURI() 来创建
 
 route url 的格式 scheme://uri?queryStr
 uri 会定义一系列常量,来指定控制器所对应的 uri, 保证不重复
 后面接具体参数时, 以 url queryStr 的方式传参数 url=https://www.baidu.com&cate_id=1  取值会出 url = https://www.baidu.com cate_id = 1
 */
NS_ASSUME_NONNULL_BEGIN


/// 路由服务中心
#define AppShareRouterService ((id <RouterServiceProtocol>)[[BeeHive shareInstance] createService:@protocol(RouterServiceProtocol)])

/**
 快速创建路由地址, 用于打开的一个地址

 @param uri  uri 唯一标识符, 是除了 scheme 之外的地址 例如 app://ac/b 中的 ac/b
 @return  增加 scheme 的地址
 */
#define AppRouteStringWithURIFormat(uri,queryStr,...) [NSString stringWithFormat:@"%@%@?" queryStr,[AppShareRouterService routeScheme],uri,##__VA_ARGS__]
#define AppRouteURLWithURIFormat(uri,queryStr,...) [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?" queryStr,[AppShareRouterService routeScheme],uri,##__VA_ARGS__]]

/**
 快速创建注册路由地址, 用于监听一个地址

 @param uri 唯一标识符
 @return  增加 scheme 的地址
 */
#define AppRoutePatternStringWithURI(uri) [NSString stringWithFormat:@"%@",uri]
#define AppRoutePatternStringWithURIFormat(fmt,...) [NSString stringWithFormat:fmt,##__VA_ARGS__]

typedef void (^RouterServiceCallBackBlock)( NSDictionary<NSString *, id>  * _Nullable parameters, UIViewController <JLRRouteDefinitionTargetController>* _Nullable targetVC);

@protocol RouterServiceProtocol <BaseServiceProtocol>

/**
 路由 secheme

 @return 路由 secheme
 */
- (NSString *)routeScheme;

/**
 注册控制器

 @param route 路由地址
 @param handlerClass 接收路由的 Class
 */
- (void)addRoute:(NSString *)routePattern handlerClass:(Class)handlerClass;

/**
 注册路由

 @param routePattern 路由地址
 @param handlerBlock 回调
 */
- (void)addRoute:(NSString *)routePattern handler:(BOOL (^__nullable)(NSDictionary<NSString *, id> *parameters))handlerBlock;

/**
 打开路由地址
 也可调用 [[UIApplication sharedApplication] openURL:url];
 @param routeURL 路由地址 mls://xx/xx/xx
 */
- (BOOL)routeURL:(NSURL *)routeURL;

/**
 打开路由地址

 @param routeURL 路由地址
 @param paramters 附加参数, 最终会回调给 handleObj
 */
- (BOOL)routeURL:(NSURL *)routeURL withParamters:( NSDictionary * _Nullable )paramters;

/**
 打开路由地址

 @param routeURL 路由地址
 @param handlerBlock 回调函数
 @return 是否打开成功
 */
- (BOOL)routeURL:(nullable NSURL *)routeURL handler:(__nullable RouterServiceCallBackBlock)handlerBlock;

/**
 打开路由地址

 @param routeURL 路由地址
 @param paramters 回调函数
 @param handlerBlock 是否打开成功
 */
- (BOOL)routeURL:(NSURL *)routeURL withParamters:(NSDictionary *)paramters handler:(__nullable RouterServiceCallBackBlock)handlerBlock;


/**
 是否可以打开该地址

 @param routeUrl 路由地址
 @return  YES/NO
 */
- (BOOL)canHandleUrl:(NSURL *)routeUrl;
@end
#endif
#endif /* RouterServiceProtocol_h */

NS_ASSUME_NONNULL_END
