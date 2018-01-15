//
//  MLSSMSCondition.m
//  MinLison
//
//  Created by MinLison on 2017/11/3.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSSMSCondition.h"
#import "MLSPhoneCondition.h"
@implementation MLSSMSCondition
- (BOOL)check:(NSString *)string
{
        self.currentCheckString = string.copy;
        if (NULLString(string) || ![[MLSPhoneCondition condition] check:LNUserManager.mobile] || ![CoBaseUtils isNumber:string])
        {
                return NO;
        }
        return YES;
}

- (NSString *)violationResultString
{
        return self.currentCheckString;
}
#pragma mark - Allow violation

- (BOOL)shouldAllowViolation
{
        return [[MLSPhoneCondition condition] check:LNUserManager.mobile] || [CoBaseUtils isNumber:self.currentCheckString];
}
@end
