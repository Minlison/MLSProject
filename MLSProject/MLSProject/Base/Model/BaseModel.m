//
//  BaseModel.m
//  MLSProject
//
//  Created by MinLison on 2017/8/31.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseModel.h"
#import "NSObject+JKAutoCoding.h"

@implementation BaseModel
- (BOOL)isValid
{
        return YES;
}
- (NSError *)validError
{
        return nil;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {};
- (NSString *)description
{
        return [self modelToJSONObject];
}
- (NSString *)debugDescription
{
        return [self modelDescription];
}
@end
