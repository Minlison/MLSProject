//
//  BaseView.h
//  MinLison
//
//  Created by MinLison on 2017/8/31.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseControllerViewProtocol.h"
#import "BaseViewController.h"

@interface BaseControllerView : UIView <BaseControllerViewProtocol>

/**
 当前视图所在的控制器
 */
@property(nonatomic, readonly, nullable, weak) BaseViewController *controller;

- (void)setupView NS_REQUIRES_SUPER; 
@end
