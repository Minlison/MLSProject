//
//  MLSTimeTransform.m
//  MinLison
//
//  Created by minlison on 2017/9/28.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSTimeTransform.h"

@implementation MLSTimeTransform

+ (NSString *)TimeLableStringWithStamp:(NSString *)stamp
{
        if (!stamp || stamp.length == 0)
        {
                return @"";
        }
        //X分钟前
        //X小时前
       
        NSDate *toDate = [NSDate dateWithTimeIntervalSinceNow:0];
        
        NSDate *fromDate = [NSDate dateWithTimeIntervalSince1970:stamp.doubleValue/1000];
        
        NSTimeInterval currentInterval = [toDate timeIntervalSince1970];
        NSTimeInterval fromInterval = [fromDate timeIntervalSince1970];
        //时间差
        NSTimeInterval timeInterval = currentInterval - fromInterval;
        
        long temp = 0;
        NSString *result;
        if (timeInterval/60 < 1)
        {
                result = [NSString stringWithFormat:@"刚刚"];
        }
        else if((temp = timeInterval/60) < 60)
        {
                result = [NSString stringWithFormat:@"%ld分钟前",temp];
        }
        else if((temp = temp/60) < 24)
        {
                result = [NSString stringWithFormat:@"%ld小时前",temp];
        }
        else
        {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
                [formatter setDateStyle:NSDateFormatterMediumStyle];
                [formatter setTimeStyle:NSDateFormatterShortStyle];
                NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
                [formatter setTimeZone:timeZone];
                formatter.dateFormat = @"MM.dd";
                result = [formatter stringFromDate:fromDate];
        }
        
        return  result;
}

@end
