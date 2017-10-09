//
//  MainServiceProtocol.h
//  MLSProject
//
//  Created by MinLison on 2017/8/31.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseProtocol.h"

@protocol MainServiceProtocol <BaseProtocol>
/**
 注册控制器
 
 @param vc 控制器
 */
- (void)addController:(__kindof UIViewController *)vc atIndex:(NSInteger)index;

@end
