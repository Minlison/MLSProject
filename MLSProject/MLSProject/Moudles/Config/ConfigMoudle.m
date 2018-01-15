//
//  ConfigMoudle.m
//  MinLison
//
//  Created by MinLison on 2017/8/31.
//  Copyright © 2017年 minlison. All rights reserved.
//
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#if WGEnablePgyerSDK
#import <PgySDK/PgyManager.h>
#import <PgyUpdate/PgyUpdateManager.h>
#endif

#import "ConfigMoudle.h"
#import "RequestUrlFilter.h"
#import "RMUUid.h"
#import "MainServiceProtocol.h"
#import "MLSConfigService.h"
#import "MLSConfigViewController.h"



@BeeHiveMod(ConfigMoudle)
@implementation ConfigMoudle
- (void)basicModuleLevel
{
}
- (void)modSetUp:(BHContext *)context
{
        [self _SetupGaoDeMap];
        
        [self _SetupNetwork:context];
        
        [self _SetupUITheme];
        
        [self _SetupUmeng:(context.env == BHEnvironmentDev)];
        
        [self _SetupUmengSocial:(context.env == BHEnvironmentDev)];
        
        [self _SetupUmengNotification:context.launchOptions];
        
        [self _SetupIQKeyboardManager:(context.env == BHEnvironmentDev)];
        
//        [self _SetupDebugConfigVC];
        
        [self configQMUIAlert];
        
        [[HLNetWorkReachability shareManager] startNotifier];
        
#if WGEnablePgyerSDK
        [[PgyManager sharedPgyManager] startManagerWithAppId:PGYER_APP_KEY];
#endif
}
- (void)configQMUIAlert
{
        QMUIAlertController *alert = [QMUIAlertController appearance];
        
        alert.sheetButtonHeight = __WGHeight(50.0f);
        alert.sheetContentCornerRadius = 0;
        alert.sheetButtonBackgroundColor = [UIColor whiteColor];
        alert.sheetHeaderInsets = UIEdgeInsetsZero;
        alert.sheetHeaderInsets = UIEdgeInsetsZero;
        alert.sheetContentMargin = UIEdgeInsetsZero;
        alert.sheetSeperatorColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        alert.sheetBackgroundColor = [UIColorHex(0x939393) colorWithAlphaComponent:1];
        alert.sheetTitleMessageSpacing = 0;
        alert.sheetCancelButtonMarginTop = __WGHeight(6);
        alert.sheetContentMaximumWidth = __MAIN_SCREEN_WIDTH__;
        NSDictionary *titleAttribute = @{
                                         NSFontAttributeName : WGSystem16Font,
                                         NSForegroundColorAttributeName : UIColorHex(0x323232)
                                         };
        alert.sheetTitleAttributes = titleAttribute;
        alert.sheetButtonAttributes = titleAttribute;
        alert.sheetButtonDisabledAttributes = titleAttribute;
        alert.sheetCancelButtonAttributes = titleAttribute;
}
- (void)modDidRegisterForRemoteNotifications:(BHContext *)context
{
        [UMessage registerDeviceToken:context.notificationsItem.deviceToken];
        [self _SetUmengAlias];
}
- (void)modDidReceiveRemoteNotification:(BHContext *)context
{
        [self _UMManageNotifaction:context.notificationsItem.userInfo];
        if (context.notificationsItem.notificationResultHander)
        {
                context.notificationsItem.notificationResultHander(UIBackgroundFetchResultNewData);
        }
        
}
- (void)modDidReceiveNotificationResponse:(BHContext *)context
{
        UNNotificationResponse *response = context.notificationsItem.notificationResponse;
        if ([response.notification.request.identifier containsString:@"local"])
        {
        }
        else
        {
                [self _UMManageNotifaction:response.notification.request.content.userInfo];
        }
}
- (void)modOpenURL:(BHContext *)context
{
        if (context.openURLItem.sourceApplication)
        {
                [[UMSocialManager defaultManager] handleOpenURL:context.openURLItem.openURL sourceApplication:context.openURLItem.sourceApplication annotation:context.openURLItem.options];
        }
        else if (context.openURLItem.options)
        {
                [[UMSocialManager defaultManager] handleOpenURL:context.openURLItem.openURL options:context.openURLItem.options];
        }
        else
        {
                [[UMSocialManager defaultManager] handleOpenURL:context.openURLItem.openURL];
        }
}

- (void)_SetupGaoDeMap
{
        [AMapServices sharedServices].apiKey = GAO_DE_KEY;
        [[AMapServices sharedServices] setEnableHTTPS:YES];
}

