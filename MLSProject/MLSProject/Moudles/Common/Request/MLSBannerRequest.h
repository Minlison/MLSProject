//
//  MLSBannerRequest.h
//  MLSProject
//
//  Created by MinLison on 2017/12/1.
//  Copyright © 2017年 mlsproject. All rights reserved.
//

#import "BaseRequest.h"
#import "MLSBannerListModel.h"
@interface MLSBannerRequest : BaseRequest <MLSBannerListModel *>
@property(nonatomic, assign) LNBannerRequestType type;
+ (instancetype)requestWithType:(LNBannerRequestType)type;
@end
