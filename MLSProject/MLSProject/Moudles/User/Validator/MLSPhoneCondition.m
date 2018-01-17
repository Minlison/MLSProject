//
//  MLSPhoneCondition.m
//  MinLison
//
//  Created by MinLison on 2017/11/3.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSPhoneCondition.h"
#import "NBPhoneNumberUtil.h"
#import "NBPhoneNumber.h"

@interface MLSPhoneCondition ()
@property(nonatomic, strong) NBPhoneNumberUtil *phoneNumUtil;
@end

@implementation MLSPhoneCondition
- (BOOL)check:(NSString *)string
{
        self.currentCheckString = string.copy;
        NSError *error = nil;
        BOOL res = NO;

        NSString *addCountryCodeNum = [NSString stringWithFormat:@"+%@%@",MLSUserManager.country_code,string];
        NBPhoneNumber *phoneNumber = [self.phoneNumUtil parseWithPhoneCarrierRegion:addCountryCodeNum error:&error];
        res = [self.phoneNumUtil isValidNumber:phoneNumber];
        
        return res;
}
- (NSString *)violationResultString
{
        return self.currentCheckString;
}
- (NBPhoneNumberUtil *)phoneNumUtil
{
        if (!_phoneNumUtil) {
                _phoneNumUtil = [[NBPhoneNumberUtil alloc] init];
        }
        return _phoneNumUtil;
}

#pragma mark - Allow violation

- (BOOL)shouldAllowViolation
{
        return YES;
}

@end
