//
//  NSDictionary+RouterParams.h
//  MLSProject
//
//  Created by MinLison on 2017/9/12.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (RouterParams)

/**
 创建 router 的参数
 @{
        @"name" : @"a",
        @"age" : @(10)
 }
 
 return @"name=a&age=10"
 @return 字符串参数
 */
- (NSString *)routerParams;
@end
