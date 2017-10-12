//
//  UpdateMoudle.m
//  MLSProject
//
//  Created by MinLison on 2017/10/12.
//  Copyright © 2017年 minlison. All rights reserved.
//
#define MLS_USE_HARPY_UPDATE 1

#import "UpdateMoudle.h"
#import "MainService.h"
#import "MLSUpdateProtocol.h"
#if MLS_USE_HARPY_UPDATE
#import <Harpy/Harpy.h>
#else
#import <Aspects/Aspects.h>
#endif

@MOUDLE_REGISTER(UpdateMoudle)
#if MLS_USE_HARPY_UPDATE
@interface UpdateMoudle () <HarpyDelegate>
#else
@interface UpdateMoudle ()
#endif
@end

@implementation UpdateMoudle
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
                [updateService showInViewController:vc completion:^(MLSUpdateActionType type) {
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
#endif
}
- (void)modWillEnterForeground:(BHContext *)context
{
#if MLS_USE_HARPY_UPDATE
        [[Harpy sharedInstance] checkVersion];
#endif
}
@end
