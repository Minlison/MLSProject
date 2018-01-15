//
//  MLSUpdateRequest.m
//  MinLison
//
//  Created by MinLison on 2017/10/10.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSUpdateRequest.h"

@implementation MLSUpdateRequest

- (Class)contentType
{
        return [MLSUpdateModel class];
}
- (NSString *)url
{
        return @"";
}
- (NSMutableDictionary *)defaultParams
{
        NSMutableDictionary *dict = [super defaultParams];
        [dict setObject:[AppUnit buldleID] forKey:kRequestKeyPackage_Name];
        [dict setObject:[AppUnit build] forKey:kRequestKeyVersion_Code];
        return dict;
}

@end
