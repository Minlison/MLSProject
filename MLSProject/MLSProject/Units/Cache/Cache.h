//
//  Cache.h
//  MLSProject
//
//  Created by MinLison on 2017/8/31.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ShareDefaultCache [Cache shareCache]
#define ShareStaticCache [Cache staticCache]

@interface Cache : YYCache
/**
 会自动清理缓存
 */
+ (instancetype)shareCache;

/**
  持久性缓存, 除非卸载应用,否则不清理缓存
 */
+ (instancetype)staticCache;

/**
 签名缓存
 缓存时长 24 小时
 @return 签名缓存
 */
+ (instancetype)signCache;

/**
 清理缓存
 @param async 是否异步
 @param completion 完成回调
 */
+ (void)clearCache:(BOOL)async completion:(void (^)(BOOL success))completion;


/**
 充值 NSUserDefaluts
 */
+ (void)resetDefaults;

/**
 清理 webview 的缓存
 */
+ (void)clearWebViewCache;

/**
 缓存大小
 包括 SDWebImage 的默认缓存
 @return 缓存大小
 */
+ (NSString *)totalCacheSize;
@end
