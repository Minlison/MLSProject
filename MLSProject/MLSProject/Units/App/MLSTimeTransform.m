//
//  MLSTimeTransform.m
//  MLSProject
//
//  Created by MinLison on 2017/10/9.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSTimeTransform.h"

@implementation MLSTimeTransform

+ (NSString *)TimeLabelStringWithTimeStamp:(NSString *)stamp {
        
        NSDate *toDate = [NSDate dateWithTimeIntervalSinceNow:0];
        
        NSDate *fromDate = [NSDate dateWithTimeIntervalSince1970:stamp.doubleValue];
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        
        NSDateComponents *fromCompents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:fromDate];
        
        NSDateComponents *toCompents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:toDate];
        
        NSInteger yearCompare = toCompents.year = fromCompents.year;
        NSInteger monthCompare = toCompents.month - fromCompents.month;
        NSInteger dayCompare = toCompents.day - fromCompents.day;
        
        NSString *timeStr = @"今天";
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
        [formatter setTimeZone:timeZone];
        
        if (dayCompare <= 0 && monthCompare <= 0 & yearCompare <= 0) {
                timeStr = @"今天";
        }else if (dayCompare > 0 & yearCompare <= 0) {
                formatter.dateFormat = @"MM.dd";
                timeStr = [formatter stringFromDate:fromDate];
        }else if (yearCompare > 0) {
                formatter.dateFormat = @"20yy.MM.dd";
                timeStr = [formatter stringFromDate:fromDate];
        }
        return timeStr;
}

@end
