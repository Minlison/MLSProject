//
//  MLSUpdateModel.h
//  MLSProject
//
//  Created by MinLison on 2017/10/10.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseModel.h"
#import "MLSUpdateEnum.h"
@interface MLSUpdateModel : BaseModel

/**
 大版本号 1.0.0
 */
@property(nonatomic, copy) NSString *version;

/**
 build 版本号 20171010122435
 */
@property(nonatomic, copy) NSString *version_code;

/**
 升级类型
 */
@property(nonatomic, assign) MLSUpdateType update_type;

/**
 内容
 */
@property(nonatomic, copy) NSString *content;

/**
 地址
 */
@property(nonatomic, copy) NSString *url;

@end
