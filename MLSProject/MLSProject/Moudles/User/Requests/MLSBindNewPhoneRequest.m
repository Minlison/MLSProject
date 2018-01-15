//
//  MLSBindNewPhoneRequest.m
//  MinLison
//
//  Created by MinLison on 2017/11/3.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSBindNewPhoneRequest.h"

@implementation MLSBindNewPhoneRequest
- (Class)contentType
{
        return [MLSUserModel class];
}
- (NSString *)url
{
        return @"/api.php/login/bindmobile";
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
