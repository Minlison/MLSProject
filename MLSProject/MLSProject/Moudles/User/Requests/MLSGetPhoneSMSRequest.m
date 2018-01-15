//
//  MLSGetPhoneSMSRequest.m
//  MinLison
//
//  Created by MinLison on 2017/11/2.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSGetPhoneSMSRequest.h"

@implementation MLSGetPhoneSMSRequest

- (BOOL)blockSelfUntilDone
{
        return YES;
}
- (BOOL)needCache
{
        return NO;
}
- (NSString *)url
{
        return @"/api.php/login/sendmsg";
}
@end
