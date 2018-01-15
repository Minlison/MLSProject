//
//  NSString+IDCardNumberValidator.h
//  IDCardNumber-Validation-Demo
//
//  Created by Vincent on 2/26/16.
//  Copyright © 2016 Vincent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (IDCardNumberValidator)
- (BOOL)validIDCardNumber;

/**
 校验身份证号，并返回格式化生日

 @param fmt 格式化
 @return 生日
 */
- (NSString *)validIDCardNumberWithBrithdayFmt:(NSString *)fmt;
@end
