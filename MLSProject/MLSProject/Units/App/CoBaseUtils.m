//
//  CoBaseUtils.m
//  MLSProject
//
//  Created by MinLison on 17-10-9.
//  Copyright (c) 2014年 No. All rights reserved.
//

#import "CoBaseUtils.h"
#import <sys/sysctl.h>

#define __HEIGHT_3_5__  (480.0)
#define __HEIGHT_4_0__  (568.0)
#define __HEIGHT_4_7__  (667.0)
#define __HEIGHT_5_5__  (736.0)
#define __HEIGHT_5_8__  (812.0)


@interface UIDevice (HardwareModel)

/**
 *	Returns hardware name of device instance
 */
- (NSString *)hardwareName;


@end

@implementation CoBaseUtils

+ (BOOL)isPhoneType:(iPhoneType)type
{
        NSString* name = [[UIDevice currentDevice] hardwareName];
        CGFloat height = MAX([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
        BOOL isEffective = NO;
        if (type == iPhoneType4)
        {
                isEffective = [self hardwareHeight:height iPhoneHeight:__HEIGHT_3_5__ hardwareName:name iPhoneName:@"iPhone 4"];
        }
        else if (type == iPhoneType4S)
        {
                isEffective = [self hardwareHeight:height iPhoneHeight:__HEIGHT_3_5__ hardwareName:name iPhoneName:@"iPhone 4S"];
        }
        else if (type == iPhoneType5)
        {
                isEffective = [self hardwareHeight:height iPhoneHeight:__HEIGHT_4_0__ hardwareName:name iPhoneName:@"iPhone 5"];
        }
        else if (type == iPhoneType5C)
        {
                isEffective = [self hardwareHeight:height iPhoneHeight:__HEIGHT_4_0__ hardwareName:name iPhoneName:@"iPhone 5c"];
        }
        else if (type == iPhoneType5S)
        {
                isEffective = [self hardwareHeight:height iPhoneHeight:__HEIGHT_4_0__ hardwareName:name iPhoneName:@"iPhone 5s"];
        }
        else if (type == iPhoneType5SE)
        {
                isEffective = [self hardwareHeight:height iPhoneHeight:__HEIGHT_4_0__ hardwareName:name iPhoneName:@"iPhone SE"];
        }
        else if (type == iPhoneType6)
        {
                isEffective = [self hardwareHeight:height iPhoneHeight:__HEIGHT_4_7__ hardwareName:name iPhoneName:@"iPhone 6"];
        }
        else if (type == iPhoneType6S)
        {
                isEffective = [self hardwareHeight:height iPhoneHeight:__HEIGHT_4_7__ hardwareName:name iPhoneName:@"iPhone 6s"];
        }
        else if (type == iPhoneType6P)
        {
                isEffective = [self hardwareHeight:height iPhoneHeight:__HEIGHT_5_5__ hardwareName:name iPhoneName:@"iPhone 6 Plus"];
        }
        else if (type == iPhoneType6SP)
        {
                isEffective = [self hardwareHeight:height iPhoneHeight:__HEIGHT_5_5__ hardwareName:name iPhoneName:@"iPhone 6s Plus"];
        }
        else if (type == iPhoneType7)
        {
                isEffective = [self hardwareHeight:height iPhoneHeight:__HEIGHT_4_7__ hardwareName:name iPhoneName:@"iPhone 7"];
        }
        else if (type == iPhoneType7P)
        {
                isEffective = [self hardwareHeight:height iPhoneHeight:__HEIGHT_5_5__ hardwareName:name iPhoneName:@"iPhone 7 Plus"];
        }
        else if (type == iPhoneType8)
        {
                isEffective = [self hardwareHeight:height iPhoneHeight:__HEIGHT_4_7__ hardwareName:name iPhoneName:@"iPhone 8"];
        }
        else if (type == iPhoneType8P)
        {
                isEffective = [self hardwareHeight:height iPhoneHeight:__HEIGHT_4_7__ hardwareName:name iPhoneName:@"iPhone 8 Plus"];
        }
        else if (type == iPhoneTypeX)
        {
                isEffective = [self hardwareHeight:height iPhoneHeight:__HEIGHT_4_7__ hardwareName:name iPhoneName:@"iPhone X"];
        }
        else if (type == iPhoneTypeInches_3_5)
        {
                isEffective = (ABS(height - __HEIGHT_3_5__) < 1);
        }
        else if (type == iPhoneTypeInches_4_0)
        {
                isEffective = (ABS(height - __HEIGHT_4_0__) < 1);
        }
        else if (type == iPhoneTypeInches_4_7)
        {
                isEffective = (ABS(height - __HEIGHT_4_7__) < 1);
        }
        else if (type == iPhoneTypeInches_5_5)
        {
                isEffective = (ABS(height - __HEIGHT_5_5__) < 1);
        }
        else if (type == iPhoneTypeInches_5_8)
        {
                isEffective = (ABS(height - __HEIGHT_5_8__) < 1);
        }
        
        return isEffective;
}

+ (BOOL)hardwareHeight:(CGFloat)hardwareHeight iPhoneHeight:(CGFloat)iPhoneHeight hardwareName:(NSString *)hardwareName iPhoneName:(NSString *)iPhoneName
{
        return ([hardwareName isEqualToString:iPhoneName]);
}

//判断系统版本是否是ios8.0以上
#define VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
+ (BOOL)isOSVersionGreaterThanOrEqualTo:(CGFloat)version
{
        return VERSION >= version;
}

#pragma mark - 修改正则表达式,判断手机号码是否合法
+ (BOOL)isChinaPhoneNumber:(NSString*)mobileNum
{
        /**
         *  香港（区号852）
         */
        NSString * HK= @"^[1-9]\\d{7}$";
        
        /**
         *  澳门(区号853)
         */
        NSString * MACAO = @"^[1-9]\\d{7}$";
        
        /**
         *  台湾（区号886)
         */
        NSString * TAIWAN = @"^09\\d{8}$";
        
        /**
         *  大陆手机号，11位纯数字
         */
        NSString * MOBILE = @"^1\\d{10}$";
        
        NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
        NSPredicate *regextest_hk = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", HK];
        NSPredicate *regextest_mc = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MACAO];
        NSPredicate *regextest_tw = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", TAIWAN];
        
        if (([regextestmobile evaluateWithObject:mobileNum] == YES)
            || ([regextest_mc evaluateWithObject:mobileNum] == YES)
            || ([regextest_tw evaluateWithObject:mobileNum] == YES)
            || ([regextest_hk evaluateWithObject:mobileNum] == YES))
        {
                return YES;
        }
        else
        {
                return NO;
        }
}


+ (NSString *)validString:(id)value
{
        if (NULLString(value))
        {
                return @"";
        }
        return value;
}
// 不是以0开头的纯数字
+ (BOOL)isNotBeginWithZeroNumber:(NSString *)str
{
	NSString * numberStr = @"^([1-9]{1})([0-9]*)$";
	NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberStr];
	return  [regextestmobile evaluateWithObject:str];
}
#pragma mark - 是否是纯数字
+ (BOOL)isNumber:(NSString *)str
{
        NSString * numberStr = @"^[0-9]*$";
        NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberStr];
        return  [regextestmobile evaluateWithObject:str];
}
+ (BOOL)onlyTwoPoint:(NSString *)str
{
	NSString * numberStr = @"^([1-9]{1})([0-9]{0,5})(\\.(\\d{1,2})?)?$";
	NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberStr];
	return  [regextestmobile evaluateWithObject:str];
}
+ (NSString *)deleteLastChar:(NSString *)temp
{
        if (NULLString(temp))
        {
                return @"";
        }
        return [temp stringByReplacingCharactersInRange:NSMakeRange(temp.length - 1, 1) withString:@""];
}

