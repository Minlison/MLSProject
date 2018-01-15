//
//  ServerModel.m
//  MinLison
//
//  Created by MinLison on 2017/8/31.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "ServerModel.h"

@implementation ServerModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper
{
        return @{
                 @"code" : @[@"status",@"code"],
                 @"msg" : @[@"status_desc",@"message"],
                 @"remark" : @"status_desc_remarks",
                 @"content" : @[@"data",@"content"],
                 };
}
- (NSString *)msg
{
        if (NULLString(_msg)) {
                _msg = [NSString app_RequestNormalError];
        }
        return _msg;
}
- (id)content
{
        if (!_content && [self isValid]) {
                _content = self.msg;
        }
        return _content;
}
- (BOOL)isValid
{
        if (self.code == APP_ERROR_CODE_SUCCESS || self.code == 0)
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
