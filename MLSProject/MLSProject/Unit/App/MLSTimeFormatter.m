//
//  MLSTimeFormatter.m
//  MinLison
//
//  Created by MinLison on 2017/9/21.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSTimeFormatter.h"
@interface MLSTimeFormatter ()
/**
 传入格式化后的字符串, 返回时间对象
 
 @param formatString 上海(北京)时区的格式化后的字符串
 @param format 格式化方式 yyyy-MM-dd HH:mm:ss
 @param timeZone 时区, 枚举值
 @return 日期
 */
+ (NSDate *)dateFormFormatTimeString:(NSString *)formatString format:(NSString *)format timeZone:(WGTimeZone)timeZone;

/**
 传入格式化后的字符串, 返回时间戳
 
 @param formatString 上海(北京)时区的格式化后的字符串
 @param format 格式化方式 yyyy-MM-dd HH:mm:ss
 @param timeZone 时区, 枚举值
 @return 日期
 */
+ (NSTimeInterval)timeIntervalFromFormatTimeString:(NSString *)formatString format:(NSString *)format timeZone:(WGTimeZone)timeZone;
@end

@implementation MLSTimeFormatter

/// MARK: - Public Method
+ (NSDate *)serverDateFromFormatTime:(NSString *)formatTime
{
        NSDate *date = [self dateFormFormatTimeString:formatTime format:WGDefaultFormatString timeZone:(WGTimeZoneShangHai)];
        return date;
}
+ (NSTimeInterval)serverTimeIntervalFromFormatTime:(NSString *)formatTime
{
        return [[self serverDateFromFormatTime:formatTime] timeIntervalSince1970];
}
/// MARK: - PrivateMethod
+ (NSTimeZone *)getTimeZone:(WGTimeZone)timeZone
{
        switch (timeZone)
        {
                case WGTimeZoneShangHai:
                {
                        return [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
                }
                        break;
                case WGTimeZoneGMT:
                {
                        return [NSTimeZone timeZoneForSecondsFromGMT:0];
                }
                        break;
                case WGTimeZoneSystem:
                {
                        return [NSTimeZone timeZoneForSecondsFromGMT:0];
                }
                        break;
                default:
                {
                        [NSTimeZone resetSystemTimeZone];
                        return [NSTimeZone systemTimeZone];
                }
                        break;
        }
}
+ (NSDateFormatter *)getDateFormateter:(NSString *)format timeZone:(WGTimeZone)timeZone
{
        return [NSDateFormatter jk_dateFormatterWithFormat:format timeZone:[self getTimeZone:timeZone]];
}

+ (NSDate *)dateFormFormatTimeString:(NSString *)formatString format:(NSString *)format timeZone:(WGTimeZone)timeZone
{
        NSDateFormatter *formatter = [self getDateFormateter:format timeZone:timeZone];
        NSDate *date = [formatter dateFromString:formatString];
        return date;
}
+ (NSTimeInterval)timeIntervalFromFormatTimeString:(NSString *)formatString format:(NSString *)format timeZone:(WGTimeZone)timeZone
{
        return [[self dateFormFormatTimeString:formatString format:format timeZone:timeZone] timeIntervalSince1970];
}


@end


NSString *const WGDefaultFormatString = @"yyyy-MM-dd HH:mm:ss";
