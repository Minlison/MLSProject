//
//  MarcoDefine.h
//  MLSProject
//
//  Created by MinLison on 16/12/15.
//  Copyright © 2016年 . All rights reserved.
//

#ifndef BBMarcoDefine_h
#define BBMarcoDefine_h
#import <Foundation/Foundation.h>

/**
 * 空字符串判断
 */
#define NULLString(string) ((string == nil) || ([string isKindOfClass:[NSNull class]]) || (![string isKindOfClass:[NSString class]])||[string isEqualToString:@""] || [string isEqualToString:@"<null>"] || [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]== 0 )

#define NULLObject(obj) (obj == nil || obj == [NSNull null] || ([obj isKindOfClass:[NSString class]] && NULLString((NSString *)obj)))

#define ERROR_DES(des) [NSError errorWithDomain:NSURLErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey : des}]

#define INTEGRE_TO_STRING(A)			[NSString stringWithFormat:@"%ld",(long)(A)]
#define UINTEGRE_TO_STRING(A)			[NSString stringWithFormat:@"%lu",(unsigned long)(A)]
#define INT_TO_STRING(A)			[NSString stringWithFormat:@"%d",(int)(A)]
#define FLOAT_TO_STR(A)				[NSString stringWithFormat:@"%.2f",(double)(A)]
#define NUM_TO_STR(A)				[NSString stringWithFormat:@"%@",NULLString(A) ? @(0) : A]
#define NONNULL_STR(A)				[NSString stringWithFormat:@"%@",NULLString(A) ? @"" : A]
#define NONNULL_STR_DEFAULT(A,D)		[NSString stringWithFormat:@"%@",NULLString(A) ? D : A]

#define COMBAIN_STRING(A,B) [NSString stringWithFormat:@"%@%@",A,B]
#define INSERT_FIRST(A,B) COMBAIN_STRING((A),(B))
#define FORMAT_STR(fmt,...) [NSString stringWithFormat:fmt,##__VA_ARGS__]
#define NO_ZERO(A) MAX((A),0)

#define NOT_NULL_STRING(str, default) (NULLString(str)?default:str)
#define NOT_NULL_STRING_DEFAULT_EMPTY(str) NOT_NULL_STRING(str,@"")


/**
 *  获取window
 */
#define __CURRENT_WINDOW  [[[UIApplication sharedApplication] delegate] window]


/**
 *  MainScreen Height&Width
 */
#define __MAIN_SCREEN_HEIGHT__      MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)
#define __MAIN_SCREEN_WIDTH__       MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)
#define __MAIN_SCREEN_BOUNDS__      [[UIScreen mainScreen] bounds]
/**
 *  statusBar Frame & Width & Height
 */
#define __STATUS_BAR_HEIGHT__   (20)

/**
 * 导航栏高度
 */
#define __NAV_BAR_HEIGHT__      (44)

/**
 * TabBar高度
 */
#define __TAB_BAR_HEIGHT__      (49)
//屏幕适配
#define __MLSWidth(w)      (w/375.0)*__MAIN_SCREEN_WIDTH__
#define __MLSHeight(w)      (w/667.0)*__MAIN_SCREEN_HEIGHT__

/// 版本判断
#define IOS_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define IOS_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define IOS_VERSION_LESS_THAN(v)                ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define IOS_VERSION_LESS_THAN_OR_EQUAL_TO(v)    ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

/// MARK: -- Assert
#ifdef DEBUG

#define DebugAssert(condition, desc, ...) NSAssert(condition, desc, ##__VA_ARGS__)

#else

#define DebugAssert(condition, desc, ...)

#endif

#endif /* BBMarcoDefine_h */
