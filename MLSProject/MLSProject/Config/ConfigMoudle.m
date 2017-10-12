//
//  ConfigMoudle.m
//  ChengziZdd
//
//  Created by MinLison on 2017/8/31.
//  Copyright © 2017年 chengzivr. All rights reserved.
//

#import "ConfigMoudle.h"
#import "RequestUrlFilter.h"

@BeeHiveMod(ConfigMoudle)
@implementation ConfigMoudle

- (void)modSetUp:(BHContext *)context
{
        [self _SetupNetwork:context];
        
        [self _SetupUITheme];
        
        [[HLNetWorkReachability shareManager] startNotifier];
}
- (void)_SetupNetwork:(BHContext *)context
{
        YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
        [config addUrlFilter:[RequestUrlFilter filter]];
        
        switch (context.env)
        {
                case BHEnvironmentDev:
                        config.debugLogEnabled = NO;
                        config.baseUrl = kRequestUrlBaseTest; // 可以任意修改此选项, 来适配不同的 Debug 下的服务器端
                        break;
                case BHEnvironmentTest:
                        config.debugLogEnabled = NO;
                        config.baseUrl = kRequestUrlBaseTest;
                        break;
                case BHEnvironmentStage:
                        config.debugLogEnabled = NO;
                        config.baseUrl = kRequestUrlBasePreProduct;
                        break;
                case BHEnvironmentProd:
                        config.debugLogEnabled = NO;
                        config.baseUrl = kRequestUrlBaseOnline;
                        break;
                        
                default:
                        config.debugLogEnabled = NO;
                        config.baseUrl = kRequestUrlBaseOnline;
                        break;
        }
}
- (void)_SetupUITheme
{
        QMUIConfigurationTemplate *template = [[QMUIConfigurationTemplate alloc] init];
        [template setupConfigurationTemplate];
        [[QDThemeManager sharedInstance] setCurrentTheme:template];
}
@end
