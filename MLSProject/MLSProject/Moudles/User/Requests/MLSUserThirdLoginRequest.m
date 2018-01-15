//
//  MLSUserThirdLoginRequest.m
//  MinLison
//
//  Created by MinLison on 2017/11/1.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSUserThirdLoginRequest.h"
#import "MLSUserModel.h"
@implementation MLSUserThirdLoginRequest
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
