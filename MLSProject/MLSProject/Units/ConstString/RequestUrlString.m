//
//  RequestUrlString.m
//  MLSProject
//
//  Created by MinLison on 2017/9/6.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "RequestUrlString.h"

/*
 正式：https://m.weiguanapp.com
 预发布：https://pre-m.weiguanapp.com
 测试：https://test-m.weiguanapp.com
 25：http://192.168.1.25:8081
 */
NSString *const kRequestUrlBaseOnline = @"https://m.weiguanapp.com/";
NSString *const kRequestUrlBaseTest = @"https://test-m.weiguanapp.com/";
NSString *const kRequestUrlBasePreProduct = @"https://pre-m.weiguanapp.com/";
NSString *const kRequestUrlBase25 = @"http://192.168.1.25:8081/";
NSString *const kRequestUrlBase40 = @"http://192.168.1.40:8081/";




NSString *const  kRequestUrlInter = @"inter";
NSString *const  kRequestUrlSign = @"sign";
