//
//  AppUnit.m
//  minlison
//
//  Created by MinLison on 2017/5/16.
//  Copyright © 2017年 MinLison. All rights reserved.
//

#import "AppUnit.h"
#import "RMUUid.h"
@implementation AppUnit
+ (void)load
{
        [[HLNetWorkReachability shareManager] startNotifier];
}
+ (NSString *)userAgentString
{
        NSDictionary *infoDictionary =[[NSBundle mainBundle] infoDictionary];
        UIDevice *device = [UIDevice currentDevice];

        NSMutableString *stringM = [NSMutableString stringWithFormat:@"MLSProject IOS V%@",[infoDictionary valueForKey:@"CFBundleShortVersionString"]];
        
        /** 系统 */
        [stringM appendFormat:@"(%@;",device.systemName];
        /** 系统版本 */
        [stringM appendFormat:@" %@ %@;",device.systemName, device.systemVersion];
        /** 手机品牌 */
        [stringM appendFormat:@" %@;",device.model];
        /** 手机型号 */
        NSString *platformBuild = [infoDictionary valueForKey:@"DTPlatformBuild"];
        /// 手机名称
        [stringM appendFormat:@"%@ Build/%@;",[UIDevice currentDevice].machineModelName,platformBuild];
        /// UUID
        [stringM appendFormat:@"%@",[RMUUid getUUid]];
        
        [stringM appendFormat:@")"];
        
        return stringM.copy;
}

+ (NSString *)access
{
        NSString *netDes = @"无网络访问";
        switch ([HLNetWorkReachability shareManager].currentReachabilityStatus)
        {
                case HLNetWorkStatusWWAN2G:
                        netDes = @"2G";
                        break;
                case HLNetWorkStatusWWAN3G:
                        netDes = @"3G";
                        break;
                case HLNetWorkStatusWWAN4G:
                        netDes = @"4G";
                        break;
                case HLNetWorkStatusWiFi:
                        netDes = @"WiFi";
                        break;
                case HLNetWorkStatusUnknown:
                        netDes = @"未知网络";
                        break;
                default:
                        netDes = @"无网络";
                        break;
                        
        }
        return netDes;
}
+ (NSDictionary *)httpheaderDict
{
        NSDictionary *infoDictionary =[[NSBundle mainBundle] infoDictionary];
        UIDevice *device = [UIDevice currentDevice];
        return @{
                 @"minlison" : @"2",
                 @"access" : [self access],
                 @"app-version" : [infoDictionary valueForKey:@"CFBundleShortVersionString"],
                 @"os-version" : [device machineModelName],
                 @"os-api" : device.systemVersion,
                 @"device-model" : [device machineModel],
                 @"device-brand" : @"iPhone",
                 @"package-name" : [infoDictionary valueForKey:@"CFBundleIdentifier"],
                 @"imei" : [RMUUid getUUid],
                 @"devices_id" : [RMUUid getUUid]
                 };
}

+ (NSString *)version
{
        NSString *obj = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        return [NSString stringWithFormat:@"%@",obj];
}
+ (NSString *)buldleID
{
        return [NSString jk_identifier];
}
+ (NSString *)versionNumberString
{
        NSString *version = [self version];
        NSArray <NSString *>*versionComponents = [version componentsSeparatedByString:@"."];
        NSMutableString *versionM = [[NSMutableString alloc] init];
        [versionComponents enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx == 0)
                {
                        [versionM appendFormat:@"%@",obj];
                }
                else
                {
                        [versionM appendFormat:@"%03d",(int)obj.integerValue];
                }
        }];
        return versionM.copy;
}
+ (NSString *)build
{
        NSString *obj =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        return [NSString stringWithFormat:@"%@",obj];
}
/**
 是否是第一次启动
 */
+ (BOOL)isFirstLaunching
{
        BOOL firstLaunching = NO;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *lastAppVersion = [userDefaults objectForKey:@"AppUnitLastAppVersion"];
        
        NSString *currentAppVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        
        if (![currentAppVersion isEqualToString:lastAppVersion])
        {
                [userDefaults setValue:currentAppVersion forKey:@"AppUnitLastAppVersion"];
                [userDefaults synchronize];
                
                firstLaunching = YES;
        }
        
        return firstLaunching;
}

+ (HLNetWorkStatus)currentNetworkStatus
{
        return [HLNetWorkReachability shareManager].currentReachabilityStatus;
}
+ (NSString *)getAUniqueString
{
        NSString *deviceID = [RMUUid getUUid];
        NSString *uniqueString = [[NSString stringWithFormat:@"%@_%lld-%d",deviceID,(long long)[[NSDate date] timeIntervalSince1970],arc4random()] md5String];
        uniqueString = [NSString stringWithFormat:@"%@_%lld",uniqueString,(long long)([[NSDate date] timeIntervalSince1970] * 1000)];
        return uniqueString;
}
+ (NSString *)getSizeStringWithBytes:(NSUInteger)bytes
{
        NSString *tmp = @"0KB";
        // GB
        if (bytes > (2 << 30))
        {
                tmp = [NSString stringWithFormat:@"%.2fGB",(CGFloat)(bytes * 1.0) / (1 << 30)];
        }
        // MB
        else if (bytes > (1 << 20))
        {
                tmp = [NSString stringWithFormat:@"%.2fMB",(CGFloat)(bytes * 1.0) / (1 << 20)];
        }
        // KB
        else if (bytes > 0)
        {
                tmp = [NSString stringWithFormat:@"%.2fKB",(CGFloat)(bytes * 1.0) / (1 << 10)];
        }
        return tmp;
}
+ (NSString *)formatGMT8TimeMillisecond:(NSTimeInterval)timeMillisecond withFormat:(NSString *)fomat
{
        NSDate *date = [NSDate date];
        if (timeMillisecond > 1)
        {
                date = [NSDate dateWithTimeIntervalSince1970:timeMillisecond*0.001];
        }
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
        formatter.dateFormat = fomat;
        return [formatter stringFromDate:date];
}
+ (id)getInstanceFromClassName:(NSString *)className
{
        if (!NULLString(className) || !NSClassFromString(className))
        {
                return nil;
        }
        return [[NSClassFromString(className) alloc] init];
}

@end
