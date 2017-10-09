//
//  NSDictionary+RouterParams.m
//  MLSProject
//
//  Created by MinLison on 2017/9/12.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "NSDictionary+RouterParams.h"

@implementation NSDictionary (RouterParams)
- (NSString *)routerParams
{
        NSMutableString *tmpStr = [[NSMutableString alloc] init];
        [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                if (tmpStr.length > 0)
                {
                        [tmpStr appendString:@"&"];
                }
                [tmpStr appendFormat:@"%@=%@",key,obj];
        }];
        
        return tmpStr;
}
@end
