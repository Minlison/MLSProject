//
//  NSLogger.h
//  minlison
//
//  Created by MinLison on 2017/5/15.
//  Copyright © 2017年 MinLison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLSDebugManager.h"
/**
 日志函数宏定义
 */
#define NSLogger [CZLog shared]

/**
 日志宏定义
 */
#define NSLogVerbose(fmt, ...) 	NSLogger.verbose((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__); MLSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#define NSLogInfo(fmt, ...)     NSLogger.info((@"%s [Line %d]  "  fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__); MLSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#define NSLogDebug(fmt, ...)	NSLogger.debug((@"%s [Line %d]  "  fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__); MLSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#define NSLogWarn(fmt, ...)	NSLogger.warning((@"%s [Line %d]  "  fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__); MLSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#define NSLogError(fmt, ...) 	NSLogger.error((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__); MLSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

@class CZLog;

/**
 日志函数输出函数
 */
typedef void (^CZLogBlock)(NSString *format, ...);

/**
 日志工具
 */
@interface CZLog : NSObject

/**
 单例

 @return  CZLog 单例
 */
+ (instancetype)shared;

/**
 显示 debug 日志信息视图

 @param showDebugView 是否显示 debug 日志信息视图
 */
- (void)showDebugView:(BOOL)showDebugView;

/**
 verbose 日志级别
 */
@property (copy, nonatomic, readonly) CZLogBlock verbose;

/**
 info 日志级别
 */
@property (copy, nonatomic, readonly) CZLogBlock info;

/**
 debug 日志级别
 */
@property (copy, nonatomic, readonly) CZLogBlock debug;

/**
 warning 日志级别
 */
@property (copy, nonatomic, readonly) CZLogBlock warning;

/**
 error 日志级别
 */
@property (copy, nonatomic, readonly) CZLogBlock error;

@end
