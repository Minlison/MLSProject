//
//  BaseModel.m
//  MinLison
//
//  Created by MinLison on 2017/8/31.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseModel.h"


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

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic
{
        if (!dic)
        {
                return dic;
        }
        
        NSDictionary <NSString *,id>*nonnullDict = [self nonnullDefaultValueProperties];
        
        if (!nonnullDict)
        {
                return dic;
        }
        
        NSMutableDictionary *orangleDict = [NSMutableDictionary dictionaryWithDictionary:dic];
        
        for (NSString *key in nonnullDict.allKeys)
        {
                if ([orangleDict objectForKey:key] == nil)
                {
                        [orangleDict setObject:[nonnullDict objectForKey:key] forKey:key];
                }
        }
        
        return orangleDict;
}

- (NSString *)description
{
        return [self modelToJSONObject];
}
- (NSString *)debugDescription
{
        return [self modelDescription];
}
- (nullable NSDictionary <NSString *,id>*)nonnullDefaultValueProperties
{
        return nil;
}
@end
