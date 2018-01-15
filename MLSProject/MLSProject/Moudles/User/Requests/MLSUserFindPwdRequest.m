//
//  MLSUserFindPwdRequest.m
//  MLSProject
//
//  Created by MinLison on 2017/12/12.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "MLSUserFindPwdRequest.h"

@implementation MLSUserFindPwdRequest
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
        return @"/api.php/login/forget";
}
@end
