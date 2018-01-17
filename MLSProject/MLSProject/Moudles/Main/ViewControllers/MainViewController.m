//
//  MainViewController.m
//  MinLison
//
//  Created by MinLison on 2017/8/31.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MainViewController.h"
#import "BaseNavigationViewController.h"
#import "MLSTabBarViewController.h"

@interface MainViewController ()<IIViewDeckControllerDelegate>
@property(nonatomic, strong) MLSTabBarViewController *tabbarViewController;
@end

@implementation MainViewController
- (instancetype)init
{
        if (self = [super init])
        {
                self.centerViewController = self.tabbarViewController;
                self.delegate = self;
        }
        return self;
}
- (BOOL)viewDeckController:(IIViewDeckController *)viewDeckController willOpenSide:(IIViewDeckSide)side
{
        return [self getShowingNavitagionController].viewControllers.count <= 1;
}
- (BOOL)viewDeckController:(IIViewDeckController *)viewDeckController shouldStartPanningToSide:(IIViewDeckSide)side
{
        return [self getShowingNavitagionController].viewControllers.count <= 1;
}
- (void)viewDidLoad
{
        [super viewDidLoad];
}
- (UINavigationController *)getShowingNavitagionController
{
        return self.tabbarViewController.selectedViewController;
}
- (void)addTabbarController:(__kindof UINavigationController *)vc atIndex:(NSInteger)index
{
        [self.tabbarViewController addTabBarController:vc atIndex:index];
}
- (MLSTabBarViewController *)tabbarViewController
{
        if (_tabbarViewController == nil) {
                _tabbarViewController = [[MLSTabBarViewController alloc] init];
        }
        return _tabbarViewController;
}
@end
