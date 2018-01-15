//
//  MLSPgyerUpdateModel.m
//  MinLison
//
//  Created by MinLison on 2017/11/20.
//  Copyright © 2017年 minlison. All rights reserved.
//
#import "MLSPgyerUpdateModel.h"
#if WGEnablePgyerSDK

@implementation MLSPgyerUpdateModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass
{
        return @{
                 @"otherApps" : [MLSPgyerUpdateModel class],
                 };
}
- (NSString *)buildDonwloadUrl
{
        return self.buildShortcutUrl;
}
- (NSString *)buildShortcutUrl
{
        return [NSString stringWithFormat:@"https://www.pgyer.com/%@",_buildShortcutUrl];
}
@end
#endif
