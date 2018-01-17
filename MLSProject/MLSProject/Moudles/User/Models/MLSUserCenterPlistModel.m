//
//  MLSUserCenterPlistModel.m
//  MinLison
//
//  Created by MinLison on 2017/11/1.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSUserCenterPlistModel.h"
#import "MLSUserCenterCellModel.h"
@implementation MLSUserCenterPlistModel

+ (NSArray <MLSUserCenterPlistModel *>*)defaultUserCenterModels
{
        NSString *contentPath = [[NSBundle mainBundle] pathForResource:@"WGUserCenter" ofType:@"plist"];
        if (NULLString(contentPath)) {
                return nil;
        }
        NSArray *content = [[NSArray alloc] initWithContentsOfFile:contentPath];
        return [NSArray modelArrayWithClass:[MLSUserCenterPlistModel class] json:content];
}
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass
{
        MLSUserCenterPlistModel *model;
        return @{
                 @keypath(model,header) : [MLSCellHeaderFooterPlistModel class],
                  @keypath(model,content) : [MLSUserCenterCellModel class],
                  @keypath(model,footer) : [MLSCellHeaderFooterPlistModel class],
                  };
}
@end
