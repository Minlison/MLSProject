//
//  RouterMoudle.m
//  MLSProject
//
//  Created by MinLison on 2017/9/6.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "RouterMoudle.h"
#import "RouterServiceProtocol.h"

@MOUDLE_REGISTER(RouterMoudle)
@implementation RouterMoudle

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
                [AppShareRouterService routeURL:context.openURLItem.openURL];
        }
}
@end
