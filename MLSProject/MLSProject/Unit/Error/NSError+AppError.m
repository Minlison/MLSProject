//
//  NSError+AppError.m
//  MinLison
//
//  Created by MinLison on 2017/8/31.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "NSError+AppError.h"
static NSString *const NSErrorApperrorKey = @"NSErrorApperrorKey";
static NSString *const NSErrorApperrorValue = @"NSErrorApperrorValue";
@implementation NSError (AppError)
+ (NSError *)appErrorWithCode:(NSInteger)code msg:(NSString *)msg remark:(NSString *)remark
{
        NSError *error = [NSError errorWithDomain:@"AppError" code:code userInfo:@{NSLocalizedFailureReasonErrorKey : remark?:@"未知原因",NSLocalizedDescriptionKey : msg?:[NSString app_RequestNormalError],NSErrorApperrorKey:NSErrorApperrorValue}];
        return error;
}
- (BOOL)isAppError
{
        return [self.userInfo valueForKey:NSErrorApperrorKey] != nil;
}
@end
