//
//  IDCardNumberValidator.m
//  IDCardNumber-Validation-Demo
//
//  Created by Vincent on 2/26/16.
//  Copyright © 2016 Vincent. All rights reserved.
//

#import "IDCardNumberValidator.h"

@implementation IDCardNumberValidator
/// 验证身份证号码
+ (BOOL)validateIDCardNumber:(NSString *)idNumber {
    NSString *regex = @"(^\\d{15}$)|(^\\d{17}([0-9]|X)$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![predicate evaluateWithObject:idNumber]) return NO;
    // 省份代码。如果需要更精确的话，可以把六位行政区划代码都列举出来比较。
    NSString *provinceCode = [idNumber substringToIndex:2];
    NSArray *proviceCodes = @[@"11", @"12", @"13", @"14", @"15",
                              @"21", @"22", @"23",
                              @"31", @"32", @"33", @"34", @"35", @"36", @"37",
                              @"41", @"42", @"43", @"44", @"45", @"46",
                              @"50", @"51", @"52", @"53", @"54",
                              @"61", @"62", @"63", @"64", @"65",
                              @"71", @"81", @"82", @"91"];
    if (![proviceCodes containsObject:provinceCode]) return NO;
    
    if (idNumber.length == 15) {
        return [self validate15DigitsIDCardNumber:idNumber];
    } else {
        return [self validate18DigitsIDCardNumber:idNumber];
    }
}

#pragma mark Helpers
/// 15位身份证号码验证。6位行政区划代码 + 6位出生日期码(yyMMdd) + 3位顺序码
+ (BOOL)validate15DigitsIDCardNumber:(NSString *)idNumber {
    NSString *birthday = [NSString stringWithFormat:@"19%@", [idNumber substringWithRange:NSMakeRange(6, 6)]]; // 00后都是18位的身份证号
    
    return [self validateBirthDate:birthday];
}

/// 18位身份证号码验证。6位行政区划代码 + 8位出生日期码(yyyyMMdd) + 3位顺序码 + 1位校验码
+ (BOOL)validate18DigitsIDCardNumber:(NSString *)idNumber {
    NSString *birthday = [idNumber substringWithRange:NSMakeRange(6, 8)];
    if (![self validateBirthDate:birthday]) return NO;
    
    // 验证校验码
    int weight[] = {7,9,10,5,8,4,2,1,6,3,7,9,10,5,8,4,2};
    
    int sum = 0;
    for (int i = 0; i < 17; i ++) {
        sum += [idNumber substringWithRange:NSMakeRange(i, 1)].intValue * weight[i];
    }
    int mod11 = sum % 11;
    NSArray<NSString *> *validationCodes = [@"1 0 X 9 8 7 6 5 4 3 2" componentsSeparatedByString:@" "];
    NSString *validationCode = validationCodes[mod11];
    
    return [idNumber hasSuffix:validationCode];
}

/// 验证出生年月日(yyyyMMdd)
+ (BOOL)validateBirthDate:(NSString *)birthDay {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyyMMdd";
    NSDate *date = [dateFormatter dateFromString:birthDay];
    return date != nil;
}

@end
