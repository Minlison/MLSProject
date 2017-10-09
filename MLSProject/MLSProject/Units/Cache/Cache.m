//
//  Cache.m
//  MLSProject
//
//  Created by MinLison on 2017/8/31.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "Cache.h"
/** 从服务器读取数据在本地数据库保存时间 */
#define LOCAL_CACHE_TIME (5 * 60)      // 5 * 60

/** 从服务器读取数据在内存中 */
#define LOCAL_DIC_TIME (1 * 60)         // 1 * 60

/**内存检测时间*/
#define LOCAL_AUTO_TIME     (30)    // 10

#define CUSTOM_CACHE_COUNT (10000)

@implementation Cache

+ (instancetype)shareCache
{
        static Cache * instance = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                instance = [[self alloc] initWithName:@"com.minlison.jsoncache"];
                
                instance.diskCache.autoTrimInterval = LOCAL_AUTO_TIME;
                instance.diskCache.ageLimit = LOCAL_CACHE_TIME;
                instance.diskCache.costLimit = CUSTOM_CACHE_COUNT;
                
                instance.memoryCache.autoTrimInterval = LOCAL_AUTO_TIME;
                instance.memoryCache.ageLimit = LOCAL_DIC_TIME;
                instance.memoryCache.costLimit = CUSTOM_CACHE_COUNT;
        });
        return instance;
}
+ (instancetype)staticCache
{
        static Cache * instance = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                instance = [[self alloc] initWithName:@"com.minlison.staticcache"];
                
                instance.diskCache.autoTrimInterval = NSIntegerMax;
                instance.diskCache.ageLimit = NSIntegerMax;
                instance.diskCache.costLimit = NSIntegerMax;
                
                instance.memoryCache.autoTrimInterval = NSIntegerMax;
                instance.memoryCache.ageLimit = NSIntegerMax;
                instance.memoryCache.costLimit = NSIntegerMax;
        });
        return instance;
}
+ (instancetype)signCache
{
        static Cache * instance = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                instance = [[self alloc] initWithName:@"com.minlison.signcache"];
                
                instance.diskCache.autoTrimInterval = NSIntegerMax;
                instance.diskCache.ageLimit = 43200; //24 * 60 * 60;
                instance.diskCache.costLimit = CUSTOM_CACHE_COUNT;
                
                instance.memoryCache.autoTrimInterval = NSIntegerMax;
                instance.memoryCache.ageLimit = 43200;
                instance.memoryCache.costLimit = CUSTOM_CACHE_COUNT;
        });
        return instance;
}
+ (void)clearCache:(BOOL)async completion:(void (^)(BOOL))completion
{
        // 删除cookie缓存
        @try {
                [[NSHTTPCookieStorage sharedHTTPCookieStorage] removeCookiesSinceDate:[NSDate dateWithTimeIntervalSince1970:0]];
        } @catch (NSException *exception) {
        } @finally {
        }
        
        [self deleteTempFileContent];
        
        [self resetDefaults];
        
        [[SDImageCache sharedImageCache] clearMemory];
        
        dispatch_group_t group = dispatch_group_create();
        dispatch_group_enter(group);
        
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                dispatch_group_leave(group);
        }];
        
        dispatch_group_enter(group);
        [[self shareCache] removeAllObjectsWithProgressBlock:nil endBlock:^(BOOL error) {
                dispatch_group_leave(group);
        }];
        
        dispatch_group_enter(group);
        [[self staticCache] removeAllObjectsWithProgressBlock:nil endBlock:^(BOOL error) {
                dispatch_group_leave(group);
        }];
        
        if (async) {
                dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                        completion(YES);
                });
        } else {
                
                dispatch_group_wait(group, dispatch_time(DISPATCH_TIME_NOW, (10 * NSEC_PER_SEC)));
                completion(YES);
        }
}
+ (NSString *)totalCacheSize
{
        NSUInteger imageSize = [[SDImageCache sharedImageCache] getSize];
        // bytes
        NSUInteger dataSize = ShareDefaultCache.diskCache.totalCost;
        
        
        return [self getSizeStringWithBytes:(imageSize + dataSize)];
        
}
+ (NSString *)getSizeStringWithBytes:(NSUInteger)bytes
{
        NSString *tmp = @"";
        // KB
        if (bytes > 0){
                tmp = [NSString stringWithFormat:@"%.2fMB",(CGFloat)(bytes * 1.0) / (2 << 20)];
        }
        // GB
        else if (bytes > (2 << 30))
        {
                tmp = [NSString stringWithFormat:@"%.2fGB",(CGFloat)(bytes * 1.0) / (2 << 30)];
        }
        return tmp;
}
+ (void)clearWebViewCache
{
        // 清理webView的内存缓存
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];
        [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (void)resetDefaults {
        
        [NSUserDefaults resetStandardUserDefaults];
        
        //    [NSUserDefaults resetStandardUserDefaults];
        //
        //    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
        //
        //    NSDictionary* dict = [defs dictionaryRepresentation];
        //
        //    for(id key in dict) {
        //
        //        [defs removeObjectForKey:key];
        //
        //    }
        //
        //    [defs synchronize];
        
        
        NSString*appDomain = [[NSBundle mainBundle] bundleIdentifier];
        
        [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
        
}
+ (void)deleteTempFileContent
{
        NSString *tempPath = NSTemporaryDirectory();
        NSArray *contents  = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:tempPath error:NULL];
        NSEnumerator *e    = [contents objectEnumerator];
        NSString *filename;
        while ((filename = [e nextObject]))
        {
                
                [[NSFileManager defaultManager] removeItemAtPath:[tempPath stringByAppendingPathComponent:filename] error:NULL];
        }
}
@end
