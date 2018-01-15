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

@implementation CZLog
+ (instancetype)shared
{
	static CZLog *instance;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		instance = [[CZLog alloc] init];
		[CZLog configLogger];
	});
	return instance;
}
- (void)showDebugView:(BOOL)showDebugView
{
        if (showDebugView)
        {
                [[MLSDebugInstance shareInstance] start];
        }
        else
        {
                [[MLSDebugInstance shareInstance] stop];
        }
}
/**
 配置 logger
 */
+ (void)configLogger
{
#if (DEBUG || ADHoc || ADHocOnline || OPEN_RIGHT_MENU)
	NSString *logDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"ddlog.log"];
#else
        NSString *logDir = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"ddlog.log"];
#endif
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
	
        [[MLSDebugInstance shareInstance] setDebug:NO];
        [MLSDebugInstance shareInstance].maxLogCount = 10000;
        [MLSDebugInstance shareInstance].maxMemory = 10 * 1024; // 10MB
}

- (CZLogBlock)verbose
{
	return ^(NSString *format, ...) {
                if (format)
                {
                        va_list args;
                        va_start(args, format);
                        
                        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
                        
                        va_end(args);
                        
                        va_start(args, format);
                        DDLogVerbose(@"🗯🗯🗯%@🗯🗯🗯",message);
                        va_end(args);
                }
	};
}

- (CZLogBlock)info
{
	return ^(NSString *format, ...) {
                if (format)
                {
                        va_list args;
                        va_start(args, format);
                        
                        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
                        
                        va_end(args);
                        
                        va_start(args, format);
                        DDLogInfo(@"ℹ️ℹ️ℹ️%@ℹ️ℹ️ℹ️",message);
                        va_end(args);
                }
	};
}

- (CZLogBlock)error
{
	return ^(NSString *format, ...) {
                if (format)
                {
                        va_list args;
                        va_start(args, format);
                        
                        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
                        
                        va_end(args);
                        
                        va_start(args, format);
                        DDLogError(@"‼️‼️‼️%@‼️‼️‼️",message);
                        va_end(args);
                }
	};
}

- (CZLogBlock)warning
{
	return ^(NSString *format, ...) {
                if (format)
                {
                        va_list args;
                        va_start(args, format);
                        
                        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
                        
                        va_end(args);
                        
                        va_start(args, format);
                        DDLogWarn(@"⚠️⚠️⚠️%@⚠️⚠️⚠️",message);
                        va_end(args);
                }
	};
}

- (CZLogBlock)debug
{
	return ^(NSString *format, ...) {
                if (format)
                {
                        va_list args;
                        va_start(args, format);
                        
                        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
                        
                        va_end(args);
                        
                        va_start(args, format);
                        DDLogDebug(@"🔹🔹🔹%@🔹🔹🔹",message);
                        va_end(args);
                }
	};
}
@end
