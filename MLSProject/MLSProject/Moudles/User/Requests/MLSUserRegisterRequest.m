//
//  MLSUserRegisterRequest.m
//  MLSProject
//
//  Created by MinLison on 2017/12/12.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "MLSUserRegisterRequest.h"

@implementation MLSUserRegisterRequest
- (Class)contentType
{
        return [MLSUserModel class];
}
- (BOOL)blockSelfUntilDone
{
        return YES;
}
- (NSString *)url
{
        return @"/api.php/login/register";
}
@end
