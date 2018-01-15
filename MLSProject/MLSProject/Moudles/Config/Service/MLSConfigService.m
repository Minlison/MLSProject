//
//  MLSConfigService.m
//  MinLison
//
//  Created by MinLison on 2017/11/17.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSConfigService.h"

@implementation MLSConfigService
+ (void)setServerAddress:(NSString *)serverAddress
{
        [[NSUserDefaults standardUserDefaults] setObject:serverAddress forKey:@"WGServerAddressKey"];
}
+ (NSString *)serverAddress
{
        return [[NSUserDefaults standardUserDefaults] objectForKey:@"WGServerAddressKey"] ? : kRequestUrlBaseTest;
}
@end