+ (NSString *)deleteThanLength:(NSInteger)length string:(NSString *)string
{
        if (NULLString(string))
        {
                return @"";
        }
        
        NSString *tempStr = string;
        if (tempStr.length > length)
        {
                tempStr = [tempStr stringByReplacingCharactersInRange:NSMakeRange(length, tempStr.length - length) withString:@""];
        }
        return tempStr;
}

/**
 * 保留几位小数
 */
+ (NSString *)retainDotCount:(NSInteger)count string:(NSString *)string
{
        if (NULLString(string))
        {
                return @"";
        }
        if (![string containsString:@"."])
        {
                return string;
        }
        
        NSInteger strLength = string.length;
        NSRange dotRange = [string rangeOfString:@"."];
        NSUInteger dotNext = dotRange.location + dotRange.length;
        
        if ((strLength - dotNext) > count)
        {
                NSUInteger validLength = dotNext + count;
                NSRange range = NSMakeRange(validLength, strLength - validLength);
                return [string stringByReplacingCharactersInRange:range withString:@""];
        }
        return string;
}
+ (NSString *)progress:(CGFloat)current total:(CGFloat)total
{
	CGFloat progress = current / total;
	return [[NSString stringWithFormat:@"%.0f", ceil(progress * 100)] stringByAppendingString:@"%"];
}
+ (BOOL)isFirstLaunching
{
	BOOL firstLaunching = NO;
        NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"LastAppVersion"];
	NSString *lastAppVersion = [userDefaults objectForKey:@"LastAppVersion"];
	
	NSString *currentAppVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
	
	if (![currentAppVersion isEqualToString:lastAppVersion])
	{
		[userDefaults setValue:currentAppVersion forKey:@"LastAppVersion"];
		[userDefaults synchronize];
		
		firstLaunching = YES;
	}
	
	return firstLaunching;
}
@end


@implementation UIDevice (HardwareModel)

