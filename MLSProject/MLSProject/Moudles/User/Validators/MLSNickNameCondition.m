//
//  MLSNickNameCondition.m
//  MinLison
//
//  Created by MinLison on 2017/11/5.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSNickNameCondition.h"
#import "NSString+Emoji.h"
@implementation MLSNickNameCondition
- (BOOL)check:(NSString *)string
{
//        self.currentCheckString = string.copy;
//        if (NULLString(string) || [string isIncludingEmoji]) {
//                self.currentCheckString = [string jk_removingEmoji];
//                return NO;
//        }
        return YES;
}
- (NSString *)violationResultString
{
        return self.currentCheckString;
}

#pragma mark - Allow violation

- (BOOL)shouldAllowViolation
{
        return NO;
}
@end
