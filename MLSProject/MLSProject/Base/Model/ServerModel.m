//
//  ServerModel.m
//  MLSProject
//
//  Created by MinLison on 2017/8/31.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "ServerModel.h"

@implementation ServerModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper
{
        return @{
                 @"code" : @"status",
                 @"msg" : @"status_desc",
                 @"remark" : @"status_desc_remarks"
                 };
}
- (BOOL)isValid
{
        if (self.code == APP_ERROR_CODE_SUCCESS)
        {
                return YES;
        }
        return NO;
}
- (NSError *)validError
{
        if ([self isValid])
        {
                return nil;
        }
        return [NSError appErrorWithCode:self.code msg:self.msg remark:self.remark];
}
@end