- (NSString *)hardwareName
{
	static dispatch_once_t one;
	static NSString *name;
	dispatch_once(&one, ^{
		NSString *model = [self machineModel];
		if (!model) return;
		NSDictionary *dic = @{
				      @"Watch1,1" : @"MinLison Watch",
				      @"Watch1,2" : @"MinLison Watch",
				      
				      @"iPod1,1" : @"iPod touch 1",
				      @"iPod2,1" : @"iPod touch 2",
				      @"iPod3,1" : @"iPod touch 3",
				      @"iPod4,1" : @"iPod touch 4",
				      @"iPod5,1" : @"iPod touch 5",
				      @"iPod7,1" : @"iPod touch 6",
				      
				      @"iPhone1,1" : @"iPhone 1G",
				      @"iPhone1,2" : @"iPhone 3G",
				      @"iPhone2,1" : @"iPhone 3GS",
				      @"iPhone3,1" : @"iPhone 4 (GSM)",
				      @"iPhone3,2" : @"iPhone 4",
				      @"iPhone3,3" : @"iPhone 4 (CDMA)",
				      @"iPhone4,1" : @"iPhone 4S",
				      @"iPhone5,1" : @"iPhone 5",
				      @"iPhone5,2" : @"iPhone 5",
				      @"iPhone5,3" : @"iPhone 5c",
				      @"iPhone5,4" : @"iPhone 5c",
				      @"iPhone6,1" : @"iPhone 5s",
				      @"iPhone6,2" : @"iPhone 5s",
				      @"iPhone7,1" : @"iPhone 6 Plus",
				      @"iPhone7,2" : @"iPhone 6",
				      @"iPhone8,1" : @"iPhone 6s",
				      @"iPhone8,2" : @"iPhone 6s Plus",
				      @"iPhone8,4" : @"iPhone SE",
				      @"iPhone9,1" : @"iPhone 7",
				      @"iPhone9,2" : @"iPhone 7 Plus",
				      @"iPhone9,3" : @"iPhone 7",
				      @"iPhone9,4" : @"iPhone 7 Plus",
                                      @"iPhone10,1" : @"iPhone 8",
                                      @"iPhone10,2" : @"iPhone 8 Plus",
                                      @"iPhone10,4" : @"iPhone 8",
                                      @"iPhone10,5" : @"iPhone 8 Plus",
                                      @"iPhone10,3" : @"iPhone X",
                                      @"iPhone10,6" : @"iPhone X",
                                      
                                      
				      @"iPad1,1" : @"iPad 1",
				      @"iPad2,1" : @"iPad 2 (WiFi)",
				      @"iPad2,2" : @"iPad 2 (GSM)",
				      @"iPad2,3" : @"iPad 2 (CDMA)",
				      @"iPad2,4" : @"iPad 2",
				      @"iPad2,5" : @"iPad mini 1",
				      @"iPad2,6" : @"iPad mini 1",
				      @"iPad2,7" : @"iPad mini 1",
				      @"iPad3,1" : @"iPad 3 (WiFi)",
				      @"iPad3,2" : @"iPad 3 (4G)",
				      @"iPad3,3" : @"iPad 3 (4G)",
				      @"iPad3,4" : @"iPad 4",
				      @"iPad3,5" : @"iPad 4",
				      @"iPad3,6" : @"iPad 4",
				      @"iPad4,1" : @"iPad Air",
				      @"iPad4,2" : @"iPad Air",
				      @"iPad4,3" : @"iPad Air",
				      @"iPad4,4" : @"iPad mini 2",
				      @"iPad4,5" : @"iPad mini 2",
				      @"iPad4,6" : @"iPad mini 2",
				      @"iPad4,7" : @"iPad mini 3",
				      @"iPad4,8" : @"iPad mini 3",
				      @"iPad4,9" : @"iPad mini 3",
				      @"iPad5,1" : @"iPad mini 4",
				      @"iPad5,2" : @"iPad mini 4",
				      @"iPad5,3" : @"iPad Air 2",
				      @"iPad5,4" : @"iPad Air 2",
				      @"iPad6,3" : @"iPad Pro (9.7 inch)",
				      @"iPad6,4" : @"iPad Pro (9.7 inch)",
				      @"iPad6,7" : @"iPad Pro (12.9 inch)",
				      @"iPad6,8" : @"iPad Pro (12.9 inch)",
				      
				      @"MinLisonTV2,1" : @"MinLison TV 2",
				      @"MinLisonTV3,1" : @"MinLison TV 3",
				      @"MinLisonTV3,2" : @"MinLison TV 3",
				      @"MinLisonTV5,3" : @"MinLison TV 4",
				      
				      @"i386" : @"Simulator x86",
				      @"x86_64" : @"Simulator x64",
				      };
		name = dic[model];
		if (!name) name = model;
	});
	return name;
}
- (NSString *)machineModel {
	static dispatch_once_t one;
	static NSString *model;
	dispatch_once(&one, ^{
		size_t size;
		sysctlbyname("hw.machine", NULL, &size, NULL, 0);
		char *machine = malloc(size);
		sysctlbyname("hw.machine", machine, &size, NULL, 0);
		model = [NSString stringWithUTF8String:machine];
		free(machine);
	});
	return model;
}

@end
