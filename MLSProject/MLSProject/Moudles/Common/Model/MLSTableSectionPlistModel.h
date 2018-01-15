//
//  MLSTableSectionPlistModel.h
//  MinLison
//
//  Created by MinLison on 2017/11/1.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseModel.h"
#import "MLSPlistModel.h"
#import "MLSCellHeaderFooterPlistModel.h"
@interface MLSTableSectionPlistModel : BaseModel

/**
 顶部（Section）
 */
@property(nonatomic, strong) MLSCellHeaderFooterPlistModel *header;

/**
 内容
 */
@property(nonatomic, strong) NSArray <MLSPlistModel *>*content;

/**
 底部（Section）
 */
@property(nonatomic, strong) MLSCellHeaderFooterPlistModel *footer;

@end
