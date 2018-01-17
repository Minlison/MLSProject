//
//  MLSUpdateViewModel.m
//  MinLison
//
//  Created by MinLison on 2017/10/10.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSUpdateViewModel.h"
#import "Cache.h"
#define WGUpdateLaterClickDateKey @"WGUpdateLaterClickDate"

@implementation MLSUpdateViewModel
- (BOOL)canShow
{
        NSString *currentBuild = [AppUnit build];
        NSString *serverBuild = self.model.version_code;
        NSDate *date = (NSDate *)[ShareStaticCache objectForKey:WGUpdateLaterClickDateKey];
        NSDate *currentDate = [NSDate date];
        BOOL serverRequireUpdate = (serverBuild.unsignedLongLongValue > currentBuild.unsignedLongLongValue);
        
        if (date == nil)
        {
                return serverRequireUpdate;
        }
#if (DEBUG || ADHoc)
        else if (currentDate.timeIntervalSince1970 - date.timeIntervalSince1970 > 30) // 30s后提醒
#else
        else if ([currentDate jk_daysAfterDate:date] > 2) // 2天后提醒
#endif
        {
                return serverRequireUpdate;
        }
        return NO;
}
- (void)updateNow
{
        [self latter];
        if ( NULLString(self.model.url) )
        {
                [UIViewController jk_openAppURLForIdentifier:APP_ID.unsignedLongLongValue];
        }
        else
        {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:NOT_NULL_STRING_DEFAULT_EMPTY(self.model.url)]];
        }
        
}
- (void)latter
{
        [ShareStaticCache setObject:[NSDate date] forKey:WGUpdateLaterClickDateKey];
}
@end
