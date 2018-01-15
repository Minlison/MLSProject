//
//  MLSTipPicModel.m
//  MinLison
//
//  Created by minlison on 2017/9/10.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSTipPicModel.h"

@implementation MLSTipPicModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper
{
        return @{
                 @"desc" : @"description",
                 };
}

@end
