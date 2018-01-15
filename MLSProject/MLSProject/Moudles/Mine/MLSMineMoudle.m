//
//  MLSMineMoudle.m
//  MLSProject
//
//  Created by MinLison on 2017/11/30.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "MLSMineMoudle.h"
#import "MLSMineViewController.h"
#import "MainServiceProtocol.h"

@MOUDLE_REGISTER(MLSMineMoudle)

@implementation MLSMineMoudle
- (void)modSetUp:(BHContext *)context
{
        id <MainServiceProtocol> mainService = [[BeeHive shareInstance] createService:@protocol(MainServiceProtocol)];
        MLSMineViewController *vc = [[MLSMineViewController alloc] init];
        vc.title = [NSString aPP_Mine];
        vc.tabBarItem.selectedImage = [UIImage wo_de_selRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
        vc.tabBarItem.image = [UIImage wo_de_norRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
        vc.hidesBottomBarWhenPushed = NO;
        BaseNavigationViewController *navController = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
        [mainService addTabBarController:navController atIndex:LNTabbarIndexMine];
}

@end
