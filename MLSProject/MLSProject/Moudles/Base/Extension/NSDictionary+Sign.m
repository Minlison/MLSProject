//
//  NSDictionary+Sign.m
//  MinLison
//
//  Created by MinLison on 2017/9/29.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "NSDictionary+Sign.h"

@implementation NSDictionary (Sign)
- (nullable NSString *)versionValue
{
        return [self jk_stringForKey:kRequestKeyMethodVersion];
}

- (nullable NSString *)methodValue
{
        return [self jk_stringForKey:kRequestKeyMethod];
}
@end
