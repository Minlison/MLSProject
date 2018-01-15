//
//  MLSLog.m
//  MLSLogger
//
//  Created by MinLison on 16/8/18.
//  Copyright © 2016年 MinLison. All rights reserved.
//

#import "MLSLog.h"

#import "MLSLogDataManager.h"
#import "MLSDebugInstance.h"


static inline NSString *FromatDateToString(NSString *str)
{
        NSDate *now = [NSDate date];
        static dispatch_once_t onceToken;
        static NSDateFormatter *formatter;
        dispatch_once(&onceToken, ^{
                formatter = [NSDateFormatter new];
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
        });
        NSString *dateString = [formatter stringFromDate:now];
        return [dateString stringByAppendingString:str];
}

void MLSLog(NSString *format, ...)
{
        if (!format)
        {
                return;
        }
        va_list args, args_copy;
        va_start(args, format);
        va_copy(args_copy, args);
        va_end(args);
        
        NSString *logText = [[NSString alloc] initWithFormat:format arguments:args_copy];
        if ([MLSDebugInstance shareInstance].isDebug)
        {
                printf("%s\n",[FromatDateToString(logText) cStringUsingEncoding:NSUTF8StringEncoding]);
        }
        [[MLSLogDataManager shareManager] addLogStr:logText];
        
        va_end(args_copy);
}
