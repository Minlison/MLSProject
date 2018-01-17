//
//  MLSUserCenterPlistModel.h
//  MinLison
//
//  Created by MinLison on 2017/11/1.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseModel.h"
#import "MLSUserCenterCellModel.h"
#import "MLSCellHeaderFooterPlistModel.h"
@interface MLSUserCenterPlistModel : BaseModel

/**
 顶部（Section）
 */
@property(nonatomic, strong) MLSCellHeaderFooterPlistModel *header;

/**
 内容
 */
@property(nonatomic, strong) NSArray <MLSUserCenterCellModel *>*content;

/**
 底部（Section）
 */
@property(nonatomic, strong) MLSCellHeaderFooterPlistModel *footer;

/**
  默认用户中心配置
 */
+ (NSArray <MLSUserCenterPlistModel *>*)defaultUserCenterModels;

@end
