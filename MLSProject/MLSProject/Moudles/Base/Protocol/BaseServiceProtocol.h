//
//  BaseServiceProtocol.h
//  MinLison
//
//  Created by MinLison on 2017/8/31.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 // MyProtocol.h
 @protocol MyProtocol
 @required
 - (void)someRequiredMethod;
 
 @optional
 - (void)someOptionalMethod;
 
 @concrete
 - (BOOL)isConcrete;
 
 @end
 
 // MyProtocol.m
 @concreteprotocol(MyProtocol)
 
 - (BOOL)isConcrete {
 return YES;
 }
 
 // this will not actually get added to conforming classes, since they are
 // required to have their own implementation
 - (void)someRequiredMethod {}
 
 @end
 
 */

NS_ASSUME_NONNULL_BEGIN

@protocol BaseServiceProtocol  <NSObject, BHServiceProtocol>

/**
 获取控制器

 @return 控制器
 */
- (nullable __kindof UIViewController *)getController;
@end

NS_ASSUME_NONNULL_END
