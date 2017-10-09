//
//  CoBaseUtils.h
//  MLSProject
//
//  Created by MinLison on 17-10-9.
//  Copyright (c) 2014年 No. All rights reserved.
//

#import <UIKit/UIkit.h>

typedef NS_OPTIONS(NSUInteger, iPhoneType)
{
        iPhoneType4   = 1 << 0,
        iPhoneType4S  = 1 << 1,
        
        iPhoneType5   = 1 << 2,
        iPhoneType5C  = 1 << 3,
        iPhoneType5S  = 1 << 4,
        iPhoneType5SE = 1 << 5,
        
        iPhoneType6   = 1 << 6,
        iPhoneType6S  = 1 << 7,
        iPhoneType6P  = 1 << 8,
        iPhoneType6SP = 1 << 9,
        
        iPhoneType7   = 1 << 10,
        iPhoneType7P  = 1 << 11,
        
        iPhoneType8  = 1 << 12,
        iPhoneType8P  = 1 << 13,
        iPhoneTypeX  = 1 << 14,
        /**
         * 3.5英寸
         */
        iPhoneTypeInches_3_5 = iPhoneType4 | iPhoneType4S,
        /**
         * 4.0英寸
         */
        iPhoneTypeInches_4_0 = iPhoneType5 | iPhoneType5C | iPhoneType5S | iPhoneType5SE,
        /**
         * 4.7英寸
         */
        iPhoneTypeInches_4_7 = iPhoneType6 | iPhoneType6S | iPhoneType7 | iPhoneType8,
        /**
         * 5.5英寸
         */
        iPhoneTypeInches_5_5 = iPhoneType6P | iPhoneType6SP | iPhoneType7P | iPhoneType8P,
        /**
         * 5.8英寸
         */
        iPhoneTypeInches_5_8 = iPhoneTypeX,
};

@interface CoBaseUtils : NSObject

+ (BOOL)isPhoneType:(iPhoneType)type;

/**
 系统版本号大于或等于

 @param version 版本号
 @return 是否大于或等于
 */
+ (BOOL)isOSVersionGreaterThanOrEqualTo:(CGFloat)version;


/**
 是否是中国手机号

 @param mobileNum 手机号
 */
+(BOOL)isChinaPhoneNumber:(NSString *)mobileNum;

/**
 是否不是以 0 开头的数字字符串

 @param str 字符串
 */
+ (BOOL)isNotBeginWithZeroNumber:(NSString *)str;

/**
 是否是存数字

 @param str 字符串
 */
+ (BOOL)isNumber:(NSString *)str;

/**
 小数点后只有两位

 @param str 字符串
 */
+ (BOOL)onlyTwoPoint:(NSString *)str;

/**
 删除最后一个字符

 @param temp 字符串
 @return 修改后的字符串
 */
+ (NSString *)deleteLastChar:(NSString *)temp;

/**
 删除字符串到 指定长度

 @param length 指定长度
 @param string 字符串
 @return 修改后的字符串
 */
+ (NSString *)deleteThanLength:(NSInteger)length string:(NSString *)string;

/**
 * 保留几位小数
 */
+ (NSString *)retainDotCount:(NSInteger)count string:(NSString *)string;

/**
 进度表示

 @param current 当前进度数量
 @param total 总共的数量
 @return @"%.0f"
 */
+ (NSString *)progress:(CGFloat)current total:(CGFloat)total;

/**
 是否是第一次启动
 */
+ (BOOL)isFirstLaunching;
@end
