//
//  NSLogger.m
//  minlison
//
//  Created by MinLison on 2017/5/15.
//  Copyright © 2017年 MinLison. All rights reserved.
//

#import "NSLogger.h"
#import <CocoaLumberjack/CocoaLumberjack.h>

#if DEBUG
static const DDLogLevel ddLogLevel = DDLogLevelAll;
#elif ADHoc
static const DDLogLevel ddLogLevel = DDLogLevelInfo;
#else
static const DDLogLevel ddLogLevel = DDLogLevelOff;
#endif

@implementation MLSLog
+ (instancetype)shared
{
	static MLSLog *instance;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		instance = [[MLSLog alloc] init];
		[MLSLog configLogger];
	});
	return instance;
}

/**
 配置 logger
 */
+ (void)configLogger
{
	NSString *logDir = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"ddlog"];
	BOOL isDir = NO;
	if ([[NSFileManager defaultManager] fileExistsAtPath:logDir isDirectory:&isDir]) {
		if (!isDir)
		{
			[[NSFileManager defaultManager] createDirectoryAtPath:logDir withIntermediateDirectories:YES attributes:nil error:NULL];
		}
	}
	else
	{
		[[NSFileManager defaultManager] createDirectoryAtPath:logDir withIntermediateDirectories:YES attributes:nil error:NULL];
	}
	DDLogFileManagerDefault *fileManager = [[DDLogFileManagerDefault alloc] initWithLogsDirectory:logDir];
	DDFileLogger *fileLogger = [[DDFileLogger alloc] initWithLogFileManager:fileManager];
	
	fileLogger.maximumFileSize = 10 * 1024 * 1024; // 10MB
	
	[DDLog addLogger:fileLogger withLevel:(DDLogLevelDebug)];
	[DDLog addLogger:[DDTTYLogger sharedInstance] withLevel:(DDLogLevelDebug)];
	
}

- (MLSLogBlock)verbose
{
	return ^(NSString *format, ...) {
		if (format)
		{
			va_list args, args_copy;
			va_start(args, format);
			va_copy(args_copy, args);
			va_end(args);
			
			NSString *logText = [[NSString alloc] initWithFormat:format arguments:args_copy];
			DDLogVerbose(@"🗯🗯🗯%@🗯🗯🗯",logText);
			
			va_end(args_copy);
		}
	};
}

- (MLSLogBlock)info
{
	return ^(NSString *format, ...) {
		if (format)
		{
			va_list args, args_copy;
			va_start(args, format);
			va_copy(args_copy, args);
			va_end(args);
			
			NSString *logText = [[NSString alloc] initWithFormat:format arguments:args_copy];
			DDLogInfo(@"ℹ️ℹ️ℹ️%@ℹ️ℹ️ℹ️",logText);
			
			va_end(args_copy);
		}
	};
}

- (MLSLogBlock)error
{
	return ^(NSString *format, ...) {
		if (format)
		{
			va_list args, args_copy;
			va_start(args, format);
			va_copy(args_copy, args);
			va_end(args);
			
			NSString *logText = [[NSString alloc] initWithFormat:format arguments:args_copy];
			DDLogError(@"‼️‼️‼️%@‼️‼️‼️",logText);
			
			va_end(args_copy);
		}
	};
}

- (MLSLogBlock)warning
{
	return ^(NSString *format, ...) {
		if (format)
		{
			va_list args, args_copy;
			va_start(args, format);
			va_copy(args_copy, args);
			va_end(args);
			
			NSString *logText = [[NSString alloc] initWithFormat:format arguments:args_copy];
			DDLogWarn(@"⚠️⚠️⚠️%@⚠️⚠️⚠️",logText);
			
			va_end(args_copy);
		}
	};
}

- (MLSLogBlock)debug
{
	return ^(NSString *format, ...) {
		if (format)
		{
			va_list args, args_copy;
			va_start(args, format);
			va_copy(args_copy, args);
			va_end(args);
			
			NSString *logText = [[NSString alloc] initWithFormat:format arguments:args_copy];
			DDLogDebug(@"🔹🔹🔹%@🔹🔹🔹",logText);
			
			va_end(args_copy);
		}
	};
}
@end
