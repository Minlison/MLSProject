//
//  IDCardNumberValidator.h
//  IDCardNumber-Validation-Demo
//
//  Created by Vincent on 2/26/16.
//  Copyright © 2016 Vincent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDCardNumberValidator : NSObject
+ (BOOL)validateIDCardNumber:(NSString *)idNumber;
@end
