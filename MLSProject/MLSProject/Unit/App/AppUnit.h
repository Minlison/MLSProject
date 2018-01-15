//
//  AppUnit.h
//  minlison
//
//  Created by MinLison on 2017/5/16.
//  Copyright © 2017年 MinLison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLNetWorkReachability.h"
@class LNVipServiceKindModel;
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

/**
 从字节单位的大小中, 获取相应大小的描述

 @param bytes 字节大小
 @return 相应大小的描述
 */
+ (NSString *)getSizeStringWithBytes:(NSUInteger)bytes;

/**
 格式化时间中国时区的时间
 
 @param timeMillisecond  timeSince1970 毫秒
 @param fomat 格式
 @return 格式化后的时间
 */
+ (NSString *)formatGMT8TimeMillisecond:(NSTimeInterval)timeMillisecond withFormat:(NSString *)fomat;

/**
 从 ClassName 创建对象

 @return instance
 */
+ (id)getInstanceFromClassName:(NSString *)className;
@end
