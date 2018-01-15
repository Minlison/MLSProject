//
//  MLSBannerListModel.h
//  MLSProject
//
//  Created by MinLison on 2017/12/16.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "BaseModel.h"
#import "MLSBannerModel.h"
@interface MLSBannerListModel : BaseModel
@property(nonatomic, strong) NSArray <MLSBannerModel *> *list;
@end
