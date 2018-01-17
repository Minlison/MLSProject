//
//  MLSPwdCondition.m
//  MLSProject
//
//  Created by MinLison on 2017/12/12.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "MLSPwdCondition.h"

@implementation MLSPwdCondition
- (BOOL)check:(NSString *)string
{
        self.currentCheckString = string.copy;
        if (NULLString(string) || ![CoBaseUtils isNumber:string])
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
        return [CoBaseUtils isNumber:self.currentCheckString];
}
@end
