//
//  RouterMoudle.m
//  MinLison
//
//  Created by MinLison on 2017/9/6.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "RouterMoudle.h"
#import "RouterServiceProtocol.h"
#import "MainServiceProtocol.h"
@MOUDLE_REGISTER(RouterMoudle)
@implementation RouterMoudle
- (void)basicModuleLevel{}
- (void)modSetUp:(BHContext *)context
{
        switch (context.env) {
                case BHEnvironmentDev:
                {
                        [JLRoutes setVerboseLoggingEnabled:YES];
                }
                        break;
                        
                default:
                        break;
        }
}
- (void)modOpenURL:(BHContext *)context
{
        if ( [AppShareRouterService canHandleUrl:context.openURLItem.openURL] )
        {
                @weakify(self);
                [AppShareRouterService routeURL:context.openURLItem.openURL handler:^(NSDictionary<NSString *,id> * _Nullable parameters, UIViewController<JLRRouteDefinitionTargetController> * _Nullable targetVC) {
                        @strongify(self);
                }];
        }
}
- (void)pushViewController:(UIViewController *)vc
{
        id <MainServiceProtocol> mainService = [[BeeHive shareInstance] createService:@protocol(MainServiceProtocol)];
        
}
@end
