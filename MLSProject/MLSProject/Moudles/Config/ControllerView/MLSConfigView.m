//
//  MLSConfigView.m
//  MinLison
//
//  Created by MinLison on 2017/11/17.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSConfigView.h"
#import "FXForms.h"
#import "MLSConfigForm.h"
#import "MainServiceProtocol.h"
#import "MLSConfigService.h"
@interface MLSConfigView ()
@property (nonatomic, strong) FXFormController *formController;
@end

@implementation MLSConfigView

- (void)setupTableView
{
        [super setupTableView];
        [self configForm];
}
- (void)configForm
{
        self.formController = [[FXFormController alloc] init];
        self.formController.form = [[MLSConfigForm alloc] init];
        self.formController.delegate = (id <FXFormControllerDelegate>)self;
        self.formController.tableView = self.tableView;
}
- (void)serverAddress25
{
        YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
        config.baseUrl = kRequestUrlBase25;
        MLSConfigService.serverAddress = kRequestUrlBase25;
        BHContext *context = [BHContext shareInstance];
        context.env = BHEnvironmentDev;
        [ShareDefaultCache removeAllObjects];
        [MLSTipClass showText:@"更换成功"];
        id <MainServiceProtocol> mainService = [[BeeHive shareInstance] createService:@protocol(MainServiceProtocol)];
        [mainService closeMenu:YES completion:^(BOOL cancelled) {
                [self.controller postReloadDataNotifaction];
        }];
}
- (void)serverAddress40
{
        YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
        config.baseUrl = kRequestUrlBase40;
        MLSConfigService.serverAddress = kRequestUrlBase40;
        BHContext *context = [BHContext shareInstance];
        context.env = BHEnvironmentDev;
        [ShareDefaultCache removeAllObjects];
        [MLSTipClass showText:@"更换成功"];
        id <MainServiceProtocol> mainService = [[BeeHive shareInstance] createService:@protocol(MainServiceProtocol)];
        [mainService closeMenu:YES completion:^(BOOL cancelled) {
                [self.controller postReloadDataNotifaction];
        }];
}
- (void)serverAddressTest
{
        YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
        config.baseUrl = kRequestUrlBaseTest;
        MLSConfigService.serverAddress = kRequestUrlBaseTest;
        BHContext *context = [BHContext shareInstance];
        context.env = BHEnvironmentTest;
        [ShareDefaultCache removeAllObjects];
        [MLSTipClass showText:@"更换成功"];
        id <MainServiceProtocol> mainService = [[BeeHive shareInstance] createService:@protocol(MainServiceProtocol)];
        [mainService closeMenu:YES completion:^(BOOL cancelled) {
                [self.controller postReloadDataNotifaction];
        }];
}
- (void)showDebugView
{
        MLSConfigForm *form = (MLSConfigForm *)self.formController.form;
        [NSLogger showDebugView:form.showDebugView];
}
- (void)serverAddressPreProduct
{
        YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
        config.baseUrl = kRequestUrlBasePreProduct;
        MLSConfigService.serverAddress = kRequestUrlBasePreProduct;
        BHContext *context = [BHContext shareInstance];
        context.env = BHEnvironmentStage;
        [ShareDefaultCache removeAllObjects];
        [MLSTipClass showText:@"更换成功"];
        id <MainServiceProtocol> mainService = [[BeeHive shareInstance] createService:@protocol(MainServiceProtocol)];
        [mainService closeMenu:YES completion:^(BOOL cancelled) {
                [self.controller postReloadDataNotifaction];
        }];
}
- (void)serverAddressOnline
{
        YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
        config.baseUrl = kRequestUrlBaseOnline;
        MLSConfigService.serverAddress = kRequestUrlBaseOnline;
        BHContext *context = [BHContext shareInstance];
        context.env = BHEnvironmentProd;
        [ShareDefaultCache removeAllObjects];
        [MLSTipClass showText:@"更换成功"];
        id <MainServiceProtocol> mainService = [[BeeHive shareInstance] createService:@protocol(MainServiceProtocol)];
        [mainService closeMenu:YES completion:^(BOOL cancelled) {
                [self.controller postReloadDataNotifaction];
        }];
}
- (void)gotoOnlineApp
{
        NSURL *url = [NSURL URLWithString:@"mlsproject://"];
        if ( ![[UIApplication sharedApplication] canOpenURL:url] )
        {
                url = [NSURL URLWithString:PGYER_APP_ONLINE_URL];
        }
        [[UIApplication sharedApplication] openURL:url];
}
- (void)logout
{
        [LNUserManager logOut:nil success:nil failed:nil];
        [MLSTipClass showText:@"退出登录成功"];
        id <MainServiceProtocol> mainService = [[BeeHive shareInstance] createService:@protocol(MainServiceProtocol)];
        [mainService closeMenu:YES completion:^(BOOL cancelled) {
                [self.controller postReloadDataNotifaction];
        }];
}
- (void)clearCache
{
        [ShareDefaultCache removeAllObjects];
        [MLSTipClass showText:@"清理缓存成功"];
        id <MainServiceProtocol> mainService = [[BeeHive shareInstance] createService:@protocol(MainServiceProtocol)];
        [mainService closeMenu:YES completion:^(BOOL cancelled) {
                [self.controller postReloadDataNotifaction];
        }];
}
@end
