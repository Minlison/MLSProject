//
//  NSLogger.h
//  minlison
//
//  Created by MinLison on 2017/5/15.
//  Copyright © 2017年 MinLison. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 日志函数宏定义
 */
#define NSLogger [MLSLog shared]

/**
 日志宏定义
 */
#define NSLogVerbose(fmt, ...) 	NSLogger.verbose((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#define NSLogInfo(fmt, ...) 	NSLogger.info((@"%s [Line %d]  "  fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#define NSLogDebug(fmt, ...)	NSLogger.debug((@"%s [Line %d]  "  fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#define NSLogWarn(fmt, ...)	NSLogger.warning((@"%s [Line %d]  "  fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#define NSLogError(fmt, ...) 	NSLogger.error((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

@class MLSLog;

/**
 日志函数输出函数
 */
typedef void (^MLSLogBlock)(NSString *format, ...);

/**
 日志工具
 */
@interface MLSLog : NSObject

/**
 单例

 @return  MLSLog 单例
 */
+ (instancetype)shared;

/**
 verbose 日志级别
 */
@property (copy, nonatomic, readonly) MLSLogBlock verbose;

/**
 info 日志级别
 */
@property (copy, nonatomic, readonly) MLSLogBlock info;

/**
 debug 日志级别
 */
@property (copy, nonatomic, readonly) MLSLogBlock debug;

/**
 warning 日志级别
 */
@property (copy, nonatomic, readonly) MLSLogBlock warning;

/**
 error 日志级别
 */
@property (copy, nonatomic, readonly) MLSLogBlock error;

@end
