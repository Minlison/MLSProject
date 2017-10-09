//
//  MLSTimeFormatter.h
//  MLSProject
//
//  Created by MinLison on 2017/9/21.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MLSTimeZone)
{
        MLSTimeZoneShangHai, // 上海时区(中国)
        MLSTimeZoneGMT, // 格林威治时区
        MLSTimeZoneSystem, // 系统时区
};

FOUNDATION_EXTERN NSString *const MLSDefaultFormatString;

@interface MLSTimeFormatter : NSObject

/**
 服务器时间

 @param formatTime 服务器格式化后的时间
 @return  NSDate
 */
+ (NSDate *)serverDateFromFormatTime:(NSString *)formatTime;

/**
 服务器返回的时间时间戳

 @param formatTime 服务器格式化后的时间
 @return TimeInterval
 */
+ (NSTimeInterval)serverTimeIntervalFromFormatTime:(NSString *)formatTime;

@end
