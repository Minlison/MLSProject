//
//  AppUnit.h
//  minlison
//
//  Created by MinLison on 2017/5/16.
//  Copyright © 2017年 MinLison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLNetWorkReachability.h"

@interface AppUnit : NSObject

/**
 UA
 */
+ (NSString *)userAgentString;

/**
 请求头
 */
+ (NSDictionary *)httpheaderDict;

/**
 当前软件版本号

 @return 版本号
 */
+ (NSString *)version;

/**
 应用 APPID

 @return com.iminlison.zdd
 */
+ (NSString *)buldleID;
/**
 版本号数字字符串
 每位保留3位
 @return 1.2.1 ==> 100200100
 */
+ (NSString *)versionNumberString;

/**
 当前 build 版本号

 @return  build 版本号
 */
+ (NSString *)build;

/**
 是否是第一次启动
 */
+ (BOOL)isFirstLaunching;


/**
 当前网络状态
 */
+ (HLNetWorkStatus)currentNetworkStatus;

/**
 获取一个唯一字符串

 @return 唯一字符串
 */
+ (NSString *)getAUniqueString;

@end
