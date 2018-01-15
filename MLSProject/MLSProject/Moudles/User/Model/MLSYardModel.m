//
//  MLSYardModel.m
//  MLSProject
//
//  Created by MinLison on 2017/12/1.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "MLSYardModel.h"

@implementation MLSYardModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper
{
        return @{
                 @"area_id" : @[@"area_id",@"yuanquid"]
                 };
}
@end
