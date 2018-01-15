//
//  UpdateMoudle.m
//  MLSProject
//
//  Created by MinLison on 2017/10/12.
//  Copyright © 2017年 minlison. All rights reserved.
//
#define MLS_USE_HARPY_UPDATE 0

#import "MLSUpdateMoudle.h"
#import "MainService.h"
#import "MLSUpdateProtocol.h"
#if MLS_USE_HARPY_UPDATE
#import <Harpy/Harpy.h>
#else
#import <Aspects/Aspects.h>
#endif

@MOUDLE_REGISTER(MLSUpdateMoudle)
#if MLS_USE_HARPY_UPDATE
@interface MLSUpdateMoudle () <HarpyDelegate>
#else
@interface MLSUpdateMoudle ()
#endif
@end

@implementation MLSUpdateMoudle
- (void)modSetUp:(BHContext *)context
{
        id <MainServiceProtocol> handler = [[BeeHive shareInstance] createService:@protocol(MainServiceProtocol)];
        UIViewController *vc = [handler getController];
#if MLS_USE_HARPY_UPDATE
        [[Harpy sharedInstance] setPresentingViewController:vc];
        [[Harpy sharedInstance] setDelegate:self];
        [[Harpy sharedInstance] setShowAlertAfterCurrentVersionHasBeenReleasedForDays:3];
        [[Harpy sharedInstance] setAlertControllerTintColor:[UIColor orangeColor]];
        [[Harpy sharedInstance] setAlertType:HarpyAlertTypeOption];
        [[Harpy sharedInstance] setShowAlertAfterCurrentVersionHasBeenReleasedForDays:2];
        [[Harpy sharedInstance] checkVersion];
#if DEBUG
        [[Harpy sharedInstance] setDebugEnabled:YES];
#endif
#else
        void(^PopUpdateController)(void) = ^(void) {
                id <MLSUpdateProtocol> updateService = [[BeeHive shareInstance] createService:@protocol(MLSUpdateProtocol)];
                [updateService showInViewController:vc completion:^(WGUpdateActionType type) {
                }];
        };
        
        [vc aspect_hookSelector:@selector(viewDidAppear:) withOptions:(AspectPositionAfter) usingBlock:PopUpdateController error:nil];
#endif
        
}
- (void)modDidBecomeActive:(BHContext *)context
{
#if MLS_USE_HARPY_UPDATE
        [[Harpy sharedInstance] checkVersionDaily];
        [[Harpy sharedInstance] checkVersionWeekly];
#else
        id <MLSUpdateProtocol> updateService = [[BeeHive shareInstance] createService:@protocol(MLSUpdateProtocol)];
        [updateService checkUpdate];
#endif
}
- (void)modWillEnterForeground:(BHContext *)context
{
#if MLS_USE_HARPY_UPDATE
        [[Harpy sharedInstance] checkVersion];
#endif
}
@end
