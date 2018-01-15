//
//  MLSBannerListModel.m
//  MLSProject
//
//  Created by MinLison on 2017/12/16.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "MLSBannerListModel.h"

@implementation MLSBannerListModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass
{
        MLSBannerListModel *model;
        return @{
                 @keypath(model,list) : [MLSBannerModel class]
                 };
}
@end
