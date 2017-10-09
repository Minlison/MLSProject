//
//  ServerModel.h
//  MLSProject
//
//  Created by MinLison on 2017/8/31.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseModel.h"

/**
 服务器指定数据模型
 */
@interface ServerModel : BaseModel

/**
 数据内容 (NSArray* , NSDictionary*, NSString*)
 */
@property(nonatomic, strong, nullable) id content;


/**
 content 字典转过模型的数据 (NSArray<BaseModel *>*, BaseModel*)
 */
@property(nonatomic, strong, nullable) id modelContent;

/**
 状态码
 */
@property(nonatomic, assign) NSInteger code;

/**
 提示信息
 */
@property(nonatomic, copy, nullable) NSString *msg;

/**
 debug 信息
 */
@property(nonatomic, copy, nullable) NSString *remark;


@end
