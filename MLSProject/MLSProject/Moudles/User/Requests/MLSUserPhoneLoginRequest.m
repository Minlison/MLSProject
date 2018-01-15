//
//  MLSUserPhoneLoginRequest.m
//  MinLison
//
//  Created by MinLison on 2017/11/1.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSUserPhoneLoginRequest.h"

@implementation MLSUserPhoneLoginRequest
- (Class)contentType
{
        return [MLSUserModel class];
}
- (NSString *)url
{
        return @"/api.php/login/mobilelogin";
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
