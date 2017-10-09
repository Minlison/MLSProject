//
//  BaseView.h
//  MLSProject
//
//  Created by MinLison on 2017/8/31.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewProtocol.h"


@interface BaseView : UIView <BaseViewProtocol>

/**
 当前视图所在的控制器
 */
@property(nonatomic, readonly, nullable, strong) UIViewController *controller;


@end
