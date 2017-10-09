//
//  AppDelegate.m
//  MLSProject
//
//  Created by MinLison on 2017/9/27.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "AppDelegate.h"
#import <BeeHive/BeeHive.h>
#import <BeeHive/BHTimeProfiler.h>
#import "MainMoudle.h"
#ifdef DEBUG
#import <FBMemoryProfiler/FBMemoryProfiler.h>
#import "CacheCleanerPlugin.h"
#import "RetainCycleLoggerPlugin.h"

@interface AppDelegate ()
{
    FBMemoryProfiler *_memoryProfiler;
}
#else
@interface AppDelegate ()
#endif

@end

@implementation AppDelegate
@dynamic window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [BHContext shareInstance].application = application;
    [BHContext shareInstance].launchOptions = launchOptions;
#ifdef DEBUG
    [BHContext shareInstance].env = BHEnvironmentDev;
    _memoryProfiler = [[FBMemoryProfiler alloc] initWithPlugins:@[[[CacheCleanerPlugin alloc] init],
                                                                  [[RetainCycleLoggerPlugin alloc] init]]
                               retainCycleDetectorConfiguration:nil];
    [_memoryProfiler enable];
#elif defined(ADHoc)
    [BHContext shareInstance].env = BHEnvironmentTest;
#elif defined(ADHocOnline)
    [BHContext shareInstance].env = BHEnvironmentStage;
#else
    [BHContext shareInstance].env = BHEnvironmentProd;
#endif
    
    [BeeHive shareInstance].enableException = YES;
    [[BeeHive shareInstance] setContext:[BHContext shareInstance]];
    
    [super application:application didFinishLaunchingWithOptions:launchOptions];
    
    id <MainServiceProtocol> mainService = [[BeeHive shareInstance] createService:@protocol(MainServiceProtocol)];
    
    UIViewController *vc = [mainService getController];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = vc;
    self.window.backgroundColor = QMUICMI.backgroundColor;
    [self.window makeKeyAndVisible];
    
    return YES;
}


@end