- (void)_SetupDebugConfigVC
{
#if (DEBUG || OPEN_RIGHT_MENU)
        id <MainServiceProtocol> mainService = [[BeeHive shareInstance] createService:@protocol(MainServiceProtocol)];
        [mainService setRightMenuController:[[MLSConfigViewController alloc] init]];
#endif
}
- (void)_SetupNetwork:(BHContext *)context
{
        YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
        [config addUrlFilter:[RequestUrlFilter filter]];
        
        switch (context.env)
        {
                case BHEnvironmentDev:
                {
                        config.debugLogEnabled = NO;
                        config.baseUrl = kRequestUrlBaseTest; // 可以任意修改此选项, 来适配不同的 Debug 下的服务器端
                }
                        break;
                case BHEnvironmentTest:
                {
                        config.debugLogEnabled = NO;
                        config.baseUrl = kRequestUrlBaseTest;
                }
                        break;
                case BHEnvironmentStage:
                {
                        config.debugLogEnabled = NO;
                        config.baseUrl = kRequestUrlBaseTest;
                }
                        break;
                case BHEnvironmentProd:
                {
                        config.debugLogEnabled = NO;
                        config.baseUrl = kRequestUrlBaseOnline;
                }
                        break;
                        
                default:
                {
                        config.debugLogEnabled = NO;
                        config.baseUrl = kRequestUrlBaseOnline;
                }
                        break;
        }
}


- (void)_SetupUITheme
{
        QMUIConfigurationTemplate *template = [[QMUIConfigurationTemplate alloc] init];
        [template setupConfigurationTemplate];
        [[QDThemeManager sharedInstance] setCurrentTheme:template];
}

