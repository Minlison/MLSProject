//
//  WGModifyUserInfoRequest.m
//  MinLison
//
//  Created by MinLison on 2017/11/3.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSUpdateUserInfoRequest.h"

@implementation MLSUpdateUserInfoRequest
- (Class)contentType
{
        return [MLSUserModel class];
}
- (NSString *)url
{
        return @"/api.php/user/xxiugai";
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
