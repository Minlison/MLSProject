//
//  MLSRefreshTokenRequest.m
//  MinLison
//
//  Created by MinLison on 2017/11/3.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSRefreshTokenRequest.h"

@implementation MLSRefreshTokenRequest

- (NSMutableDictionary *)defaultParams
{
        NSMutableDictionary *dict = [super defaultParams];
        [dict addEntriesFromDictionary:@{
                                         kRequestKeyUser_ID : NOT_NULL_STRING(LNUserManager.uid, @"0"),
                                         kRequestKeyToken : NOT_NULL_STRING_DEFAULT_EMPTY(LNUserManager.token),
                                         kRequestKeyRefresh_Token : NOT_NULL_STRING_DEFAULT_EMPTY(LNUserManager.refresh_token),
                                         }];
        return dict;
}
- (Class)contentType
{
        return [MLSUserModel class];
}


- (BOOL)blockSelfUntilDone
{
        return YES;
}
- (BOOL)needCache
{
        return NO;
}
@end
