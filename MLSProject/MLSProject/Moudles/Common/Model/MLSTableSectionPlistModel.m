//
//  WGCellPlistModel.m
//  MinLison
//
//  Created by MinLison on 2017/11/1.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSTableSectionPlistModel.h"

@implementation MLSTableSectionPlistModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass
{
        MLSTableSectionPlistModel *model;
        return @{
                  @keypath(model,header) : [MLSCellHeaderFooterPlistModel class],
                  @keypath(model,content) : [MLSPlistModel class],
                  @keypath(model,footer) : [MLSCellHeaderFooterPlistModel class],
                 };
}
@end
