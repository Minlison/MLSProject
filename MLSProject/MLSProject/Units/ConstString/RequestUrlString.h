//
//  RequestUrlString.h
//  MLSProject
//
//  Created by MinLison on 2017/9/6.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 定义字符串时, 按照 kRequestUrl 前缀加 url 首字母大写的命名规则
 */

#ifndef RequestUrlString_h
#define RequestUrlString_h
FOUNDATION_EXTERN  NSString *const kRequestUrlBaseOnline;
FOUNDATION_EXTERN  NSString *const kRequestUrlBaseTest;
FOUNDATION_EXTERN  NSString *const kRequestUrlBasePreProduct;
FOUNDATION_EXTERN  NSString *const kRequestUrlBase25;
FOUNDATION_EXTERN  NSString *const kRequestUrlBase40;
FOUNDATION_EXTERN  NSString *const kRequestUrlInter;
FOUNDATION_EXTERN  NSString *const kRequestUrlSign;

#endif
