//
//  MLSIDNumberCondation.m
//  MLSProject
//
//  Created by MinLison on 2017/12/26.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "MLSIDNumberCondation.h"
@implementation MLSIDNumberCondation
- (BOOL)check:(NSString *)string
{
        self.currentCheckString = string.copy;
        if (NULLString(string) || ![CoBaseUtils isIDNumber:string])
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
        return YES;
}
@end
