//
//  MLSTipPicModel.m
//  MLSProject
//
//  Created by MinLison on 2017/10/9.
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