- (void)_SetupUmeng:(BOOL)enableLog
{
        /// MARK: - UMTrack
        [UMConfigure setLogEnabled:enableLog];
        [UMConfigure initWithAppkey:UMENG_APPKEY channel:nil];
        [MobClick setScenarioType:E_UM_DPLUS];
        
        //设置友盟社会化组件appkey
        [[UMSocialManager defaultManager] setUmSocialAppkey:UMENG_APPKEY];
        [[UMSocialManager defaultManager] setUmSocialAppSecret:UMENG_MASTER_SECRET];
        //禁止https
        [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
        
        // 打开调试log的开关
        [[UMSocialManager defaultManager] openLog:enableLog];
        
        [UIViewController aspect_hookSelector:@selector(viewWillAppear:) withOptions:(AspectPositionAfter) usingBlock:^(id<AspectInfo>info){
                UIViewController *vc = [info instance];
                NSString *name = vc.title ?:vc.mobclick_name;
                [MobClick beginLogPageView:name];
        } error:nil];
        
        [UIViewController aspect_hookSelector:@selector(viewWillDisappear:) withOptions:(AspectPositionAfter) usingBlock:^(id<AspectInfo>info){
                UIViewController *vc = [info instance];
                NSString *name = vc.title ?:(vc.mobclick_name?:NSStringFromClass([vc class]));
                [MobClick endLogPageView:name];
        } error:nil];
}
- (void)_SetupUmengSocial:(BOOL)enableLog
{
        //设置友盟社会化组件appkey
        [[UMSocialManager defaultManager] setUmSocialAppkey:UMENG_APPKEY];
        [[UMSocialManager defaultManager] setUmSocialAppSecret:UMENG_MASTER_SECRET];
        //禁止https
        [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
        
        //打开调试log的开关
        [[UMSocialManager defaultManager] openLog:enableLog];
        
        [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:UMENG_WEBCATAPPID appSecret:UMENG_WEBCATAPPKEY redirectURL:UMENG_REDIRECT_URL];
        [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatTimeLine appKey:UMENG_WEBCATAPPID appSecret:UMENG_WEBCATAPPKEY redirectURL:UMENG_REDIRECT_URL];
        [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:UMENG_QQAPPID appSecret:UMENG_QQAPPKEY redirectURL:UMENG_REDIRECT_URL];
        [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:UMENG_XINLNAGAPPKEY appSecret:UMENG_XINLANGAPPSECRET redirectURL:UMENG_XINLANG_REDIRECT];
}
- (void)_SetupUmengNotification:(NSDictionary *)launchOptions
{
        //清空
        //        [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:nil completionHandler:^(BOOL granted, NSError * _Nullable error) {
        //                if (error) {
        //                        NSLogErr(@"umeng register remote notifications error %@",error);
        //                }
        //        }];
        
        void(^RegisterNotification)(void) = ^() {
                
                [UMessage startWithAppkey:UMENG_APPKEY launchOptions:launchOptions httpsEnable:YES];
                [UMessage registerForRemoteNotifications];
                
                //register remoteNotification types （iOS 8.0及其以上版本）
                UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
                action1.identifier = @"open";
                action1.title=@"打开";
                action1.activationMode = UIUserNotificationActivationModeForeground; // 当点击的时候启动程序
                
                UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
                action2.identifier = @"cancel";
                action2.title=@"忽略";
                action2.activationMode = UIUserNotificationActivationModeBackground; // 当点击的时候不启动程序，在后台处理
                action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
                action2.destructive = YES;
                
                UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
                categorys.identifier = @"category1";//这组动作的唯一标示
                [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
                
                
                if ([[[UIDevice currentDevice] systemVersion] intValue] >= 10)
                {
                        UNNotificationAction *action1_ios10 = [UNNotificationAction actionWithIdentifier:@"open" title:@"打开" options:UNNotificationActionOptionForeground];
                        UNNotificationAction *action2_ios10 = [UNNotificationAction actionWithIdentifier:@"cancel" title:@"忽略" options:UNNotificationActionOptionForeground];
                        
                        UNNotificationCategory *category1_ios10 = [UNNotificationCategory categoryWithIdentifier:@"category1" actions:@[action1_ios10,action2_ios10] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
                        
                        NSSet *categories_ios10 = [NSSet setWithObjects:category1_ios10, nil];
                        [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:categories_ios10];
                }
                else
                {
                        [UMessage registerForRemoteNotifications:[NSSet setWithObject:categorys]];
                }
                
                
                
#ifdef DEBUG
                [UMessage setLogEnabled:YES];
#else
                [UMessage setLogEnabled:NO];
#endif
        };
        
        if ([UIDevice currentDevice].systemVersion.doubleValue >= 10.0) {
                [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
                        if (!error) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                        RegisterNotification();
                                });
                        }
                }];
        }
        //iOS8以后，必须用户授权才可以发出通知（本地推送）
        else if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]
                 && [UIDevice currentDevice].systemVersion.doubleValue >= 8.0)
        {
                UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
                UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type
                                                                                         categories:nil];
                [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
                RegisterNotification();
        }
        else
        {
                RegisterNotification();
        }
}
- (void)_SetUmengAlias
{
        if (LNUserManager.isLogin)
        {
                if (LNUserManager.uid)
                {
                        [UMessage setAlias:LNUserManager.uid type:@"USERID" response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
                                if (!error) {
                                        NSLogInfo(@"设置自定义alias成功  userID == %@",LNUserManager.uid);
                                }
                                else
                                {
                                        NSLogInfo(@"设置自定义alias失败 %@ userID == %@",error,LNUserManager.uid);
                                }
                        }];
                }
                
                if (LNUserManager.mobile)
                {
                        [UMessage setAlias:LNUserManager.mobile type:@"PHONENUM" response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
                                if (!error) {
                                        NSLogInfo(@"设置自定义alias成功 phoneNum == %@",LNUserManager.mobile);
                                }
                                else
                                {
                                        NSLogInfo(@"设置自定义alias失败%@ phoneNum == %@",error,LNUserManager.mobile);
                                }
                        }];
                }
        }
        else
        {
                [UMessage setAlias:[RMUUid getUUid] type:@"UUID" response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
                        NSLogInfo(@"设置自定义alias成功 UUID == %@",[RMUUid getUUid]);
                }];
        }
}
- (void)_UMManageNotifaction:(NSDictionary *)userInfo
{
        [UMessage setAutoAlert:NO];
        [UMessage didReceiveRemoteNotification:userInfo];
        if (userInfo == nil) return;
        UIApplicationState state = [UIApplication sharedApplication].applicationState;
        
        if (state == UIApplicationStateActive)
        {
                [UMessage sendClickReportForRemoteNotification:userInfo];
        }
        else if (state == UIApplicationStateBackground || state == UIApplicationStateInactive)
        {
        }
        
}
- ( void )_SetupIQKeyboardManager:(BOOL)debug
{
        // 设置智能键盘处理
        IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
        manager.enable = YES;
        manager.shouldResignOnTouchOutside = YES;
        manager.shouldToolbarUsesTextFieldTintColor = NO;
        manager.enableAutoToolbar = NO;
        manager.enableDebugging = debug;
        [manager registerTextFieldViewClass:[YYTextView class] didBeginEditingNotificationName:YYTextViewTextDidBeginEditingNotification didEndEditingNotificationName:YYTextViewTextDidEndEditingNotification];
        [manager registerTextFieldViewClass:[QMUITextField class] didBeginEditingNotificationName:UITextFieldTextDidBeginEditingNotification didEndEditingNotificationName:UITextFieldTextDidEndEditingNotification];
        [manager registerTextFieldViewClass:[US2ValidatorTextField class] didBeginEditingNotificationName:UITextFieldTextDidBeginEditingNotification didEndEditingNotificationName:UITextFieldTextDidEndEditingNotification];
        [manager registerTextFieldViewClass:[US2ValidatorTextView class] didBeginEditingNotificationName:UITextViewTextDidBeginEditingNotification didEndEditingNotificationName:UITextViewTextDidEndEditingNotification];
        [manager.disabledDistanceHandlingClasses addObject:[QMUIModalPresentationViewController class]];
}
@end
