//
//  NSError+AppError.m
//  MLSProject
//
//  Created by MinLison on 2017/8/31.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "NSError+AppError.h"

@implementation NSError (AppError)
+ (NSError *)appErrorWithCode:(NSInteger)code msg:(NSString *)msg remark:(NSString *)remark
{
        NSError *error = [NSError errorWithDomain:@"AppError" code:code userInfo:@{NSLocalizedFailureReasonErrorKey : remark?:@"未知原因",NSLocalizedDescriptionKey : msg?:[NSString app_NeworkError]}];
        return error;
}
@end
