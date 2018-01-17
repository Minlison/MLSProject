//
//  MLSEmptyCommentModel.h
//  MinLison
//
//  Created by MinLison on 2017/11/16.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "BaseModel.h"

@interface MLSEmptyCommentModel : BaseModel <NICellObject>

/**
 显示的文字内容
 */
@property(nonatomic, copy) NSString *emptyContent;

/**
 快速创建空视图模型数据

 @return 空视图模型数据
 */
+ (instancetype)emptyModel;
@end

