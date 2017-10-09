//
//  MLSSignManager.m
//  MLSProject
//
//  Created by MinLison on 2017/10/09.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSSignManager.h"
#import "Cache.h"
#define PrivateSignCache [Cache signCache]

@implementation MLSSignManager
+ (nullable NSString *)getSignForVersion:(NSString *)version
{
        if (version)
        {
                return (NSString *)[PrivateSignCache objectForKey:version];
        }
        return nil;
}
+ (void)storeSign:(NSString *)sign forVersion:(NSString *)version
{
        if (version && sign)
        {
                [PrivateSignCache setObject:sign forKey:version];
        }
}
+ (void)cleanSignForVersion:(NSString *)version
{
        if (version)
        {
                [PrivateSignCache removeObjectForKey:version];
        }
}

+ (void)cleanAllSign
{
        [PrivateSignCache removeAllObjects];
}
@end

