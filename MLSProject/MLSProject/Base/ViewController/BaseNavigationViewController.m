//
//  BaseNavigationViewController.m
//  MLSProject
//
//  Created by MinLison on 2017/8/31.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseNavigationViewController.h"
#import "MLSTransition.h"
#import "BaseNavigationBar.h"
@interface BaseNavigationViewController ()

@end

@implementation BaseNavigationViewController
- (void)didInitialized
{
        [super didInitialized];
        self.transitioningDelegate = [MLSTransition shared];
        [self setValue:[[BaseNavigationBar alloc] init] forKey:@"navigationBar"];
        self.navigationBar.shadowImage = [UIImage imageWithColor:QMUICMI.whiteColor];
        self.navigationBar.backgroundColor = QMUICMI.whiteColor;

}

@end
