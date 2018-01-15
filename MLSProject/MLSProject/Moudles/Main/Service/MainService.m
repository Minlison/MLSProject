//
//  MainService.m
//  MinLison
//
//  Created by MinLison on 2017/8/31.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MainService.h"
#import "MainViewController.h"

@SERVICE_REGISTER(MainServiceProtocol, MainService)

@interface MainService ()
@property(nonatomic, strong) MainViewController *mainViewController;
@property(nonatomic, assign, getter=isMenuAnimation) BOOL menuAnimating;
@end

@implementation MainService

- (UIViewController *)getController
{
        return self.mainViewController;
}

+ (BOOL)singleton
{
        return YES;
}
+ (id)sharedInstance {
        static dispatch_once_t onceToken;
        static MainService *instance = nil;
        dispatch_once(&onceToken,^{
                instance = [[self alloc] init];
        });
        return instance;
}
- (void)setLeftMenuController:(__kindof UIViewController *)vc
{
        if (vc && self.mainViewController.openSide != IIViewDeckSideLeft)
        {
                self.mainViewController.leftViewController = vc;
        }
}
- (void)setRightMenuController:(__kindof UIViewController *)vc
{
        if (vc && self.mainViewController.openSide != IIViewDeckSideRight)
        {
                self.mainViewController.rightViewController = vc;
        }
}
- (void)addTabBarController:(__kindof UINavigationController *)vc atIndex:(NSInteger)index
{
        [self.mainViewController addTabbarController:vc atIndex:index];
}
- (void)openLeftMenu:(BOOL)animation completion:(void (^ __nullable )(BOOL canceled))completion
{
        if ( !self.isMenuAnimation )
        {
                self.menuAnimating = YES;
                [self.mainViewController openSide:(IIViewDeckSideLeft) animated:YES completion:^(BOOL cancelled) {
                        if (completion) {
                                completion(cancelled);
                        }
                        self.menuAnimating = NO;
                }];
        }
}

- (void)closeMenu:(BOOL)animation andPushViewController:(__kindof UIViewController *)vc
{
        if ( !self.isMenuAnimation )
        {
                self.menuAnimating = YES;
                [self.mainViewController closeSide:animation completion:^(BOOL cancelled) {
                        if (!cancelled && vc)
                        {
                                [[self.mainViewController getShowingNavitagionController] pushViewController:vc animated:YES];
                        }
                        self.menuAnimating = NO;
                }];
        }
        
}

- (void)closeMenu:(BOOL)animation andPresentViewController:(__kindof UIViewController *)vc completion:(void (^ __nullable)(void))completion
{
        if ( !self.isMenuAnimation )
        {
                self.menuAnimating = YES;
                [self.mainViewController closeSide:animation completion:^(BOOL cancelled) {
                        if (!cancelled && vc)
                        {
                                [[self.mainViewController getShowingNavitagionController].topViewController presentViewController:vc animated:YES completion:^{
                                        self.menuAnimating = NO;
                                }];
                        }
                        else
                        {
                                self.menuAnimating = NO;
                        }
                }];
        }
}
- (void)closeMenu:(BOOL)animation completion:(void (^ __nullable)(BOOL cancelled))completion
{
        if ( !self.isMenuAnimation && self.mainViewController.openSide != IIViewDeckSideNone)
        {
                self.menuAnimating = YES;
                [self.mainViewController closeSide:animation completion:^(BOOL cancelled) {
                        if (completion)
                        {
                                completion(cancelled);
                        }
                        self.menuAnimating = NO;
                }];
        }
}
- (MainViewController *)mainViewController
{
        if (_mainViewController == nil) {
                _mainViewController = [[MainViewController alloc] init];
        }
        return _mainViewController;
}
@end
