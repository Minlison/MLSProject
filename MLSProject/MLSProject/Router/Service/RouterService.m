//
//  RouterService.m
//  MinLison
//
//  Created by MinLison on 2017/9/6.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "RouterService.h"
#import "RouterServiceProtocol.h"
#import "JLRoutes.h"

@SERVICE_REGISTER(RouterServiceProtocol, RouterService)

@interface RouterService () 
@property(nonatomic, strong) JLRoutes *routeCenter;
@end

@implementation RouterService
//// MARK: - Protocol method begin
- (void)addRoute:(NSString *)routePattern handlerClass:(Class)handlerClass
{
        [self.routeCenter addRoute:routePattern handlerClass:handlerClass];
}

- (void)addRoute:(NSString *)routePattern handler:(BOOL (^__nullable)(NSDictionary<NSString *, id> *parameters))handlerBlock
{
        [self.routeCenter addRoute:routePattern handler:handlerBlock];
}

- (BOOL)routeURL:(NSURL *)routeURL
{
        return [self.routeCenter routeURL:routeURL handler:nil];
}
- (BOOL)routeURL:(NSURL *)routeURL withParamters:(NSDictionary *)paramters
{
        return [self.routeCenter routeURL:routeURL withParameters:paramters handler:nil];
}
- (BOOL)routeURL:(nullable NSURL *)routeURL handler:(__nullable RouterServiceCallBackBlock)handlerBlock
{
        return [self.routeCenter routeURL:routeURL handler:handlerBlock];
}

- (BOOL)routeURL:(NSURL *)routeURL withParamters:(NSDictionary *)paramters handler:(__nullable RouterServiceCallBackBlock)handlerBlock
{
        return [self.routeCenter routeURL:routeURL withParameters:paramters handler:handlerBlock];
}

- (BOOL)canHandleUrl:(NSURL *)routeUrl
{
        return [self.routeCenter canRouteURL:routeUrl];
}
- (NSString *)routeScheme
{
        return @"mls://";
}

//// MARK: - Protocol method end
- (JLRoutes *)routeCenter
{
        if (_routeCenter == nil) {
                _routeCenter = [JLRoutes routesForScheme:@"mls://"];
        }
        return _routeCenter;
}


/// 单例
+ (instancetype)sharedInstance {
        static dispatch_once_t onceToken;
        static RouterService *instance = nil;
        dispatch_once(&onceToken,^{
                instance = [[super allocWithZone:NULL] init];
        });
        return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
        return [self sharedInstance];
}

+ (BOOL)singleton
{
        return YES;
}
- (nullable __kindof UIViewController *)getController {
        return nil;
}

@end
